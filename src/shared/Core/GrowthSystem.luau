local GrowthSystem = {}

-- Services

local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- Variables

local player

local buildings = ReplicatedStorage.Buildings

local PlaceBuildings = require(ReplicatedStorage.Shared.Core.PlaceBuilding)

-- Functions

function GrowthSystem.GetPlayer(Player)
   player = Player

   -- Basic error checking
   if not Player.Name then warn("Argument passed is not a player!!")
end

function GrowthSystem.UpgradeBuilding(buildingData)
   buildingData.Stage = buildingData.Stage + 1
end

function GrowthSystem.UpdatePercentageAndStage()
   
end

function GrowthSystem.AddTax()
   
end

function GrowthSystem.CollectTax()
   
end

return GrowthSystem