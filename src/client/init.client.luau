-- Services

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local CollectionService = game:GetService('CollectionService')

-- Variables

local functions = ReplicatedStorage.Events.Functions

local audio = ReplicatedStorage.Audio.SFX

local UIMain = require(ReplicatedStorage.Shared.UI.UIMain)
local PlaceBuildings = require(ReplicatedStorage.Shared.Core.PlaceBuilding)
local player = Players.LocalPlayer
local playerData

-- Variables - UI

local uiTopBar = player.PlayerGui:WaitForChild("UI_TopBar").Container
local uiBottomBar = player.PlayerGui:WaitForChild("UI_BottomBar").Container

local moneyCounter = uiBottomBar.LeftSection.MoneyFrame

local buildingsButton = uiTopBar.MidSection.Buildings
local cityButton = uiTopBar.MidSection.City
local toolsButton = uiTopBar.MidSection.Tools

-- Functions

PlaceBuildings.getPlayer(player);
playerData = functions.GetData:InvokeServer();

-- Syntax follows: name of the value (must be in a string), and value (must be in a numberic format)

-- playerData = functions.ChangeData:InvokeServer("Cash", playerData["Cash"] + 50);

for _, tool in pairs(player.Backpack:GetChildren()) do
   tool.Equipped:Connect(function(mouse) PlaceBuildings.toolEquipped(mouse, tool) end)
end

-- Loop through each child inside the MidSection and check if it is a frame, if so, do the event for each one.

for _, frame in pairs(uiTopBar.MidSection:GetChildren()) do
   if frame:IsA("Frame") then
      frame.MouseEnter:Connect(function() UIMain.tweenHover(frame, "hoverbegin") end)
      frame.MouseLeave:Connect(function() UIMain.tweenHover(frame, "hoverend") end)

      -- Mouse click handling

      for _, item in frame:GetChildren() do
         if item:IsA("TextButton") then
            item.MouseButton1Click:Connect(function() 

               -- Simply play the 2 tweens and a sound effect.
               -- TODO: Implement an 'OpenFrame' function.

               UIMain.tweenHover(frame, "hoverend")
               audio.buttonClick:Play()
               task.wait(0.3)
               UIMain.tweenHover(frame, "hoverbegin")
            end)
         end
      end
   end
end

-- Yes, i know this is not the way i should be doing this, but i can't check if the value has changed :/

while task.wait() do
   playerData = functions.ChangeData:InvokeServer("Cash", playerData["Cash"] + 1);
   moneyCounter.MoneyCount.Text = UIMain.formatNumberToComma(playerData["Cash"])
end

-- buildingsButton.MouseEnter:Connect(UIMain.tweenHover(buildingsButton, "hoverBegin"))

--[[

   DONE

   1. First of all, we get the data. (well the server has access)
   2. We can call a remotefunction to change the playerData from the server.
   3. IF it is sucessful, we will change the data and return the new data back to the client.
]]--