-- Services

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- Variables

local PlayerStats = require(ReplicatedStorage.Shared.Player.PlayerStats)

Players.PlayerAdded:Connect(PlayerStats.LoadData)
Players.PlayerRemoving:Connect(PlayerStats.SaveData)
game:BindToClose(PlayerStats.OnGameClose)