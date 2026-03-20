--[[ Game Check ]]--
if game.PlaceId ~= 119048529960596 and game.PlaceId ~= 99889627739043 then
    game.Players.LocalPlayer:Kick("Game Not Supported. Only Restaurant Tycoon 3 Is Supported")
return end
-- Added Game Check Not In Obfuscated Code, Because Fucking Prometheus Obfuscator Broking Game Check

loadstring(game:HttpGet('https://raw.githubusercontent.com/DCBeta101/DCHub/refs/heads/main/update.lua'))()