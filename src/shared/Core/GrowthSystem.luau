local GrowthSystem = {}

-- Services

local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- Variables

local player

local buildings = ReplicatedStorage.Buildings

-- Functions

function GrowthSystem.GetPlayer(Player)
   player = Player

   -- Basic error checking
   if not Player.Name then warn("Argument passed is not a player!!") end
end

function GrowthSystem.UpgradeBuilding(buildingData, building, newBuildingWorldCFrame)
   -- Does not siginify much but just updates the value to one more than it is
   buildingData.ID = string.gsub(buildingData.ID, "_"..tostring(buildingData.Stage), "")
   buildingData.Stage = buildingData.Stage + 1
   buildingData.ID = buildingData.ID.."_"..buildingData.Stage

   -- This acutally replaces the building
   building:Destroy()
   local NewBuilding = buildings[string.gsub(buildingData.ID, "_"..tostring(buildingData.Stage), "")]:WaitForChild(buildingData.ID):Clone()

   NewBuilding.Parent = workspace.Plot.Buildings
   NewBuilding:SetPrimaryPartCFrame(newBuildingWorldCFrame)

   return NewBuilding
end

function GrowthSystem.UpdatePercentage(buildingData, building, buildingFolder)
   local percentageStageChange = math.round(100 / (#buildingFolder - 1))

   if building.Percentage ~= 100 then buildingData.Percentage = buildingData.Percentage + 1 end

   print(building.Name)
   print(buildingData.Percentage)

   if buildingData.Percentage % percentageStageChange == 0 then
      return true
   end

   return false
end

function GrowthSystem.AddTax()
   
end

function GrowthSystem.CollectTax()
   
end

return GrowthSystem