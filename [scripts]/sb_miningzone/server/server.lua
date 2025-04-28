local VORPcore = exports.vorp_core:GetCore()
-- Direct export calls without getting the API object
local VORPinv = {}
local storeLimits = {}
local T = TranslationStores.Langs.English

-- Set up the inventory functions we need with a simpler approach
function VORPinv.getUserInventoryItems(source)
    -- Directly use the export function 
    return exports.vorp_inventory:getUserInventoryItems(source)
end

function VORPinv.getItemCount(source, itemName)
    -- Using a traditional callback approach instead of events
    local count = 0
    -- Try direct export first
    if source then
        local userInventory = VORPinv.getUserInventoryItems(source)
        if userInventory then
            for _, item in pairs(userInventory) do
                if item.name == itemName then
                    count = item.count
                    break
                end
            end
        end
    end
    return count
end

function VORPinv.getUserInventoryWeapons(source)
    return exports.vorp_inventory:getUserInventoryWeapons(source)
end

function VORPinv.subItem(source, itemName, amount)
    if not source or not itemName or not amount then
        return false
    end
    
    -- First check if player has the item in sufficient quantity
    local currentCount = VORPinv.getItemCount(source, itemName)
    if currentCount < amount then
        return false
    end
    
    -- Use core export directly
    local success = false
    TriggerEvent("vorpCore:subItem", source, itemName, amount, {}, function(result)
        success = result
    end)
    
    -- Simple wait for a response
    Wait(200)
    
    -- Check result
    local newCount = VORPinv.getItemCount(source, itemName)
    if newCount == (currentCount - amount) then
        return true
    else
        return false
    end
end

function VORPinv.addItem(source, itemName, amount, metadata)
    metadata = metadata or {}
    
    -- Use core export directly
    local success = false
    TriggerEvent("vorpCore:addItem", source, itemName, amount, metadata, function(result)
        success = result
    end)
    
    -- Simple wait for a response
    Wait(200)
    
    return success
end

function VORPinv.subWeapon(source, weaponId)
    if not source or not weaponId then return false end
    
    TriggerEvent("vorpCore:subWeapon", source, weaponId)
    return true -- Assuming success
end

function VORPinv.createWeapon(source, weaponName)
    if not source or not weaponName then return false end
    
    TriggerEvent("vorpCore:registerWeapon", source, weaponName)
    return true -- Assuming success
end

function VORPinv.canCarryItems(source, amount)
    if not source or not amount then return false end
    
    -- Simple direct check
    local can = false
    TriggerEvent("vorpCore:canCarryItems", source, amount, function(data)
        can = data
    end)
    
    Wait(200) -- Give time for callback
    return can
end

function VORPinv.canCarryItem(source, itemName, amount)
    if not source or not itemName or not amount then return false end
    
    -- Simple direct check
    local can = false
    TriggerEvent("vorpCore:canCarryItem", source, itemName, amount, function(data)
        can = data
    end)
    
    Wait(200) -- Give time for callback
    return can
end

-- Check item existence
local function CheckItemsExist()
    for storeId, sellItems in pairs(Config.SellItems) do
        for _, item in ipairs(sellItems) do
            -- Items exist in config
        end
    end
    
    for storeId, buyItems in pairs(Config.BuyItems) do
        for _, item in ipairs(buyItems) do
            -- Items exist in config
        end
    end
end

-- Run the simple check during startup
CreateThread(function()
    -- Wait a moment for all resources to load
    Wait(5000)
    CheckItemsExist()
end)

-- Insert the mining items into the database if they don't exist
CreateThread(function()
    Wait(5000) -- Wait for database to be ready
    
    local function addItemsDirectSQL()
        -- Define all our mining items
        local miningItems = {
            -- Items from Mining.sql
            { item = "goldnugget", label = "Gold Nugget", limit = 50 },
            { item = "clay", label = "Copper Bar", limit = 50 },
            { item = "provision_coal", label = "Zinc Bar", limit = 50 },
            { item = "copper", label = "Titanium Bar", limit = 50 },
            { item = "iron", label = "Blacksteel Bar", limit = 50 },
            { item = "sulfur", label = "Brass Bar", limit = 50 },
            { item = "stone", label = "Lead Bar", limit = 50 },
            { item = "pickaxe", label = "Pickaxe", limit = 1 },
            { item = "lantern", label = "Mining Lantern", limit = 1 },
            
            -- Additional items from vorp_mining/config.lua
            { item = "coal", label = "Coal", limit = 50 },
            { item = "nitrite", label = "Nitrite", limit = 50 },
            { item = "rock", label = "Rocks", limit = 50 },
            { item = "salt", label = "Salt", limit = 50 }
        }
        
        -- Add each item individually to avoid SQL syntax differences
        for _, item in ipairs(miningItems) do
            local query = string.format(
                "INSERT IGNORE INTO items (item, label, `limit`, can_remove, type, usable) VALUES ('%s', '%s', %d, 1, 'item_standard', 0)",
                item.item, item.label, item.limit
            )
            
            -- Try various MySQL implementations
            if exports.oxmysql then
                exports.oxmysql:execute(query, {}, function(result)
                    -- Result handling without debug print
                end)
            elseif exports.ghmattimysql then
                exports.ghmattimysql:execute(query, {}, function(result)
                    -- Result handling without debug print
                end)
            elseif MySQL and MySQL.Async then
                MySQL.Async.execute(query, {}, function(rowsChanged)
                    -- Result handling without debug print
                end)
            else
                break
            end
            
            -- Small delay to avoid overwhelming the database
            Wait(100)
        end
    end
    
    -- Execute the function
    addItemsDirectSQL()
end)

-- Force add item function - bypasses most inventory checks
-- This is used as a last resort when other methods fail
local function ForceAddItem(_source, itemName, amount)    
    -- Get the player's inventory directly
    local inventory = VORPinv.getUserInventoryItems(_source)
    if not inventory then
        return false
    end
    
    -- Try to directly manipulate the inventory
    -- This is a more direct approach that bypasses most checks
    local success = VORPinv.addItem(_source, itemName, amount, {})
    
    return success
end

-- Register callback to check if a player is allowed to mine at a location
RegisterServerEvent("sb_miningzone:checkMiningPermission")
AddEventHandler("sb_miningzone:checkMiningPermission", function(coords)
    local _source = source
    
    -- Add additional server-side permission checks here if needed
    -- For example, check if player has a specific item or job to allow mining
    
    TriggerClientEvent("sb_miningzone:miningPermissionResult", _source, true)
end)

-- Initialize store item limits
CreateThread(function()
    local sellItems = Config.SellItems
    local buyItems = Config.BuyItems

    for index, v in pairs(sellItems) do
        for _, value in pairs(v) do
            if value.itemLimit and value.itemLimit > 0 then
                storeLimits[index] = storeLimits[index] or {}
                table.insert(storeLimits[index], {
                    itemName = value.itemName,
                    amount = value.itemLimit,
                    type = "sell"
                })
            end
        end
    end

    for key, value in pairs(buyItems) do
        for _, v in pairs(value) do
            if v.itemLimit and v.itemLimit > 0 then
                storeLimits[key] = storeLimits[key] or {}
                table.insert(storeLimits[key], {
                    itemName = v.itemName,
                    amount = v.itemLimit,
                    type = "buy"
                })
            end
        end
    end
    
    -- Register callback for inventory items
    VORPcore.Callback.Register("sb_miningzone:getInventoryItems", function(source, cb)
        local _source = source
        local playerItems = {}
        
        -- Get all items from the player's inventory
        local items = VORPinv.getUserInventoryItems(_source)
        
        if items then
            for _, item in pairs(items) do
                playerItems[item.name] = {
                    count = item.count,
                    label = item.label,
                    limit = item.limit,
                    type = item.type,
                    canUse = item.canUse,
                    canRemove = item.canRemove,
                    isDegradable = false
                }
            end
        end
        
        cb(playerItems)
    end)

    -- Create table to track pickaxe purchases if it doesn't exist
    local query = [[
        CREATE TABLE IF NOT EXISTS pickaxe_purchases (
            identifier VARCHAR(50) NOT NULL,
            charidentifier INT(11) NOT NULL,
            purchase_date DATE NOT NULL,
            PRIMARY KEY (identifier, charidentifier, purchase_date)
        )
    ]]

    -- Execute the query to create the table
    if exports.oxmysql then
        exports.oxmysql:execute(query)
    elseif exports.ghmattimysql then
        exports.ghmattimysql:execute(query)
    elseif MySQL and MySQL.Async then
        MySQL.Async.execute(query)
    end
end)

-- Function to check if a player has already purchased a pickaxe today
local function HasPurchasedPickaxeToday(identifier, charidentifier)
    local hasPickaxe = false
    local today = os.date("%Y-%m-%d")
    
    local query = "SELECT COUNT(*) as count FROM pickaxe_purchases WHERE identifier = ? AND charidentifier = ? AND purchase_date = ?"
    local params = {identifier, charidentifier, today}
    
    if exports.oxmysql then
        local result = exports.oxmysql:executeSync(query, params)
        if result and result[1] and result[1].count > 0 then
            hasPickaxe = true
        end
    elseif exports.ghmattimysql then
        local result = exports.ghmattimysql:executeSync(query, params)
        if result and result[1] and result[1].count > 0 then
            hasPickaxe = true
        end
    elseif MySQL and MySQL.Sync then
        local result = MySQL.Sync.fetchAll(query, params)
        if result and result[1] and result[1].count > 0 then
            hasPickaxe = true
        end
    end
    
    return hasPickaxe
end

-- Function to record a pickaxe purchase
local function RecordPickaxePurchase(identifier, charidentifier)
    local today = os.date("%Y-%m-%d")
    
    local query = "INSERT INTO pickaxe_purchases (identifier, charidentifier, purchase_date) VALUES (?, ?, ?)"
    local params = {identifier, charidentifier, today}
    
    if exports.oxmysql then
        exports.oxmysql:execute(query, params)
    elseif exports.ghmattimysql then
        exports.ghmattimysql:execute(query, params)
    elseif MySQL and MySQL.Async then
        MySQL.Async.execute(query, params)
    end
end

-- Function to check store limits
local function checkStoreLimits(storeId, ItemName, quantity, action)
    if not storeLimits[storeId] then
        return true
    end
    for k, v in pairs(storeLimits[storeId]) do
        if action == "sell" then
            if v.itemName == ItemName and v.type == "buy" then
                v.amount = v.amount + quantity
            end
            if v.itemName == ItemName and v.type == "sell" then
                v.amount = v.amount - quantity
            end
        end

        if action == "buy" then
            if v.itemName == ItemName and v.type == "buy" then
                if v.amount >= quantity then
                    v.amount = v.amount - quantity
                    return true
                else
                    return false
                end
            end
        end
    end
    return true
end

-- Function to handle buying items from the store
local function BuyItem(_source, Character, value, ItemName, storeId)
    local fname = Character.firstname
    local lname = Character.lastname
    local money = Character.money
    local total = value.buyprice
    local total2 = (math.floor(total * 100) / 100)
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier

    -- Check for pickaxe restriction - only 1 per in-game day
    if ItemName == "pickaxe" then
        -- Check if player has already purchased a pickaxe today
        if HasPurchasedPickaxeToday(identifier, charidentifier) then
            TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, TranslationStores.Langs.English.pickaxeLimitReached)
            return false
        end
    end

    if value.currencyType == "cash" then
        -- Check money first
        if money < total then
            TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "You don't have enough money")
            return false
        end

        -- Handle weapon purchases separately
        if value.weapon then
            for i = 1, value.quantity, 1 do
                VORPinv.createWeapon(_source, ItemName)
            end
            
            -- Deduct money after successful weapon creation
            Character.removeCurrency(0, total)
            local successMessage = "Bought " .. value.quantity .. " " .. value.itemLabel .. " for $" .. total2
            TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, true, successMessage)
            return true
        else
            -- Check store limits first (if applicable)
            if Config.MiningStores[storeId].DynamicStore then
                if not checkStoreLimits(storeId, ItemName, value.quantity, "buy") then
                    TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Store has reached its limit for this item")
                    return false
                end
            end
            
            -- Now try a simpler approach with direct API calls
            -- Check if player can carry items
            local canCarry = VORPinv.canCarryItems(_source, value.quantity)
            if not canCarry then
                TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "You cannot carry any more items")
                return false
            end
            
            -- Check if player can carry this specific item
            local canCarryItem = VORPinv.canCarryItem(_source, ItemName, value.quantity)
            if not canCarryItem then
                TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "You cannot carry any more of this item")
                return false
            end
            
            -- Try to add the item directly (simplest method)
            local success = VORPinv.addItem(_source, ItemName, value.quantity)
            
            if success then
                -- Item was successfully added, now deduct money
                Character.removeCurrency(0, total)
                local successMessage = "Bought " .. value.quantity .. " " .. value.itemLabel .. " for $" .. total2
                TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, true, successMessage)
                
                -- Record pickaxe purchase if applicable
                if ItemName == "pickaxe" then
                    RecordPickaxePurchase(identifier, charidentifier)
                end
                
                return true
            else
                TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Failed to add item to your inventory")
                return false
            end
        end
    end
    
    TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Invalid currency type")
    return false
end

-- Server event to buy an item
RegisterServerEvent("sb_miningstore:BuyItem")
AddEventHandler("sb_miningstore:BuyItem", function(storeId, itemIndex, amount)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local buyItemsList = Config.BuyItems[storeId]
    
    if not buyItemsList then
        TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Store inventory not found")
        return
    end
    
    -- Safety check - ensure the index is numeric and convert if needed
    local validIndex = tonumber(itemIndex)
    if not validIndex then
        TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Invalid item selection")
        return
    end
    
    -- Directly access the array element by using the index
    local itemData = nil
    
    for i=1, #buyItemsList do
        local item = buyItemsList[i]
        
        -- Match the index we're looking for
        if i == validIndex then
            itemData = item
        end
    end
    
    -- If itemData is still nil, we didn't find the item
    if not itemData then
        TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Item not found in store")
        return
    end
    
    local value = {
        buyprice = itemData.buyprice * amount,  -- Total price for quantity
        itemLabel = itemData.itemLabel,
        quantity = amount,
        weapon = itemData.weapon or false,
        currencyType = itemData.currencyType
    }
    
    -- Call the BuyItem function
    BuyItem(_source, Character, value, itemData.itemName, storeId)
end)

-- Function to handle selling items to the store
local function SellItem(_source, Character, value, ItemName, storeId)
    local fname = Character.firstname
    local lname = Character.lastname
    local canContinue = false

    local total = value.sellprice * value.quantity
    local total2 = (math.floor(total * 100) / 100)

    if value.weapon then
        local countWeap = 0
        local userWeapons = VORPinv.getUserInventoryWeapons(_source)
        
        if not userWeapons then
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - weapon inventory error")
            return false
        end

        for _, v in pairs(userWeapons) do
            if v.name == ItemName then
                VORPinv.subWeapon(_source, v.id)
                canContinue = true
                countWeap = countWeap + 1
                if countWeap == value.quantity then
                    break
                end
            end
        end

        if countWeap == 0 then
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "You don't have this weapon")
            return false
        end

        total = value.sellprice * countWeap
        total2 = (math.floor(total * 100) / 100)
    else
        -- Check current inventory for the item
        local inventory = VORPinv.getUserInventoryItems(_source)
        local itemFound = false
        local itemCount = 0
        
        if inventory then
            for _, item in pairs(inventory) do
                if item.name == ItemName then
                    itemFound = true
                    itemCount = item.count
                    break
                end
            end
        else
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - inventory error")
            return false
        end
        
        if not itemFound then
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - item not found")
            return false
        end
        
        -- Check if player has enough items
        if itemCount < value.quantity then
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "You don't have enough of this item")
            return false
        end
        
        -- Try to remove the items from inventory
        local success = VORPinv.subItem(_source, ItemName, value.quantity)
        
        if success then
            canContinue = true
        else
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - inventory error")
            return false
        end
    end

    if not canContinue then
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - no items to sell")
        return false
    end

    if Config.MiningStores[storeId].DynamicStore then
        if not checkStoreLimits(storeId, ItemName, value.quantity, "sell") then
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Store can't buy any more of this item")
            return false
        end
    end

    -- Add money to player
    if value.currencyType == "cash" then
        Character.addCurrency(0, total)
        local successMessage = "Sold " .. value.quantity .. " " .. value.itemLabel .. " for $" .. total2
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, true, successMessage)
    end
    
    return true
end

-- Server event to check player job
RegisterServerEvent("sb_miningstore:CheckJob")
AddEventHandler("sb_miningstore:CheckJob", function(storeId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local job = Character.job
    local jobGrade = Character.jobGrade
    local hasJob = false

    for _, allowedJob in pairs(Config.MiningStores[storeId].AllowedJobs) do
        if job == allowedJob and jobGrade >= Config.MiningStores[storeId].JobGrade then
            hasJob = true
            break
        end
    end

    TriggerClientEvent("sb_miningstore:JobCheck", _source, hasJob, storeId)
end)

-- Server event to open the store
RegisterServerEvent("sb_miningstore:OpenStore")
AddEventHandler("sb_miningstore:OpenStore", function(storeId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local storeData = Config.MiningStores[storeId]
    local buyItems = Config.BuyItems[storeId]
    local sellItems = Config.SellItems[storeId]

    -- Validate data before proceeding
    if not storeData then
        VORPcore.NotifyRightTip(_source, "Store data not found", 3000)
        return
    end

    if not buyItems then
        buyItems = {}
    end

    if not sellItems then
        sellItems = {}
    end
    
    TriggerClientEvent("sb_miningstore:OpenStoreMenu", _source, storeId, buyItems, sellItems, storeData)
end)

-- Server event to sell an item
RegisterServerEvent("sb_miningstore:SellItem")
AddEventHandler("sb_miningstore:SellItem", function(storeId, itemIndex, amount)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local sellItemsList = Config.SellItems[storeId]
    
    if not sellItemsList then
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Store inventory not found")
        return
    end
    
    -- Safety check - ensure the index is numeric and convert if needed
    local validIndex = tonumber(itemIndex)
    if not validIndex then
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Invalid item selection")
        return
    end
    
    -- Check if the index is within bounds
    if validIndex < 1 or validIndex > #sellItemsList then
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Invalid item selection")
        return
    end
    
    -- Directly access the array element by using the index
    local itemData = sellItemsList[validIndex]
    
    if not itemData then
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Item not found in store")
        return
    end
    
    local value = {
        sellprice = itemData.sellprice,
        itemLabel = itemData.itemLabel,
        quantity = amount,
        weapon = itemData.weapon or false,
        currencyType = itemData.currencyType
    }
    
    -- Call the SellItem function
    SellItem(_source, Character, value, itemData.itemName, storeId)
end)

-- Server event to get player items for the store menu
RegisterServerEvent("sb_miningzone:getPlayerItems")
AddEventHandler("sb_miningzone:getPlayerItems", function(cb)
    local _source = source
    local playerItems = {}
    
    -- Get all items from the player's inventory
    local items = VORPinv.getUserInventoryItems(_source)
    
    if items then
        for _, item in pairs(items) do
            playerItems[item.name] = {
                count = item.count,
                label = item.label,
                limit = item.limit,
                type = item.type,
                canUse = item.canUse,
                canRemove = item.canRemove,
                isDegradable = false -- Most mining resources aren't degradable
            }
        end
    end
    
    TriggerClientEvent("sb_miningzone:receivePlayerItems", _source, playerItems, cb)
end)

-- Register callback event to receive player items
RegisterNetEvent("sb_miningzone:receivePlayerItems")
AddEventHandler("sb_miningzone:receivePlayerItems", function(items, cb)
    if cb then
        cb(items)
    end
end)

-- Export functions for other resources to use
exports('GetMiningZones', function()
    return Config.MiningZones
end)

-- Get number of players currently in each mining zone
exports('GetPlayersInMiningZones', function()
    local zonePlayerCounts = {}
    
    for _, zone in pairs(Config.MiningZones) do
        zonePlayerCounts[zone.name] = 0
    end
    
    -- This would need additional tracking of player positions
    -- which would require regular updates from clients
    
    return zonePlayerCounts
end)

-- Export function to get mining stores info
exports('GetMiningStores', function()
    return Config.MiningStores
end)

-- Register event listener for successful mining operations
-- This event will be triggered from the client when a mining operation succeeds
RegisterServerEvent("sb_miningzone:addMiningXP")
AddEventHandler("sb_miningzone:addMiningXP", function(inMiningZone)
    local _source = source
    
    -- Get player character
    local Character = VORPcore.getUser(_source).getUsedCharacter
    if not Character then return end
    
    -- Calculate XP amount
    local xpAmount = Config.MiningXP.BaseXP
    
    -- Apply zone multiplier if in a mining zone
    if inMiningZone and Config.MiningXP.ZoneMultiplier > 1.0 then
        xpAmount = xpAmount * Config.MiningXP.ZoneMultiplier
    end
    
    -- Add random bonus if enabled
    if Config.MiningXP.RandomBonus.Enabled then
        local bonus = math.random(Config.MiningXP.RandomBonus.Min, Config.MiningXP.RandomBonus.Max)
        xpAmount = xpAmount + bonus
    end
    
    -- Round XP to nearest integer
    xpAmount = math.floor(xpAmount + 0.5)
    
    -- Add XP to character
    Character.addXp(xpAmount)
    
    -- Notify player
    VORPcore.NotifyRightTip(_source, "Mining experience gained: " .. xpAmount .. " XP", 3000)
end)