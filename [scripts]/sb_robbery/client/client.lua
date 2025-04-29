-- sb_robbery Client Script
-- Author: Salah
-- Description: Client-side functionality for the Store and Bank Robbery system

local selectedBank = nil
local selectedStore = nil
local activeRobbery = false
local storeRobberyActive = false
local dynamiteSet = false
local robberyCompleted = false
local storeRobberyCompleted = false
local PlayerJob = nil
local firstTime = true
local robbedBankCooldowns = {} -- Store cooldown timers for robbed banks
local robbedStoreCooldowns = {} -- Store cooldown timers for robbed stores

-- Initialize the script
Citizen.CreateThread(function()
    while firstTime do
        Wait(1000)
        TriggerServerEvent("sb_robbery:getPlayerJob")
        firstTime = false
    end
    
    Wait(2000) -- Wait a bit longer before initializing NPCs
    InitializeNPCs()
    InitializePrompts()
    
    -- Request current bank cooldown status from server
    TriggerServerEvent("sb_robbery:requestBankCooldowns")
    
    -- Request current store cooldown status from server
    TriggerServerEvent("sb_robbery:requestStoreCooldowns")
end)

-- Get player job from server
RegisterNetEvent('sb_robbery:setPlayerJob')
AddEventHandler('sb_robbery:setPlayerJob', function(job)
    PlayerJob = job
end)

-- Create NPCs for the robbery missions
function InitializeNPCs()
    for _, npcData in ipairs(Config.NPCS) do
        -- Extract coordinates
        local coords = npcData.coords
        local x, y, z, h = coords.x, coords.y, coords.z, coords.w or coords[4] or 0.0
        
        -- Request the model
        local modelName = npcData.model
        local modelHash = GetHashKey(modelName)
        
        print("Requesting model: " .. modelName .. " with hash: " .. modelHash)
        
        if IsModelValid(modelHash) then
            if not HasModelLoaded(modelHash) then
                RequestModel(modelHash)
                local startTime = GetGameTimer()
                
                -- Wait for model to load with timeout
                while not HasModelLoaded(modelHash) do
                    Wait(10)
                    if GetGameTimer() - startTime > 10000 then -- 10 second timeout
                        print("Model load timeout for: " .. modelName)
                        break
                    end
                end
            end
        else
            print("Invalid model: " .. modelName)
            goto continue
        end
        
        if HasModelLoaded(modelHash) then
            print("Model loaded successfully: " .. modelName)
            
            -- Create the ped using the standard CreatePed function (used in mining script)
            local ped = CreatePed(modelHash, x, y, z, h, false, true, true, true)
            
            if ped ~= 0 and DoesEntityExist(ped) then
                print("Successfully created NPC at: " .. x .. ", " .. y .. ", " .. z)
                
                -- Set ped properties
                Citizen.InvokeNative(0x283978A15512B2FE, ped, true) -- Set random outfit variation
                SetEntityCanBeDamaged(ped, false)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                FreezeEntityPosition(ped, true)
                
                -- Apply outfit if specified
                if npcData.outfit then
                    Citizen.InvokeNative(0x77FF8D35EEC6BBC4, ped, tonumber(npcData.outfit), 0)
                end
            else
                print("Failed to create NPC. Entity ID: " .. tostring(ped))
            end
            
            -- Clean up the model
            SetModelAsNoLongerNeeded(modelHash)
        else
            print("Failed to load model: " .. modelName)
        end
        
        ::continue::
    end
end

-- Initialize prompts
local talkPrompt
local startRobberyPrompt
local searchVaultPrompt
local storeRobberyPrompt
local collectCashPrompt

function InitializePrompts()
    -- Prompt for talking to NPC
    talkPrompt = PromptRegisterBegin()
    PromptSetControlAction(talkPrompt, Config.Keys.ENTER)
    local str = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].talkPrompt)
    PromptSetText(talkPrompt, str)
    PromptSetEnabled(talkPrompt, true)
    PromptSetVisible(talkPrompt, true)
    PromptSetStandardMode(talkPrompt, true)
    PromptSetGroup(talkPrompt, 1)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, talkPrompt, true)
    PromptRegisterEnd(talkPrompt)

    -- Prompt for starting robbery
    startRobberyPrompt = PromptRegisterBegin()
    PromptSetControlAction(startRobberyPrompt, Config.Keys.ENTER)
    local str2 = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].robberyInProgress)
    PromptSetText(startRobberyPrompt, str2)
    PromptSetEnabled(startRobberyPrompt, true)
    PromptSetVisible(startRobberyPrompt, true)
    PromptSetStandardMode(startRobberyPrompt, true)
    PromptSetGroup(startRobberyPrompt, 2)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, startRobberyPrompt, true)
    PromptRegisterEnd(startRobberyPrompt)

    -- Prompt for searching the vault
    searchVaultPrompt = PromptRegisterBegin()
    PromptSetControlAction(searchVaultPrompt, Config.Keys.ENTER)
    local str3 = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].BankrobberyLoot)
    PromptSetText(searchVaultPrompt, str3)
    PromptSetEnabled(searchVaultPrompt, true)
    PromptSetVisible(searchVaultPrompt, true)
    PromptSetStandardMode(searchVaultPrompt, true)
    PromptSetGroup(searchVaultPrompt, 3)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, searchVaultPrompt, true)
    PromptRegisterEnd(searchVaultPrompt)
    
    -- Prompt for starting store robbery
    storeRobberyPrompt = PromptRegisterBegin()
    PromptSetControlAction(storeRobberyPrompt, Config.Keys.ENTER)
    local str4 = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].storeRobberyPrompt)
    PromptSetText(storeRobberyPrompt, str4)
    PromptSetEnabled(storeRobberyPrompt, true)
    PromptSetVisible(storeRobberyPrompt, true)
    PromptSetStandardMode(storeRobberyPrompt, true)
    PromptSetGroup(storeRobberyPrompt, 4)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, storeRobberyPrompt, true)
    PromptRegisterEnd(storeRobberyPrompt)
    
    -- Prompt for collecting store cash
    collectCashPrompt = PromptRegisterBegin()
    PromptSetControlAction(collectCashPrompt, Config.Keys.ENTER)
    local str5 = CreateVarString(10, 'LITERAL_STRING', 'Press [~e~ENTER~q~] to take the money')
    PromptSetText(collectCashPrompt, str5)
    PromptSetEnabled(collectCashPrompt, true)
    PromptSetVisible(collectCashPrompt, true)
    PromptSetStandardMode(collectCashPrompt, true)
    PromptSetGroup(collectCashPrompt, 5)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, collectCashPrompt, true)
    PromptRegisterEnd(collectCashPrompt)
end

-- Main thread for NPC interaction
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local inRange = false
        
        -- If we're not in an active robbery, check for starting points
        if not activeRobbery and not storeRobberyActive then
            -- Check for NPC (bank robbery)
            for _, npcData in ipairs(Config.NPCS) do
                local npcCoords = vector3(npcData.coords.x, npcData.coords.y, npcData.coords.z)
                local distance = #(coords - npcCoords)
                
                if distance < Config.ZoneSize then
                    inRange = true
                    local promptText = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].bankRobbery)
                    PromptSetActiveGroupThisFrame(1, promptText)
                    
                    if Citizen.InvokeNative(0xC92AC953F0A982AE, talkPrompt) then
                        StartNPCConversation()
                    end
                end
            end
            
            -- Check if player is near any store for robbery
            for _, store in ipairs(Config.Shops) do
                local storeCoords = store.coords
                local distance = #(coords - storeCoords)
                
                if distance < Config.ZoneSize then
                    inRange = true
                    
                    -- Check if this store is on cooldown before showing the prompt
                    local storeName = store.name
                    local onCooldown = false
                    local cooldownMessage = ""
                    
                    if robbedStoreCooldowns[storeName] then
                        print("Store check - " .. storeName .. " has cooldown end time: " .. robbedStoreCooldowns[storeName])
                        print("Store check - Current time: " .. math.floor(GetGameTimer() / 1000))
                        
                        local currentGameTime = math.floor(GetGameTimer() / 1000)
                        
                        -- Check if the store is on cooldown, handling both server timestamp and game timer cases
                        if robbedStoreCooldowns[storeName] > 1700000000 then
                            -- This is likely a server timestamp - use a fixed cooldown
                            onCooldown = true
                            local cooldownTime = 3600 -- 1 hour in seconds
                            local remainingTime = FormatRemainingTime(currentGameTime + cooldownTime)
                            cooldownMessage = string.format(
                                "This store has been robbed recently. Try again in %s.",
                                remainingTime
                            )
                            print("Store is on cooldown (server timestamp): " .. cooldownMessage)
                        elseif robbedStoreCooldowns[storeName] > currentGameTime then
                            -- This is a game timer-based cooldown
                            onCooldown = true
                            local remainingTime = FormatRemainingTime(robbedStoreCooldowns[storeName])
                            cooldownMessage = string.format(
                                "This store has been robbed recently. Try again in %s.",
                                remainingTime
                            )
                            print("Store is on cooldown (game timer): " .. cooldownMessage)
                        else
                            print("Store cooldown has expired")
                        end
                    end
                    
                    -- Always show the prompt, but handle the click differently based on cooldown
                    local promptText = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].storeRobbery)
                    PromptSetActiveGroupThisFrame(4, promptText)
                    
                    if Citizen.InvokeNative(0xC92AC953F0A982AE, storeRobberyPrompt) then
                        -- Debug message
                        print("Store robbery prompt triggered")
                        
                        if onCooldown then
                            -- Show cooldown message directly instead of checking with server
                            TriggerEvent("vorp:TipRight", cooldownMessage, 6000)
                        else
                            -- Check if store is available for robbery
                            TriggerServerEvent("sb_robbery:checkAvailableStores")
                        end
                    end
                end
            end
        end
        
        if not inRange then
            Citizen.Wait(500)
        else
            Citizen.Wait(0)
        end
    end
end)

-- NPC Conversation Function
function StartNPCConversation()
    -- Dialog sequence
    TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].Talk1, 4000)
    Citizen.Wait(4000)
    TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].Talk2, 4000)
    Citizen.Wait(4000)
    TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].Talk3, 4000)
    Citizen.Wait(4000)
    TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].Talk4, 4000)
    Citizen.Wait(4000)
    
    -- Show confirmation dialog with the price
    local confirmMessage = string.format(
        "Do you want to buy dynamite for $%d?", 
        Config.DynamitePrice
    )
    
    TriggerEvent("vorp:TipRight", confirmMessage, 8000)
    
    -- Create confirmation prompts
    local confirmGroup = GetRandomIntInRange(0, 0xffffff)
    local confirmYesPrompt = PromptRegisterBegin()
    local confirmNoPrompt = PromptRegisterBegin()
    
    -- Yes prompt
    PromptSetControlAction(confirmYesPrompt, 0x760A9C6F) -- G key
    PromptSetText(confirmYesPrompt, CreateVarString(10, "LITERAL_STRING", "Yes"))
    PromptSetEnabled(confirmYesPrompt, true)
    PromptSetVisible(confirmYesPrompt, true)
    PromptSetStandardMode(confirmYesPrompt, true)
    PromptSetGroup(confirmYesPrompt, confirmGroup)
    PromptRegisterEnd(confirmYesPrompt)
    
    -- No prompt
    PromptSetControlAction(confirmNoPrompt, 0x4AF4D473) -- F key
    PromptSetText(confirmNoPrompt, CreateVarString(10, "LITERAL_STRING", "No"))
    PromptSetEnabled(confirmNoPrompt, true)
    PromptSetVisible(confirmNoPrompt, true)
    PromptSetStandardMode(confirmNoPrompt, true)
    PromptSetGroup(confirmNoPrompt, confirmGroup)
    PromptRegisterEnd(confirmNoPrompt)
    
    -- Loop until player chooses an option
    local confirmed = false
    local ignored = false
    local timeout = GetGameTimer() + 20000 -- 20 second timeout
    
    while not confirmed and not ignored and GetGameTimer() < timeout do
        Wait(0)
        local promptText = CreateVarString(10, 'LITERAL_STRING', "Purchase Dynamite")
        PromptSetActiveGroupThisFrame(confirmGroup, promptText)
        
        if Citizen.InvokeNative(0xC92AC953F0A982AE, confirmYesPrompt) then
            confirmed = true
        elseif Citizen.InvokeNative(0xC92AC953F0A982AE, confirmNoPrompt) then
            ignored = true
        end
    end
    
    -- Clean up prompts
    PromptDelete(confirmYesPrompt)
    PromptDelete(confirmNoPrompt)
    
    -- Check if player confirmed
    if confirmed then
        -- Check if player has enough money
        TriggerServerEvent("sb_robbery:checkMoney", Config.DynamitePrice)
    else
        TriggerEvent("vorp:TipRight", "You decided not to buy the dynamite.", 4000)
    end
end

-- Process bank cooldowns from server
RegisterNetEvent('sb_robbery:receiveBankCooldowns')
AddEventHandler('sb_robbery:receiveBankCooldowns', function(cooldowns)
    robbedBankCooldowns = cooldowns
end)

-- Update a specific bank's cooldown
RegisterNetEvent('sb_robbery:updateBankCooldown')
AddEventHandler('sb_robbery:updateBankCooldown', function(bankName, endTime)
    robbedBankCooldowns[bankName] = endTime
end)

-- Process store cooldowns from server
RegisterNetEvent('sb_robbery:receiveStoreCooldowns')
AddEventHandler('sb_robbery:receiveStoreCooldowns', function(cooldowns)
    print("Received store cooldowns from server")
    robbedStoreCooldowns = {}
    
    -- Convert server timestamps to game-time offsets
    local currentGameTime = math.floor(GetGameTimer() / 1000)
    
    for store, endTime in pairs(cooldowns) do
        print("Store: " .. store .. " Cooldown End: " .. endTime)
        
        if endTime > 1700000000 then
            -- This is likely a Unix timestamp from the server
            -- Calculate a fixed cooldown offset instead
            robbedStoreCooldowns[store] = currentGameTime + 3600 -- Add 1 hour cooldown
            print("Converted server timestamp to game time: " .. robbedStoreCooldowns[store])
        else
            -- Already in the correct format
            robbedStoreCooldowns[store] = endTime
        end
    end
end)

-- Update a specific store's cooldown
RegisterNetEvent('sb_robbery:updateStoreCooldown')
AddEventHandler('sb_robbery:updateStoreCooldown', function(storeName, endTime)
    print("Updating cooldown for " .. storeName .. " to end at: " .. endTime)
    
    local currentGameTime = math.floor(GetGameTimer() / 1000)
    
    if endTime > 1700000000 then
        -- This is likely a Unix timestamp from the server
        -- Convert to a game-time based cooldown period
        robbedStoreCooldowns[storeName] = currentGameTime + 3600 -- 1 hour cooldown
        print("Converted server timestamp to game time: " .. robbedStoreCooldowns[storeName])
    else
        -- Already in the right format
        robbedStoreCooldowns[storeName] = endTime
    end
end)

-- Store robbery available stores response
RegisterNetEvent('sb_robbery:availableStores')
AddEventHandler('sb_robbery:availableStores', function(availableStores)
    if #availableStores > 0 then
        -- Instead of selecting a random store, find the store the player is actually in
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local closestStore = nil
        local closestDistance = 999999.0
        local foundAvailableStore = false
        
        -- Find the closest available store to the player
        for _, storeName in ipairs(availableStores) do
            for _, store in ipairs(Config.Shops) do
                if store.name == storeName then
                    local distance = #(playerCoords - store.coords)
                    if distance < Config.ZoneSize and distance < closestDistance then
                        closestStore = storeName
                        closestDistance = distance
                        foundAvailableStore = true
                    end
                end
            end
        end
        
        if foundAvailableStore then
            selectedStore = closestStore
            storeRobberyActive = true
            
            -- Notify player
            TriggerEvent("vorp:TipRight", "You're planning to rob: " .. selectedStore, 5000)
            
            -- Debug message
            print("Store robbery selected: " .. selectedStore)
            
            -- Create a much shorter timeout before starting the robbery - IMMEDIATE
            Citizen.SetTimeout(500, function() -- 500ms is a minimal delay to prevent UI issues
                -- Find the store coordinates
                local storeCoords = nil
                for _, store in ipairs(Config.Shops) do
                    if store.name == selectedStore then
                        storeCoords = store.coords
                        break
                    end
                end
                
                if storeCoords then
                    -- Go straight to robbery execution
                    ExecuteStoreRobbery(storeCoords)
                else
                    print("Error: Could not find store coordinates for " .. selectedStore)
                    storeRobberyActive = false
                end
            end)
        else
            -- Player is not close enough to any available store - this case shouldn't happen normally
            TriggerEvent("vorp:TipRight", "No available stores to rob in this area.", 5000)
        end
    else
        -- Check if any stores are on cooldown
        local message = Config.Languages[Config.selectedLanguage].storeRobberyMessage
        
        -- Check if the player is near a specific store that's on cooldown
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local nearbyStore = nil
        
        for _, store in ipairs(Config.Shops) do
            local distance = #(playerCoords - store.coords)
            if distance < Config.ZoneSize then
                nearbyStore = store.name
                break
            end
        end
        
        if nearbyStore then
            -- Check if this specific store is on cooldown
            if robbedStoreCooldowns[nearbyStore] and robbedStoreCooldowns[nearbyStore] > (GetGameTimer() / 1000) then
                local remainingTime = FormatRemainingTime(robbedStoreCooldowns[nearbyStore])
                message = string.format(
                    "This store has been robbed recently. Try again in %s.",
                    remainingTime
                )
            else
                -- This case shouldn't normally happen - if we're here, the store should be available or on cooldown
                message = "This store can't be robbed right now."
            end
        else
            -- This message should rarely display since the prompt only shows when inside a store
            message = "No store detected nearby."
        end
        
        TriggerEvent("vorp:TipRight", message, 6000)
    end
end)

-- Format remaining time helper function
function FormatRemainingTime(endTime)
    -- Use GetGameTimer() / 1000 instead of os.time() which isn't available
    local currentTime = math.floor(GetGameTimer() / 1000)
    local remainingSeconds = math.max(0, endTime - currentTime)
    
    print("FormatRemainingTime - Current time: " .. currentTime)
    print("FormatRemainingTime - End time: " .. endTime)
    print("FormatRemainingTime - Remaining seconds: " .. remainingSeconds)
    
    -- Check for unrealistic values that might indicate a bug
    -- Cap the maximum time to 24 hours (86400 seconds) to prevent absurd values
    if remainingSeconds > 86400 then
        print("FormatRemainingTime - Correcting unrealistic value")
        -- Use fixed cooldown values based on config
        local storeRobberyCooldown = 3600 -- 1 hour in seconds
        local bankRobberyCooldown = 7200 -- 2 hours in seconds
        
        if endTime > 1700000000 then 
            -- This is likely a timestamp from the server (Unix time)
            -- We need to convert to game time based offset
            -- Get an approximation of the time difference
            local gameToServerTimeDiff = endTime - currentTime - storeRobberyCooldown
            print("FormatRemainingTime - Time difference detected: " .. gameToServerTimeDiff)
            
            -- Use a fixed cooldown
            remainingSeconds = storeRobberyCooldown
            print("FormatRemainingTime - Using fixed cooldown: " .. remainingSeconds)
        else
            -- Use a reasonable fallback if we can't determine
            remainingSeconds = 3600 -- Default to 1 hour
            print("FormatRemainingTime - Using fallback: " .. remainingSeconds)
        end
    end
    
    local hours = math.floor(remainingSeconds / 3600)
    local minutes = math.floor((remainingSeconds % 3600) / 60)
    
    print("FormatRemainingTime - Formatted time: " .. hours .. " hours and " .. minutes .. " minutes")
    
    if hours > 0 then
        return string.format("%d hours and %d minutes", hours, minutes)
    else
        return string.format("%d minutes", minutes)
    end
end

-- Server response for money check
RegisterNetEvent('sb_robbery:moneyCheckResult')
AddEventHandler('sb_robbery:moneyCheckResult', function(hasMoney, bankNames)
    if hasMoney then
        -- Player has enough money, select a random bank
        if #bankNames > 0 then
            selectedBank = bankNames[math.random(#bankNames)]
            TriggerEvent("vorp:TipRight", string.format(Config.Languages[Config.selectedLanguage].dynamiteGiven, selectedBank), 5000)
            activeRobbery = true
            
            -- Notify police about robbery
            local policeCount = 0
            TriggerServerEvent("sb_robbery:notifyPolice", selectedBank)
            
            -- Start the bank robbery monitoring
            Citizen.CreateThread(function()
                MonitorBankRobbery()
            end)
        else
            local message = Config.Languages[Config.selectedLanguage].bankRobberyMessage
            
            -- Check if any banks are on cooldown and provide the time remaining
            local anyCooldowns = false
            for bankName, endTime in pairs(robbedBankCooldowns) do
                if endTime > (GetGameTimer() / 1000) then
                    local remainingTime = FormatRemainingTime(endTime)
                    message = string.format(
                        "This bank has been robbed before. Try again in %s.", 
                        remainingTime
                    )
                    anyCooldowns = true
                    break -- Show only the first one with a cooldown
                end
            end
            
            if not anyCooldowns then
                message = "All banks are currently unavailable. Try again later."
            end
            
            TriggerEvent("vorp:TipRight", message, 6000)
        end
    else
        TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].insufficientMoney, 4000)
    end
end)

-- Monitor the bank robbery process
function MonitorBankRobbery()
    while activeRobbery do
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local inRange = false
        
        -- Check if player is near the selected bank
        for _, bank in ipairs(Config.Banks) do
            if bank.name == selectedBank then
                local bankCoords = bank.coords
                local distance = #(coords - bankCoords)
                
                if distance < Config.ZoneSize and not dynamiteSet then
                    inRange = true
                    local promptText = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].bankRobbery)
                    PromptSetActiveGroupThisFrame(2, promptText)
                    
                    if Citizen.InvokeNative(0xC92AC953F0A982AE, startRobberyPrompt) then
                        -- Place dynamite
                        TriggerEvent("vorp:TipRight", "Starting dynamite placement...", 3000)
                        PlaceDynamite(bankCoords)
                    end
                end
                
                -- If dynamite exploded and player is near the vault
                if dynamiteSet and not robberyCompleted and distance < Config.ZoneSize then
                    inRange = true
                    local promptText = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].bankRobbery)
                    PromptSetActiveGroupThisFrame(3, promptText)
                    
                    if Citizen.InvokeNative(0xC92AC953F0A982AE, searchVaultPrompt) then
                        -- Search the vault
                        SearchVault()
                    end
                end
            end
        end
        
        if not inRange then
            Citizen.Wait(500)
        end
        
        Citizen.Wait(0)
    end
end

-- Place dynamite function
function PlaceDynamite(bankCoords)
    local playerPed = PlayerPedId()
    
    -- Use only the working animation for placing dynamite
    local dict = "amb_work@world_human_crouch_inspect@male_c@idle_a"
    local anim = "idle_c"
    
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 100 do
        timeout = timeout + 1
        Citizen.Wait(100)
    end
    
    -- Start the animation first
    if HasAnimDictLoaded(dict) then
        TaskPlayAnim(playerPed, dict, anim, 1.0, 8.0, -1, 1, 0, false, false, false)
    end
    
    -- Show progress bar for placing dynamite
    local progressbar = exports['vorp_progressbar']:initiate()
    progressbar.start("Placing dynamite...", 10000, function()
        -- Stop the animation
        ClearPedTasks(playerPed)
        
        -- Notify about explosion
        TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].dynamiteBlowMessage, 10000)
        
        -- Wait then show the explosion timer progress bar
        Citizen.Wait(1000)
        
        -- Show second progress bar for explosion countdown
        local explosionBar = exports['vorp_progressbar']:initiate()
        explosionBar.start("Dynamite will explode soon...", 5000, function()
            -- Create explosion at bank
            Citizen.InvokeNative(0x7D6F58F69DA92530, bankCoords.x, bankCoords.y, bankCoords.z, 25, 5.0, true, false, true)
            ShakeGameplayCam("GAMEPLAY_EXPLOSION_SHAKE", 1.0)
            
            -- Update state
            dynamiteSet = true
            
            -- Remove dynamite from inventory on server
            TriggerServerEvent("sb_robbery:removeDynamite")
            
            -- Notify player
            TriggerEvent("vorp:TipRight", "The vault is now open! Search for valuables!", 5000)
        end)
    end)
end

-- Search vault function
function SearchVault()
    local playerPed = PlayerPedId()
    
    -- Start search animation
    local dict = "script_re@gold_panner@gold_success"
    local anim = "SEARCH02"
    
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 100 do
        timeout = timeout + 1
        Citizen.Wait(100)
    end
    
    if not HasAnimDictLoaded(dict) then
        -- Fallback animation
        dict = "amb_misc@world_human_inspect@male_a@idle_b"
        anim = "idle_d"
        RequestAnimDict(dict)
        timeout = 0
        while not HasAnimDictLoaded(dict) and timeout < 100 do
            timeout = timeout + 1
            Citizen.Wait(100)
        end
    end
    
    -- Start the animation
    if HasAnimDictLoaded(dict) then
        TaskPlayAnim(playerPed, dict, anim, 1.0, 8.0, -1, 1, 0, false, false, false)
    end
    
    -- Show searching vault progress bar
    local progressbar = exports['vorp_progressbar']:initiate()
    progressbar.start(Config.Languages[Config.selectedLanguage].robberySuccess, 10000, function()
        -- Stop the animation
        ClearPedTasks(playerPed)
        
        -- Give rewards to player
        TriggerServerEvent("sb_robbery:giveRewards", selectedBank)
        
        -- Mark robbery as completed
        robberyCompleted = true
        activeRobbery = false
        
        -- Notify player
        TriggerEvent("vorp:TipRight", "You've successfully robbed the bank!", 5000)
        
        -- Reset the robbery state immediately (but keep cooldown server-side)
        selectedBank = nil
        dynamiteSet = false
        robberyCompleted = false
    end)
end

-- Monitor the store robbery process
function MonitorStoreRobbery()
    Citizen.CreateThread(function()
        while storeRobberyActive do
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local inRange = false
            
            -- Find the selected store coordinates
            local storeCoords = nil
            for _, store in ipairs(Config.Shops) do
                if store.name == selectedStore then
                    storeCoords = store.coords
                    break
                end
            end
            
            if storeCoords then
                local distance = #(coords - storeCoords)
                
                if distance < Config.ZoneSize and not storeRobberyCompleted then
                    inRange = true
                    local promptText = CreateVarString(10, 'LITERAL_STRING', Config.Languages[Config.selectedLanguage].storeRobbery)
                    PromptSetActiveGroupThisFrame(5, promptText)
                    
                    if Citizen.InvokeNative(0xC92AC953F0A982AE, collectCashPrompt) then
                        -- Execute store robbery
                        ExecuteStoreRobbery(storeCoords)
                    end
                end
            end
            
            if not inRange then
                Citizen.Wait(500)
            else
                Citizen.Wait(0)
            end
        end
    end)
end

-- Execute store robbery function
function ExecuteStoreRobbery(storeCoords)
    local playerPed = PlayerPedId()
    
    -- Prevent multiple executions
    if storeRobberyCompleted then 
        print("Store robbery already completed")
        return 
    end
    
    -- Mark as in progress to prevent duplicate executions
    storeRobberyCompleted = true
    
    -- Start threatening animation
    local dict = "amb_misc@world_human_threaten@male_a@idle_a"
    local anim = "idle_a"
    
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 100 do
        timeout = timeout + 1
        Citizen.Wait(10) -- Reduced wait time
    end
    
    -- If animation loaded, play it
    if HasAnimDictLoaded(dict) then
        TaskPlayAnim(playerPed, dict, anim, 1.0, 8.0, -1, 1, 0, false, false, false)
    end
    
    -- Debug message
    print("Starting store robbery at " .. selectedStore)
    
    -- Show progress bar for threatening store clerk with REDUCED TIME
    local progressbar = exports['vorp_progressbar']:initiate()
    progressbar.start(Config.Languages[Config.selectedLanguage].storeRobberyStarted, 5000, function() -- Reduced from 10000 to 5000
        -- Stop the animation
        ClearPedTasks(playerPed)
        
        -- Notify police about robbery
        TriggerServerEvent("sb_robbery:notifyPoliceStore", selectedStore)
        
        -- Search animation
        local searchDict = "script_re@gold_panner@gold_success"
        local searchAnim = "SEARCH02"
        
        RequestAnimDict(searchDict)
        timeout = 0
        while not HasAnimDictLoaded(searchDict) and timeout < 100 do
            timeout = timeout + 1
            Citizen.Wait(10) -- Reduced wait time
        end
        
        -- Play search animation
        if HasAnimDictLoaded(searchDict) then
            TaskPlayAnim(playerPed, searchDict, searchAnim, 1.0, 8.0, -1, 1, 0, false, false, false)
        end
        
        -- Show progress bar for collecting money
        local collectBar = exports['vorp_progressbar']:initiate()
        collectBar.start("Grabbing the money...", 3000, function() -- Reduced from 5000 to 3000
            -- Stop animation
            ClearPedTasks(playerPed)
            
            -- Give cash reward to player
            TriggerServerEvent("sb_robbery:giveStoreRewards")
            
            -- Mark robbery as completed
            storeRobberyActive = false
            
            -- Notify player
            TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].storeRobberySuccess, 5000)
            
            -- Reset the store robbery state
            Citizen.SetTimeout(2000, function()
                selectedStore = nil
                storeRobberyCompleted = false
            end)
        end)
    end)
end

-- Police notification event
RegisterNetEvent('sb_robbery:notifyPoliceClient')
AddEventHandler('sb_robbery:notifyPoliceClient', function(bankName)
    if PlayerJob and TableContains(Config.PoliceJobs, PlayerJob) then
        TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].notifyPolice, 8000)
        TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].notifyPolice2, 5000)
        
        -- Mark the bank on map for police
        for _, bank in ipairs(Config.Banks) do
            if bank.name == bankName then
                local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, bank.coords.x, bank.coords.y, bank.coords.z)
                SetBlipSprite(blip, -1103135225, 1)
                SetBlipScale(blip, 0.2)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Bank Robbery")
                
                -- Remove blip after certain time
                Citizen.SetTimeout(120000, function()
                    RemoveBlip(blip)
                end)
            end
        end
    end
end)

-- Police notification event for store robberies
RegisterNetEvent('sb_robbery:notifyPoliceStoreClient')
AddEventHandler('sb_robbery:notifyPoliceStoreClient', function(storeName)
    if PlayerJob and TableContains(Config.PoliceJobs, PlayerJob) then
        TriggerEvent("vorp:TipRight", "You received a telegram about a store robbery! Hurry up!", 8000)
        TriggerEvent("vorp:TipRight", Config.Languages[Config.selectedLanguage].notifyPolice2, 5000)
        
        -- Mark the store on map for police
        for _, store in ipairs(Config.Shops) do
            if store.name == storeName then
                local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, store.coords.x, store.coords.y, store.coords.z)
                SetBlipSprite(blip, 1321928545, 1) -- Different sprite for store robberies
                SetBlipScale(blip, 0.2)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Store Robbery")
                
                -- Remove blip after certain time
                Citizen.SetTimeout(120000, function()
                    RemoveBlip(blip)
                end)
            end
        end
    end
end)

-- Add event for police notification about store robbery planning
RegisterNetEvent('sb_robbery:notifyPolicePlanning')
AddEventHandler('sb_robbery:notifyPolicePlanning', function(coords)
    if PlayerJob and TableContains(Config.PoliceJobs, PlayerJob) then
        TriggerEvent("vorp:TipRight", "Suspicious activity reported near a store!", 8000)
        
        -- Mark the location on map for police
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 1321928545, 1)
        SetBlipScale(blip, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Suspicious Activity")
        
        -- Remove blip after certain time
        Citizen.SetTimeout(60000, function()
            RemoveBlip(blip)
        end)
    end
end)

-- Helper function to check if a table contains a value
function TableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end 