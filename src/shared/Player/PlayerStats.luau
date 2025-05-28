local PlayerStats = {}

-- Services

local DataStoreService = game:GetService('DataStoreService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')

-- Variables

-- This is the key for the dataStore where we can access all of the stored data.
local dataStore = DataStoreService:GetDataStore("Testing_V7")

--[[ This is the prefix for accessing the player's data.
   (e.g. PlayerData_ID_4396459) will be the key to access ID 4396459's data.
   ]]--

local keyPrefix = "PlayerData_ID_"

-- If the player is new, we will load this data instead.
local dataTemplate = {
   Cash = 20,
   Population = 0,
   FinishedTutorial = false,
   PlotData = {

      -- Each plot is 50x50 studs, with buildings being approximately 6-12 studs.
      PlotsUnlocked = {
         {
            {false, false, false, false},
            {false, false, false, false},
            {false, false, false, false},
            {false,  true,  true, false}
         }
      },

      -- The prices of every singular plot, once bought, price will be 0.
      PlotPrices = {
         {
            {5000000, 2500000, 2500000, 5000000},
            {2500000, 1000000, 1000000, 2500000},
            {1000000,  500000,  500000, 1000000},
            { 500000,       0,       0,  500000},
         }
      },
      BuildingsPlaced = {
         -- Example Data

         --[[ Building_1 = {
               -- This will be the LOCAL position of where it is.
               "Position" = Vector3.new(100, 10, 100)    

               -- This will be the ID of the building (key: [BUILDING_NAME]_[ID]
               "ID" = "Tall_High_Rise"_65536

               -- This will be how much the city has grown, (stage number and percentage)
               "Stage" = 3,
               "Percentage" = 40,

               -- This will be how much tax / money is waiting for collection
               "TaxCollection" = 12,
            }
         ]]--
      },
   }
}

-- This is the table where all the players data is loaded into. Only used for reading (technically).
local loadedData = {}

-- Functions

-- Returns the data from the "LoadedData" table.
function PlayerStats.GetData(Player)

   -- Basic error handling. We find the data in the table and we check whether it exists.
   -- We'll return the data if we found it.
   if loadedData[Player] then
      return loadedData[Player]
   else
      warn(Player.Name.."'s data was not found!")
   end
end

function PlayerStats.AddData(Player, dataToAdd, type, name)
   local data = PlayerStats.GetData(Player)

   -- Check what type, this will expand later on.

   if type == "newBuilding" then
      data.PlotData.BuildingsPlaced[name] = dataToAdd
   elseif type == "removeBuilding" then
      data.PlotData.BuildingsPlaced[dataToAdd] = nil
   end

   return data
end

function PlayerStats.ChangeData(Player, data, value)
   local playerData = PlayerStats.GetData(Player)
   
   if playerData[data] then playerData[data] = value end

   return playerData
end

function PlayerStats.LoadData(Player)
   
   -- Key to save the data into.
   local key = keyPrefix..Player.UserId

   -- Data which we gather from the dataStore.
   local data
   
   -- Empty variables for the pcall.
   local success, errormsg

   -- pcall function to get the data in a safe manner.
   success, errormsg = pcall(function()
      data = dataStore:GetAsync(key)
   end)
   
   
   -- Basic error handling.
   if success then
      print("Data has been loaded!")
      print(data)
   else
      warn("Data has not been loaded for player: "..Player.Name)
      Player:Kick("Data has not been loaded, please wait and try again!")
   end
   
   -- If the player is new, we will just load the default data.
   if not data then data = dataTemplate end

   -- Add the data to the loadedData table.
   loadedData[Player] = data
end

function PlayerStats.SaveData(Player)

   -- Key to save the data into.
   local key = keyPrefix..Player.UserId

   -- Data which we save into the servers.
   local data = PlayerStats.GetData(Player)
   
   -- Empty variables for the pcall.
   local success, errormsg

   -- If the data is nil, we don't need to print anything as it is already handled by the function.
   if not data then return end

   -- This is the pcall function, we set the variables for error handling.
   success, errormsg = pcall(function()

   -- Update the data, we use UpdateAsync to revert back to previous versions incase of data loss.
      dataStore:UpdateAsync(key, function(prevData)
         return data
      end)
   end)

   -- Basic error handling.
   if success then
      print(data)
      print("Data has been saved!")
   else
      print(data)
      warn("Data has not been saved!")
   end
end

function PlayerStats.OnGameClose()

   -- Incase we are in studio, we'll wait 2 seconds for the data to save.
   if RunService:IsStudio() then task.wait(2) end

   -- These variables give us every single player, how much there are and a BindableEvent for when we finish.
   local allPlayers = Players:GetChildren()
   local playersRemaining = #allPlayers
   local event = Instance.New("BindableEvent")

   for _, player in ipairs(allPlayers) do
      task.spawn(function()
        -- We loop through every player and save their data.
         PlayerStats.SaveData(player)
         playersRemaining = playersRemaining - 1

         -- Once we have finished, fire the event.
         if playersRemaining == 0 then
            event:Fire()
         end
      end)
   end

   event.Event:Wait()
end

return PlayerStats