--gptmrtnotes

-- Start button script

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Reference your Events menu
local EventsMenu = playerGui.MainGUI.Events  -- adjust path if needed

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StartButtonGUI"
screenGui.Parent = playerGui

-- Create the Start button
local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Size = UDim2.new(0, 300, 0, 100)
startButton.Position = UDim2.new(0.5, -150, 0.5, -50)
startButton.AnchorPoint = Vector2.new(0.5, 0.5)
startButton.Text = "START"
startButton.Font = Enum.Font.SourceSansBold
startButton.TextSize = 40
startButton.TextColor3 = Color3.new(0, 0, 0)
startButton.BackgroundColor3 = Color3.new(1, 1, 1)
startButton.BorderSizePixel = 2
startButton.Parent = screenGui

-- Click handler
startButton.MouseButton1Click:Connect(function()
    print("Start button clicked!")

    -- Show the Events menu
    EventsMenu.Visible = true

    -- Clear old entries
    for _, child in pairs(EventsMenu.List:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Populate menu dynamically
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

        -- Connect TeleportButton for this entry
        entry.TeleportButton.MouseButton1Click:Connect(function()
            local targetCFrame = CFrame.new(eventData.LocationCF.Value.p + Vector3.new(0,7,0))
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.SeatPart then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                pcall(function()
                    player:RequestStreamAroundAsync(targetCFrame.p, 2)
                end)
                wait()
                character.HumanoidRootPart.CFrame = targetCFrame
                EventsMenu.Visible = false
            else
                warn("No character found")
            end
        end)

        entry.Parent = EventsMenu.List
    end
end)