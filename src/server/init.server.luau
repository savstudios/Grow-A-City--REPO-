-- Services

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- Variables

local events = ReplicatedStorage.Events
local functions = events.Functions

local PlayerStats = require(ReplicatedStorage.Shared.Player.PlayerStats)

-- Functions

functions.GetData.OnServerInvoke = function(player)
   return PlayerStats.GetData(player)
end

functions.ChangeData.OnServerInvoke = function(player, data, value)
   return PlayerStats.ChangeData(player, data, value)
end

-- Events

Players.PlayerAdded:Connect(PlayerStats.LoadData)
Players.PlayerRemoving:Connect(PlayerStats.SaveData)
game:BindToClose(PlayerStats.OnGameClose)