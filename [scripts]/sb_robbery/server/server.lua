-- sb_robbery Server Script
-- Author: Salah
-- Description: Server-side functionality for the Store and Bank Robbery system

-- Initialization
local VORPcore = {}
local VORPInv = {}
local robbedBanks = {}
local robbedStores = {}
local bankRobberyCooldowns = {} -- Track exact cooldown times
local storeRobberyCooldowns = {} -- Track store robbery cooldowns

-- Load VORP API resources
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

Citizen.CreateThread(function()
    VORPInv = exports.vorp_inventory:vorp_inventoryApi()
end)

-- Get player job event handler
RegisterServerEvent("sb_robbery:getPlayerJob")
AddEventHandler("sb_robbery:getPlayerJob", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    
    if Character then
        local job = Character.job
        TriggerClientEvent("sb_robbery:setPlayerJob", _source, job)
    end
end)

-- Check money and available banks
RegisterServerEvent("sb_robbery:checkMoney")
AddEventHandler("sb_robbery:checkMoney", function(price)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local money = Character.money
    
    -- Check available banks
    local availableBanks = {}
    for _, bank in pairs(Config.Banks) do
        if not robbedBanks[bank.name] then
            table.insert(availableBanks, bank.name)
        end
    end
    
    -- Check if player has enough money
    if money >= price then
        -- Check police count
        local policeCount = CountPolice()
        
        if policeCount >= Config.MinBankPolice then
            -- Remove money from player
            Character.removeCurrency(0, price)
            
            -- Give dynamite item to player
            VORPInv.addItem(_source, "dynamite", 1)
            
            -- Trigger client event
            TriggerClientEvent("sb_robbery:moneyCheckResult", _source, true, availableBanks)
        else
            TriggerClientEvent("vorp:TipRight", _source, Config.Languages[Config.selectedLanguage].notEnoughPolice, 4000)
            TriggerClientEvent("sb_robbery:moneyCheckResult", _source, false, {})
        end
    else
        TriggerClientEvent("vorp:TipRight", _source, Config.Languages[Config.selectedLanguage].insufficientMoney, 4000)
        TriggerClientEvent("sb_robbery:moneyCheckResult", _source, false, {})
    end
end)

-- Check available stores
RegisterServerEvent("sb_robbery:checkAvailableStores")
AddEventHandler("sb_robbery:checkAvailableStores", function()
    local _source = source
    
    -- Check available stores
    local availableStores = {}
    for _, store in pairs(Config.Shops) do
        local storeName = store.name
        -- Check explicitly if the store is not in robbedStores or if its cooldown has expired
        if not robbedStores[storeName] or GetStoreRemainingCooldown(storeName) <= 0 then
            table.insert(availableStores, storeName)
        else
            -- Debug log for stores on cooldown
            print("Store " .. storeName .. " unavailable - on cooldown")
        end
    end
    
    -- Debug log
    print("Available stores: " .. #availableStores)
    
    -- Check police count
    local policeCount = CountPolice()
    
    if policeCount >= Config.MinPolice then
        if #availableStores > 0 then
            -- Trigger client event with available stores
            TriggerClientEvent("sb_robbery:availableStores", _source, availableStores)
            
            -- Alert all police officers about the store robbery planning
            AlertPoliceAboutPlanning(_source)
        else
            TriggerClientEvent("vorp:TipRight", _source, "All stores are currently unavailable due to recent robberies.", 4000)
            TriggerClientEvent("sb_robbery:availableStores", _source, {})
        end
    else
        TriggerClientEvent("vorp:TipRight", _source, Config.Languages[Config.selectedLanguage].notEnoughPolice, 4000)
        TriggerClientEvent("sb_robbery:availableStores", _source, {})
    end
end)

-- Alert police about robbery planning
function AlertPoliceAboutPlanning(sourcePlayer)
    local players = GetPlayers()
    local playerCoords = GetEntityCoords(GetPlayerPed(sourcePlayer))
    
    -- Notify all police players about the planning
    for _, playerId in ipairs(players) do
        local Character = VORPcore.getUser(tonumber(playerId)).getUsedCharacter
        if Character and TableContains(Config.PoliceJobs, Character.job) then
            TriggerClientEvent("sb_robbery:notifyPolicePlanning", tonumber(playerId), playerCoords)
        end
    end
end

-- Count police online
function CountPolice()
    local police = 0
    local players = GetPlayers()
    
    for _, playerId in ipairs(players) do
        local Character = VORPcore.getUser(tonumber(playerId)).getUsedCharacter
        
        if Character then
            local job = Character.job
            if TableContains(Config.PoliceJobs, job) then
                police = police + 1
            end
        end
    end
    
    return police
end

-- Helper function to check if a table contains a value
function TableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

-- Get remaining cooldown time in seconds for banks
function GetRemainingCooldown(bankName)
    if not bankRobberyCooldowns[bankName] then
        return 0
    end
    
    local currentTime = os.time()
    local timeDiff = bankRobberyCooldowns[bankName] - currentTime
    
    if timeDiff <= 0 then
        robbedBanks[bankName] = false
        bankRobberyCooldowns[bankName] = nil
        return 0
    end
    
    return timeDiff
end

-- Get remaining cooldown time in seconds for stores
function GetStoreRemainingCooldown(storeName)
    if not storeRobberyCooldowns[storeName] then
        print("No cooldown found for " .. storeName)
        return 0
    end
    
    local currentTime = os.time()
    local timeDiff = storeRobberyCooldowns[storeName] - currentTime
    
    if timeDiff <= 0 then
        print("Cooldown expired for " .. storeName)
        robbedStores[storeName] = nil
        storeRobberyCooldowns[storeName] = nil
        return 0
    end
    
    print("Store " .. storeName .. " has " .. timeDiff .. " seconds remaining on cooldown")
    return timeDiff
end

-- Notify police event for bank robbery
RegisterServerEvent("sb_robbery:notifyPolice")
AddEventHandler("sb_robbery:notifyPolice", function(bankName)
    local _source = source
    local players = GetPlayers()
    
    -- Mark bank as robbed
    robbedBanks[bankName] = true
    
    -- Set cooldown end time (2 hours from now)
    local cooldownEndTime = os.time() + (Config.robberyCooldown / 1000) -- Convert milliseconds to seconds
    bankRobberyCooldowns[bankName] = cooldownEndTime
    
    -- Notify player about cooldown
    local formattedTime = math.floor(Config.robberyCooldown / 60000) -- Convert to minutes
    TriggerClientEvent("vorp:TipRight", _source, string.format(Config.Languages[Config.selectedLanguage].bankCooldownMessage, formattedTime), 5000)
    
    -- Notify all police players
    for _, playerId in ipairs(players) do
        TriggerClientEvent("sb_robbery:notifyPoliceClient", tonumber(playerId), bankName)
    end
end)

-- Notify police event for store robbery
RegisterServerEvent("sb_robbery:notifyPoliceStore")
AddEventHandler("sb_robbery:notifyPoliceStore", function(storeName)
    local _source = source
    local players = GetPlayers()
    
    -- Mark store as robbed with true value
    robbedStores[storeName] = true
    
    -- Set cooldown end time (1 hour from now)
    local cooldownEndTime = os.time() + (Config.storeRobberyCooldown / 1000) -- Convert milliseconds to seconds
    storeRobberyCooldowns[storeName] = cooldownEndTime
    
    print("Setting cooldown for " .. storeName .. " until " .. os.date("%Y-%m-%d %H:%M:%S", cooldownEndTime))
    print("Robbery status: " .. tostring(robbedStores[storeName]))
    
    -- Broadcast updated cooldowns to all players
    TriggerClientEvent("sb_robbery:updateStoreCooldown", -1, storeName, cooldownEndTime)
    
    -- Notify player about cooldown
    local formattedTime = math.floor(Config.storeRobberyCooldown / 60000) -- Convert to minutes
    TriggerClientEvent("vorp:TipRight", _source, string.format(Config.Languages[Config.selectedLanguage].storeCooldownMessage, formattedTime), 5000)
    
    -- Notify all police players
    for _, playerId in ipairs(players) do
        local Character = VORPcore.getUser(tonumber(playerId)).getUsedCharacter
        if Character and TableContains(Config.PoliceJobs, Character.job) then
            TriggerClientEvent("sb_robbery:notifyPoliceStoreClient", tonumber(playerId), storeName)
        end
    end
end)

-- Check bank cooldown status (for client to query)
RegisterServerEvent("sb_robbery:checkBankCooldown")
AddEventHandler("sb_robbery:checkBankCooldown", function(bankName)
    local _source = source
    local remainingTime = GetRemainingCooldown(bankName)
    
    if remainingTime > 0 then
        -- Format time for display (hours and minutes)
        local hours = math.floor(remainingTime / 3600)
        local minutes = math.floor((remainingTime % 3600) / 60)
        local timeString = ""
        
        if hours > 0 then
            timeString = hours .. " " .. (hours == 1 and Config.Languages[Config.selectedLanguage].hour or Config.Languages[Config.selectedLanguage].hours)
            if minutes > 0 then
                timeString = timeString .. " " .. Config.Languages[Config.selectedLanguage]["and"] .. " " .. minutes .. " " .. (minutes == 1 and Config.Languages[Config.selectedLanguage].minute or Config.Languages[Config.selectedLanguage].minutes)
            end
        else
            timeString = minutes .. " " .. (minutes == 1 and Config.Languages[Config.selectedLanguage].minute or Config.Languages[Config.selectedLanguage].minutes)
        end
        
        TriggerClientEvent("vorp:TipRight", _source, string.format(Config.Languages[Config.selectedLanguage].bankOnCooldown, timeString), 5000)
    end
    
    TriggerClientEvent("sb_robbery:bankCooldownResponse", _source, bankName, remainingTime)
end)

-- Check store cooldown status
RegisterServerEvent("sb_robbery:checkStoreCooldown")
AddEventHandler("sb_robbery:checkStoreCooldown", function(storeName)
    local _source = source
    local remainingTime = GetStoreRemainingCooldown(storeName)
    
    if remainingTime > 0 then
        -- Format time for display (hours and minutes)
        local hours = math.floor(remainingTime / 3600)
        local minutes = math.floor((remainingTime % 3600) / 60)
        local timeString = ""
        
        if hours > 0 then
            timeString = hours .. " " .. (hours == 1 and Config.Languages[Config.selectedLanguage].hour or Config.Languages[Config.selectedLanguage].hours)
            if minutes > 0 then
                timeString = timeString .. " " .. Config.Languages[Config.selectedLanguage]["and"] .. " " .. minutes .. " " .. (minutes == 1 and Config.Languages[Config.selectedLanguage].minute or Config.Languages[Config.selectedLanguage].minutes)
            end
        else
            timeString = minutes .. " " .. (minutes == 1 and Config.Languages[Config.selectedLanguage].minute or Config.Languages[Config.selectedLanguage].minutes)
        end
        
        TriggerClientEvent("vorp:TipRight", _source, string.format(Config.Languages[Config.selectedLanguage].storeOnCooldown, timeString), 5000)
    end
    
    TriggerClientEvent("sb_robbery:storeCooldownResponse", _source, storeName, remainingTime)
end)

-- Handle bank cooldowns request from client
RegisterServerEvent("sb_robbery:requestBankCooldowns")
AddEventHandler("sb_robbery:requestBankCooldowns", function()
    local _source = source
    local cooldowns = {}
    
    -- Convert server-side cooldowns to a format the client can use
    for bankName, endTime in pairs(bankRobberyCooldowns) do
        if GetRemainingCooldown(bankName) > 0 then
            cooldowns[bankName] = endTime
        end
    end
    
    -- Send cooldowns to client
    TriggerClientEvent("sb_robbery:receiveBankCooldowns", _source, cooldowns)
end)

-- Handle store cooldowns request from client
RegisterServerEvent("sb_robbery:requestStoreCooldowns")
AddEventHandler("sb_robbery:requestStoreCooldowns", function()
    local _source = source
    local cooldowns = {}
    
    -- Convert server-side cooldowns to a format the client can use
    for storeName, endTime in pairs(storeRobberyCooldowns) do
        if GetStoreRemainingCooldown(storeName) > 0 then
            cooldowns[storeName] = endTime
        end
    end
    
    -- Send cooldowns to client
    TriggerClientEvent("sb_robbery:receiveStoreCooldowns", _source, cooldowns)
end)

-- Determine cash reward based on weighted chance
function DetermineCashReward()
    local random = math.random(1, 100)
    print("Store robbery reward roll: " .. random)
    
    -- Process each reward tier from highest to lowest for proper chance calculation
    for i = #Config.StoreRewards, 1, -1 do
        local tier = Config.StoreRewards[i]
        if random <= tier.chance then
            print("Reward selected: $" .. tier.amount)
            return tier.amount
        end
    end
    
    -- Default fallback (should never reach here if config is properly set up)
    print("No reward tier matched - using default $10")
    return 10
end

-- Give store robbery cash rewards to player
RegisterServerEvent("sb_robbery:giveStoreRewards")
AddEventHandler("sb_robbery:giveStoreRewards", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    
    -- Determine cash reward based on probability
    local cashReward = DetermineCashReward()
    
    -- Add money to player
    Character.addCurrency(0, cashReward)
    
    -- Notify player
    TriggerClientEvent("vorp:TipRight", _source, string.format(Config.Languages[Config.selectedLanguage].cashObtained, cashReward), 4000)
end)

-- Give bank robbery rewards to player
RegisterServerEvent("sb_robbery:giveRewards")
AddEventHandler("sb_robbery:giveRewards", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    
    -- Give bank robbery items
    for _, item in ipairs(Config.BankItems) do
        if item.amount > 0 then
            -- Random amount between half and full configured amount
            local randomAmount = math.random(math.floor(item.amount / 2), item.amount)
            
            -- Add item to player inventory
            VORPInv.addItem(_source, item.itemName, randomAmount)
            
            -- Notify player
            TriggerClientEvent("vorp:TipRight", _source, Config.Languages[Config.selectedLanguage].lootObtained, 4000)
        end
    end
end)

-- Remove dynamite after use
RegisterServerEvent("sb_robbery:removeDynamite")
AddEventHandler("sb_robbery:removeDynamite", function()
    local _source = source
    
    -- Remove dynamite from inventory
    VORPInv.subItem(_source, "dynamite", 1)
end)

-- Add the 'dynamite' item to the VORP inventory system
Citizen.CreateThread(function()
    Wait(1000)
    
    -- Register usable item (if needed in the future)
    VORPInv.RegisterUsableItem("dynamite", function(data)
        local _source = data.source
        -- We'll leave this placeholder in case you want to make dynamite usable outside the robbery
    end)
end)

-- Register debug command to check store cooldowns
RegisterCommand("check_cooldowns", function(source, args)
    local _source = source
    
    -- Only allow server console or admins to use this command
    if _source == 0 or IsPlayerAceAllowed(_source, "command") then
        print("==== STORE COOLDOWNS ====")
        local currentTime = os.time()
        local hasCooldowns = false
        
        for storeName, endTime in pairs(storeRobberyCooldowns) do
            local remaining = endTime - currentTime
            if remaining > 0 then
                hasCooldowns = true
                print(storeName .. ": " .. remaining .. " seconds remaining (" .. os.date("%H:%M:%S", endTime) .. ")")
            end
        end
        
        if not hasCooldowns then
            print("No active store cooldowns")
        end
        
        print("==== BANK COOLDOWNS ====")
        hasCooldowns = false
        
        for bankName, endTime in pairs(bankRobberyCooldowns) do
            local remaining = endTime - currentTime
            if remaining > 0 then
                hasCooldowns = true
                print(bankName .. ": " .. remaining .. " seconds remaining (" .. os.date("%H:%M:%S", endTime) .. ")")
            end
        end
        
        if not hasCooldowns then
            print("No active bank cooldowns")
        end
    end
end, false)

-- Register debug command to clear all cooldowns (admin only)
RegisterCommand("clear_cooldowns", function(source, args)
    local _source = source
    
    -- Only allow server console or admins to use this command
    if _source == 0 or IsPlayerAceAllowed(_source, "command") then
        print("Clearing all store and bank cooldowns...")
        
        -- Clear store cooldowns
        for storeName, _ in pairs(robbedStores) do
            robbedStores[storeName] = nil
        end
        
        for storeName, _ in pairs(storeRobberyCooldowns) do
            storeRobberyCooldowns[storeName] = nil
        end
        
        -- Clear bank cooldowns
        for bankName, _ in pairs(robbedBanks) do
            robbedBanks[bankName] = nil
        end
        
        for bankName, _ in pairs(bankRobberyCooldowns) do
            bankRobberyCooldowns[bankName] = nil
        end
        
        -- Notify all clients that cooldowns have been cleared
        TriggerClientEvent("sb_robbery:receiveBankCooldowns", -1, {})
        TriggerClientEvent("sb_robbery:receiveStoreCooldowns", -1, {})
        
        print("All cooldowns cleared")
    end
end, false) 