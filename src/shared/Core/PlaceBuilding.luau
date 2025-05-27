local PlaceBuildings = {}

-- Services

local CollectionService = game:GetService("CollectionService")

-- Variables

local player = nil
local character = nil
local mouse = nil

-- Functions

-- This is a simple function just to get the player
function PlaceBuildings.getPlayer(Player)
   player = Player
   character = player.Character or player.CharacterAdded:Wait()

   -- most basic error checking lolz
   if not player.Name then warn("Argument passed is not a player!!") end
end

-- This will check if the tool that is equipped has the tag of 'Building', so we can continue
function PlaceBuildings.toolEquipped(Mouse, tool)
   if CollectionService:GetTagged("Building") then
      mouse = Mouse
      task.spawn(function()
         while task.wait() and character:WaitForChild(tool.Name) do print(mouse.Hit) end
      end)
   end
end

return PlaceBuildings