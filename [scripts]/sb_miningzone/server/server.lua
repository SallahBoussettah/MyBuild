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
                    print("^2Found item " .. itemName .. " with count: " .. count)
                    break
                end
            end
        else
            print("^1Unable to get user inventory for source " .. source)
        end
    end
    return count
end

function VORPinv.getUserInventoryWeapons(source)
    return exports.vorp_inventory:getUserInventoryWeapons(source)
end

function VORPinv.subItem(source, itemName, amount)
    if not source or not itemName or not amount then
        print("^1Missing parameters for subItem^7")
        return false
    end
    
    -- First check if player has the item in sufficient quantity
    local currentCount = VORPinv.getItemCount(source, itemName)
    if currentCount < amount then
        print("^1Player doesn't have enough of item " .. itemName .. " - Has: " .. currentCount .. ", Needs: " .. amount)
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
        print("^2Successfully removed " .. amount .. " of item " .. itemName)
        return true
    else
        print("^1Failed to remove items or verify removal - Before: " .. currentCount .. ", After: " .. newCount)
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

-- Log initialization
print("^2SB Mining Zones^7: Initialized ^3" .. #Config.MiningZones .. "^7 mining zones.")
print("^2SB Mining Stores^7: Initialized store system")

-- Debug function to check item existence
local function CheckItemsExist()
    print("^3Checking mining items availability in configuration^7")
    
    -- For each item in the configuration, log that we're checking it
    for storeId, sellItems in pairs(Config.SellItems) do
        for _, item in ipairs(sellItems) do
            print("Item in sell config: " .. item.itemName)
        end
    end
    
    for storeId, buyItems in pairs(Config.BuyItems) do
        for _, item in ipairs(buyItems) do
            print("Item in buy config: " .. item.itemName)
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
    
    print("^3Ensuring mining items exist in database^7")
    
    -- Try different approaches to adding items to the database
    
    -- Method 1: Using direct SQL
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
                    if result and result.affectedRows > 0 then
                        print("^2Added missing item to database: ^7" .. item.item)
                    end
                end)
            elseif exports.ghmattimysql then
                exports.ghmattimysql:execute(query, {}, function(result)
                    if result and result.affectedRows > 0 then
                        print("^2Added missing item to database: ^7" .. item.item)
                    end
                end)
            elseif MySQL and MySQL.Async then
                MySQL.Async.execute(query, {}, function(rowsChanged)
                    if rowsChanged > 0 then
                        print("^2Added missing item to database: ^7" .. item.item)
                    end
                end)
            else
                print("^1Could not add items - no MySQL implementation found^7")
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
    print("Attempting to force add item: " .. itemName .. " x" .. amount)
    
    -- Get the player's inventory directly
    local inventory = VORPinv.getUserInventoryItems(_source)
    if not inventory then
        print("Failed to get player inventory")
        return false
    end
    
    -- Try to directly manipulate the inventory
    -- This is a more direct approach that bypasses most checks
    local success = VORPinv.addItem(_source, itemName, amount, {})
    print("Force add result: " .. tostring(success))
    
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
end)

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

    -- Debug logging
    print("Processing purchase - Item: " .. ItemName .. ", Quantity: " .. value.quantity .. ", Total: $" .. total2)

    if value.currencyType == "cash" then
        -- Check money first
        if money < total then
            print("Purchase failed - Insufficient funds")
            TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "You don't have enough money")
            return false
        end

        -- Handle weapon purchases separately
        if value.weapon then
            print("Creating weapon: " .. ItemName)
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
                    print("Purchase failed - Store limit reached")
                    TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Store has reached its limit for this item")
                    return false
                end
            end
            
            -- Now try a simpler approach with direct API calls
            -- Check if player can carry items
            local canCarry = VORPinv.canCarryItems(_source, value.quantity)
            if not canCarry then
                print("Player cannot carry items - weight check failed")
                TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "You cannot carry any more items")
                return false
            end
            
            -- Check if player can carry this specific item
            local canCarryItem = VORPinv.canCarryItem(_source, ItemName, value.quantity)
            if not canCarryItem then
                print("Player cannot carry this specific item")
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
                print("Purchase successful - Player " .. fname .. " " .. lname .. " purchased " .. value.quantity .. " " .. ItemName)
                return true
            else
                print("Failed to add item to inventory")
                TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Failed to add item to your inventory")
                return false
            end
        end
    end
    
    print("Purchase failed - Invalid currency type")
    TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Invalid currency type")
    return false
end

-- Server event to buy an item
RegisterServerEvent("sb_miningstore:BuyItem")
AddEventHandler("sb_miningstore:BuyItem", function(storeId, itemIndex, amount)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local buyItemsList = Config.BuyItems[storeId]
    
    -- Debug logging
    print("Buy attempt - Store: " .. storeId .. ", Item index: " .. tostring(itemIndex) .. ", Amount: " .. amount)
    
    if not buyItemsList then
        print("Error: buyItemsList is nil for storeId: " .. storeId)
        TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Store inventory not found")
        return
    end
    
    -- Safety check - ensure the index is numeric and convert if needed
    local validIndex = tonumber(itemIndex)
    if not validIndex then
        print("Error: Invalid index type: " .. type(itemIndex))
        TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Invalid item selection")
        return
    end
    
    -- Directly access the array element by using the index
    local itemData = nil
    
    -- Print all available items for debugging
    print("Available items in store (" .. #buyItemsList .. " items):")
    for i=1, #buyItemsList do
        local item = buyItemsList[i]
        print(i .. ": " .. item.itemName)
        
        -- Match the index we're looking for
        if i == validIndex then
            itemData = item
            print("Found matching item at index " .. i)
        end
    end
    
    -- If itemData is still nil, we didn't find the item
    if not itemData then
        print("Error: No item found at index " .. validIndex .. " in store " .. storeId)
        TriggerClientEvent("sb_miningstore:BuyItemResponse", _source, false, "Item not found in store")
        return
    end
    
    print("Processing purchase for item: " .. itemData.itemName .. " with price: " .. itemData.buyprice)
    
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
    
    -- Debug the selling attempt with all details
    print("^2===== SELL ITEM TRANSACTION =====^7")
    print("^3Player: ^7" .. fname .. " " .. lname)
    print("^3Item: ^7" .. ItemName .. " (^3" .. value.quantity .. "^7)")
    print("^3Price: ^7$" .. value.sellprice .. " x " .. value.quantity .. " = $" .. total2)

    if value.weapon then
        local countWeap = 0
        local userWeapons = VORPinv.getUserInventoryWeapons(_source)
        
        if not userWeapons then
            print("^1Error: Failed to get player weapons inventory^7")
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
            print("^1Player has no weapons of type: ^7" .. ItemName)
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
                    print("^2Found item ^7" .. ItemName .. "^2 in inventory with count: ^7" .. itemCount)
                    break
                end
            end
        else
            print("^1Error: Failed to get player inventory^7")
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - inventory error")
            return false
        end
        
        if not itemFound then
            print("^1Item not found in player inventory: ^7" .. ItemName)
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - item not found")
            return false
        end
        
        -- Check if player has enough items
        if itemCount < value.quantity then
            print("^1Player doesn't have enough items - Has: ^7" .. itemCount .. "^1, Wants to sell: ^7" .. value.quantity)
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "You don't have enough of this item")
            return false
        end
        
        -- Try to remove the items from inventory
        print("^3Removing ^7" .. value.quantity .. " ^3of ^7" .. ItemName .. " ^3from inventory^7")
        local success = VORPinv.subItem(_source, ItemName, value.quantity)
        
        if success then
            canContinue = true
            print("^2Successfully removed items from inventory^7")
        else
            print("^1Failed to remove items from inventory^7")
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - inventory error")
            return false
        end
    end

    if not canContinue then
        print("^1Transaction failed - canContinue is false^7")
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Transaction failed - no items to sell")
        return false
    end

    if Config.MiningStores[storeId].DynamicStore then
        if not checkStoreLimits(storeId, ItemName, value.quantity, "sell") then
            print("^1Transaction failed - store limit reached^7")
            TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Store can't buy any more of this item")
            return false
        end
    end

    -- Add money to player
    if value.currencyType == "cash" then
        print("^2Adding $^7" .. total2 .. " ^2to player^7")
        Character.addCurrency(0, total)
        local successMessage = "Sold " .. value.quantity .. " " .. value.itemLabel .. " for $" .. total2
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, true, successMessage)
        print("^2Transaction complete - Added $" .. total2 .. " to player for selling " .. value.quantity .. " " .. ItemName .. "^7")
    end
    
    print("^2===== TRANSACTION COMPLETE =====^7")
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
        print("^1Error: Store data not found for storeId: " .. storeId .. "^7")
        VORPcore.NotifyRightTip(_source, "Store data not found", 3000)
        return
    end

    if not buyItems then
        print("^1Warning: buyItems is nil for storeId: " .. storeId .. ", initializing empty table^7")
        buyItems = {}
    end

    if not sellItems then
        print("^1Warning: sellItems is nil for storeId: " .. storeId .. ", initializing empty table^7")
        sellItems = {}
    end

    -- Debug: Print sellable items configuration
    print("^3===== DEBUG: SELLABLE ITEMS IN CONFIG =====^7")
    for idx, item in pairs(sellItems) do
        print("^3Item " .. idx .. ": ^7" .. item.itemName .. " (^2" .. item.itemLabel .. "^7)")
    end
    
    -- Debug: Print buyable items configuration
    print("^3===== DEBUG: BUYABLE ITEMS IN CONFIG =====^7")
    for idx, item in pairs(buyItems) do
        print("^3Item " .. idx .. ": ^7" .. item.itemName .. " (^2" .. item.itemLabel .. "^7)")
    end
    
    -- Check if player has the required items for selling in their inventory
    local playerItems = {}
    
    -- Get player's entire inventory first
    local playerInventory = VORPinv.getUserInventoryItems(_source)
    
    if playerInventory then
        print("^2Successfully retrieved player inventory with ^3" .. #playerInventory .. "^2 items^7")
        
        -- Debug: Print all player inventory items
        print("^3===== DEBUG: PLAYER INVENTORY ITEMS =====^7")
        for _, item in pairs(playerInventory) do
            print("^3Inventory item: ^7" .. item.name .. " (^2" .. item.label .. "^7) - Count: ^2" .. item.count)
        end
        
        -- Create list of items we're specifically looking for
        local interestingItems = {
            "goldnugget", "clay", "provision_coal", "copper", "iron", "sulfur", "stone", 
            "coal", "nitrite", "rock", "salt" -- Added new items from config.lua
        }
        
        -- Debug: Specifically check for mining items we care about
        print("^3===== DEBUG: CHECKING FOR SPECIFIC MINING ITEMS =====^7")
        for _, itemName in pairs(interestingItems) do
            local found = false
            for _, invItem in pairs(playerInventory) do
                if invItem.name == itemName then
                    found = true
                    print("^2FOUND mining item: ^7" .. itemName .. " (^2" .. invItem.label .. "^7) - Count: ^2" .. invItem.count)
                    break
                end
            end
            
            if not found then
                print("^1MISSING mining item: ^7" .. itemName)
            end
        end
        
        -- Check which sellable items the player has
        for _, item in pairs(sellItems) do
            print("^3Checking if player has item: ^7" .. item.itemName)
            
            -- Look for the item in the player's inventory
            for _, invItem in pairs(playerInventory) do
                if invItem.name == item.itemName and invItem.count > 0 then
                    playerItems[item.itemName] = {
                        count = invItem.count,
                        label = item.itemLabel,
                        type = "item",
                        canUse = true,
                        canRemove = true,
                        isDegradable = false
                    }
                    print("^2Player has ^3" .. invItem.count .. "^2 of item ^3" .. item.itemName .. "^7")
                    break
                end
            end
        end
        
        -- Debug: Print matched items that player can sell
        print("^3===== DEBUG: MATCHED SELLABLE ITEMS =====^7")
        local matchCount = 0
        for itemName, item in pairs(playerItems) do
            print("^2Player can sell: ^7" .. itemName .. " (^2" .. item.label .. "^7) - Count: ^2" .. item.count)
            matchCount = matchCount + 1
        end
        
        if matchCount == 0 then
            print("^1WARNING: No matching items found for player to sell!^7")
        end
    else
        print("^1Failed to retrieve player inventory^7")
    end
    
    -- Send the store data to the client
    TriggerClientEvent("sb_miningstore:OpenStoreMenu", _source, storeId, buyItems, sellItems, storeData)
end)

-- Server event to sell an item
RegisterServerEvent("sb_miningstore:SellItem")
AddEventHandler("sb_miningstore:SellItem", function(storeId, itemIndex, amount)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local sellItemsList = Config.SellItems[storeId]
    
    -- Debug logging
    print("^3===== SELL ATTEMPT =====^7")
    print("^3Store: ^7" .. storeId)
    print("^3Item index: ^7" .. tostring(itemIndex))
    print("^3Amount: ^7" .. amount)
    print("^3Player: ^7" .. Character.firstname .. " " .. Character.lastname)
    
    if not sellItemsList then
        print("^1Error: sellItemsList is nil for storeId: ^7" .. storeId)
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Store inventory not found")
        return
    end
    
    -- Safety check - ensure the index is numeric and convert if needed
    local validIndex = tonumber(itemIndex)
    if not validIndex then
        print("^1Error: Invalid index type: ^7" .. type(itemIndex))
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Invalid item selection")
        return
    end
    
    -- Check if the index is within bounds
    if validIndex < 1 or validIndex > #sellItemsList then
        print("^1Error: Index out of bounds. Valid range: 1-" .. #sellItemsList .. ", Got: " .. validIndex)
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Invalid item selection")
        return
    end
    
    -- Directly access the array element by using the index
    local itemData = sellItemsList[validIndex]
    
    if not itemData then
        print("^1Error: No item found at index " .. validIndex .. " in store " .. storeId)
        TriggerClientEvent("sb_miningstore:SellItemResponse", _source, false, "Item not found in store")
        return
    end
    
    print("^2Found item: ^7" .. itemData.itemName .. " at index " .. validIndex)
    print("^3Processing sale for: ^7" .. itemData.itemName .. " x" .. amount .. " at $" .. itemData.sellprice .. " each")
    
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