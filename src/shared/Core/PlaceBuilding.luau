local PlaceBuildings = {}

-- Services

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local CollectionService = game:GetService("CollectionService")

-- Variables

local player = nil
local character = nil
local mouse = nil
local playerData = nil

local connections = {}

local functions = ReplicatedStorage.Events.Functions

local growthSystem = require(ReplicatedStorage.Shared.Core.GrowthSystem)

-- Functions

-- This is a simple function just to get the player
function PlaceBuildings.getPlayer(Player)
   player = Player
   character = player.Character or player.CharacterAdded:Wait()

   -- most basic error checking lolz
   if not player.Name then warn("Argument passed is not a player!!") end
end

function PlaceBuildings.placeBuilding(tool, pos)
   -- Get the 1st stage of the building and place it down at the position
   local buildings = ReplicatedStorage.Buildings

   local buildingFolder = buildings:WaitForChild(tool:GetAttribute("BuildingName"))
   local building = buildingFolder:FindFirstChild(tool:GetAttribute("BuildingName").."_1")

   if building then

      -- Clone the building, then parent it to the buildings folder and set the primary part CFrame to the passed position.
      local clone = building:Clone()
      clone.Parent = workspace.Plot.Buildings
      -- This is commented out because for some reason this is a hit or miss.
      -- clone.Parent = workspace:WaitForChild("Plot"):WaitForChild("Buildings")
      -- Make the cframe have no rotation so no weird glitches :)
      local VecToCFrame = CFrame.new(pos)
      clone:SetPrimaryPartCFrame(VecToCFrame)

      local centerCFrame = workspace.Plot.Center.CFrame
      local localPosition = centerCFrame:PointToObjectSpace(clone.PrimaryPart.Position)

      local newData = {
         PositionX = localPosition.X,
         PositionY = localPosition.Y,
         PositionZ = localPosition.Z,

         ID = clone.Name,
         
         Stage = 1,
         Percentage = 0,

         TaxColection = 0,
      }

      functions.AddData:InvokeServer(newData, "newBuilding", clone.Name..tostring(math.random(1, 100000)));

      PlaceBuildings.GrowthInit(newData, clone)

      -- Code below is for VFX/SFX only!
      ReplicatedStorage.Audio.SFX.placeEffect:Play()
      task.spawn(function()
         -- This simply adds a smokeParticle
         local smokeParticle = ReplicatedStorage.Particles.SmokeEmitter:Clone()
         smokeParticle.Parent = clone.PrimaryPart
         smokeParticle:Emit(1)
         task.wait(2)
         smokeParticle:Destroy()
      end)
   else
      warn("Building not found: "..tool:GetAttribute("BuildingName").."_1")
   end
end

function PlaceBuildings.playerLoaded(Player, data)

   -- Get the table with all the buildings

   print(data)
   local buildingsData = data.PlotData.BuildingsPlaced

   -- Loop through and place the buildings down 1 by 1
   for _, building in pairs(buildingsData) do
      -- This string.gsub() method removes the underscore and the digit
      local buildingModel = ReplicatedStorage.Buildings[string.gsub(building.ID, "_"..tostring(building.Stage), "")]:WaitForChild(building.ID):Clone()

      if building.Stage ~= 1 then
         -- TODO: Load buildings of valid stage.

         buildingModel = ReplicatedStorage.Buildings[string.gsub(building.ID, "_"..tostring(building.Stage), "")]:WaitForChild(building.ID):Clone()
      end

      buildingModel.Parent = workspace.Plot.Buildings
      
      -- We do this so we can use the SetPrimaryPartCFrame() function.
      local buildingVector = Vector3.new(building.PositionX, building.PositionY, building.PositionZ)
      
      local plotCenter = workspace.Plot.Center.CFrame

      local buildingCFrame = plotCenter * CFrame.new(buildingVector)
      buildingModel:SetPrimaryPartCFrame(buildingCFrame)

      PlaceBuildings.GrowthInit(building, buildingModel)
   end
end

function PlaceBuildings.GrowthInit(buildingData, building)
   task.spawn(function() 
      local succeeded
      while task.wait(0.5) do
         succeeded = growthSystem.UpdatePercentage(buildingData, building, ReplicatedStorage.Buildings[string.gsub(buildingData.ID, "_"..tostring(buildingData.Stage), "")]:GetChildren())

         if succeeded then
            building = growthSystem.UpgradeBuilding(buildingData, building, building.PrimaryPart.CFrame)
         end
      end
   end)
end

-- This will check if the tool that is equipped has the tag of 'Building', so we can continue
function PlaceBuildings.toolEquipped(Mouse, tool)

   -- If there is a connection then remove it.
   if connections[tool] then connections[tool]:Disconnect() connections[tool] = nil end

   if CollectionService:GetTagged("Building") then
      mouse = Mouse
      task.spawn(function()
         -- If we swap tools and find another part (or ball) in the character, we remove it.
         if character:FindFirstChild("Part") then character:FindFirstChild("Part"):Destroy() end

         -- Create a sphere where the position is where the mouse is pointing to.

         local highlightSphere = Instance.new("Part", character)
         highlightSphere.Shape = Enum.PartType.Ball
         highlightSphere.CanCollide = false
         highlightSphere.CanTouch = false
         highlightSphere.Size = Vector3.new(2,2,2)
         highlightSphere.Color = Color3.new(0,1,0)
         highlightSphere.Transparency = 0.5

         -- Update the position every frame.

         while task.wait() and character:FindFirstChild(tool.Name) do 
            highlightSphere.CFrame = mouse.Hit
         end
      end)
   end

   -- Set the connection to the tool connection so we don't call the function multiple times
   connections[tool] = tool.Activated:Connect(function()
      if tool.Parent == character then 
         PlaceBuildings.placeBuilding(tool, mouse.Hit.Position) 
      end 
   end)
end

return PlaceBuildings