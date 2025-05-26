local UIMain = {}

-- Services 

local TweenService = game:GetService("TweenService")

-- Variables

local player
local UIPos = {}
local UISize = {}

-- Functions

function UIMain.getPlayer(Player) 

   -- Simple function to get the player, with error checking.

   player = Player
   if not player.Name then warn("Argument passed is not a player!!") end
end

function UIMain.tweenHover(frame, style)

   -- Put the original position inside of the table incase it glitches.

   if not UISize[frame] then UISize[frame] = frame.Size end

   -- TweenInfo's for different hovers
   local hoverTween = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
   local moneyTween = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

   -- Check the style and load a tween.

   local tween

   if style == "hoverbegin" then
      -- This tween is played when a user hovers over the frame (MouseEnter)
      -- The tween sets the frame size to 1.1 times the original size.
      tween = TweenService:Create(frame, hoverTween, {Size = UDim2.new(UISize[frame].X.Scale * 1.1, 0, UISize[frame].Y.Scale * 1.1, 0)})
   elseif style == "hoverend" then
      -- This tween is played when a user stops hovering over the frame (MouseLeave)
      -- The tween sets the frame size to the orignal size.
      tween = TweenService:Create(frame, hoverTween, {Size = UISize[frame]})
   elseif style == "moneyChange" then
      -- This tween is played when the amount of money a user has changes
      -- We create the tween for the size increase and play it, wait some time and play the one that changes the size back to normal.
      TweenService:Create(frame, moneyTween, {Size = UDim2.new(UISize[frame].X.Scale * 1.1, 0, UISize[frame].Y.Scale * 1.1, 0)}):Play()
      task.wait(0.4)
      TweenService:Create(frame, moneyTween, {Size = UDim2.new(UISize[frame])}):Play()
   else
      warn("Style not found: "..style)
   end

   tween:Play()
end

function UIMain.formatNumberToComma(number)
   
   local numToString = tostring(number)
   local result = ""
   local count = 0

   for i = #numToString, 1, -1 do

   
      -- Changes the result into the last digit of the number
      result = string.sub(numToString, i, i)..result
      count = count + 1
      -- If the count is divisible by 3, we add a comma and continue going (count is the amnt of digits)
      if count % 3 == 0 and i > 1 then
         -- Add the comma
         result = ","..result
      end
   end

   -- Format with a DALLA DALLA
   return "$"..result
end

return UIMain