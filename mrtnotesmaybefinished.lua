if start is clicked, click flag, click drag, click start, drive





local startbutton = PlayerGui.GUI123.Frame.StartButton
local EventsButton = Players.LocalPlayer.PlayerGui.MainGUI.Buttons.EventsButton
local TeleportButton = Players.LocalPlayer.PlayerGui.MainGUI.Events.List."Sprint_Shirosato Quarter Mile Drag".TeleportButton

startbutton.MouseButton1Click:Connect(function()
    print("Start button was clicked!")
    -- Show the Events menu
    EventsMenu.Visible = true

    -- Clear old entries
    for _, child in pairs(EventsMenu.List:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Populate menu dynamically with all events
    for _, eventData in pairs(game.ReplicatedStorage.EventLib.EventsMetaData:GetChildren()) do
        local entry = EventsMenu.UIListLayout.EventsEntry:Clone()
        entry.EventName.Text = eventData.EventName.Value
        entry.EventType.Text = eventData.EventType.Value
        entry.PlayerCount.Text = "0/" .. eventData.MaxPlayerCount.Value
        entry.RewardXP.Text = "+" .. _G.Text.formatNumber(eventData.RewardXP.Value) .. "XP"
        entry.RewardYen.Text = "¥" .. _G.Text.formatNumber(eventData.RewardYen.Value)
        entry.RewardMultiplier.Text = eventData.RewardMultiplier.Value .. "X"
        if eventData.RewardMultiplier.Value == 1 then
            entry.RewardMultiplier.Visible = false
        end

        -- Connect **TeleportButton** inside this entry
        entry.TeleportButton.MouseButton1Click:Connect(function()
            local targetCFrame = CFrame.new(eventData.LocationCF.Value.p + Vector3.new(0,7,0))
            local character = game.Players.LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.SeatPart then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                pcall(function()
                    game.Players.LocalPlayer:RequestStreamAroundAsync(targetCFrame.p, 2)
                end)
                wait()
                character.HumanoidRootPart.CFrame = targetCFrame
                EventsMenu.Visible = false  -- hide the menu after teleport
            else
                warn("No character found")
            end
        end)

        entry.Parent = EventsMenu.List

    -- Get the teleport position
    local targetCFrame = CFrame.new(arg1.LocationCF.Value.p + Vector3.new(0, 7, 0))

    -- Get player character
    local character = game.Players.LocalPlayer.Character

    if character then
        local humanoid = character:FindFirstChild("Humanoid")

        -- If sitting, force jump
        if humanoid and humanoid.SeatPart then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        -- Load the area before teleporting
        pcall(function()
            game.Players.LocalPlayer:RequestStreamAroundAsync(targetCFrame.p, 2)
        end)

        wait()

        -- TELEPORT happens here
        character.HumanoidRootPart.CFrame = targetCFrame

        -- Hide the UI after teleport
        script.Parent.Visible = false
    else
        warn("No character found")
    end

end)