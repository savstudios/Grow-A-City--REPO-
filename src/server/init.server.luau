-- Services

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- Variables

local events = ReplicatedStorage.Events
local functions = events.Functions

local PlayerStats = require(ReplicatedStorage.Shared.Player.PlayerStats)
local PlaceBuildings = require(ReplicatedStorage.Shared.Core:WaitForChild("PlaceBuilding"))

-- Functions

functions.GetData.OnServerInvoke = function(player)
   return PlayerStats.GetData(player)
end

functions.ChangeData.OnServerInvoke = function(player, data, value)
   return PlayerStats.ChangeData(player, data, value)
end

functions.AddData.OnServerInvoke = function(player, data, type, name)
   return PlayerStats.AddData(player, data, type, name)
end

-- Events

Players.PlayerAdded:Connect(PlayerStats.LoadData)
Players.PlayerAdded:Connect(function(player)
   local data

   repeat
      data = PlayerStats.GetData(player)
      task.wait(0.5)
   until data

   PlaceBuildings.playerLoaded(player, data)
end)
Players.PlayerRemoving:Connect(PlayerStats.SaveData)
game:BindToClose(PlayerStats.OnGameClose)