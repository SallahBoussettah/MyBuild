--[[
    sb_guntricks
    Gun Trick Script for VORP Framework
    
    Author: Salah
    Modified to require bounty hunter license
]]

-- Import VORP Core for Notifications (if needed)
local VORPcore = {}
local VORPinventory = {}
local hasLicense = false
local forceCheckCooldown = 0 -- Prevent too many server calls
local registeredCallbacks = {} -- Track registered callback handlers

-- Get VORP core for notifications
if Config.UseVORPNotify then
    TriggerEvent("getCore", function(core)
        VORPcore = core
    end)
end

-- Function to check if player has bounty hunter license
function CheckBountyLicense()
    TriggerServerEvent("sb_guntricks:checkLicense")
end

-- Function to properly remove event handlers (avoiding removal errors)
function SafeRemoveEventHandler(eventName, handlerId)
    if registeredCallbacks[eventName] and registeredCallbacks[eventName][handlerId] then
        RemoveEventHandler(registeredCallbacks[eventName][handlerId])
        registeredCallbacks[eventName][handlerId] = nil
    end
end

-- Function to force a license check with server
function ForceCheckLicense(callback)
    -- Use a cooldown to prevent spamming the server
    local currentTime = GetGameTimer()
    if currentTime - forceCheckCooldown < 2000 then
        if callback then callback(hasLicense) end
        return -- Still on cooldown
    end
    
    forceCheckCooldown = currentTime
    
    -- If there's a callback, create an event handler
    if callback then
        -- Create a unique ID for this callback
        local callbackId = "cb_" .. currentTime
        local eventName = "sb_guntricks:licenseResponse"
        
        -- Initialize the event handler table if needed
        if not registeredCallbacks[eventName] then
            registeredCallbacks[eventName] = {}
        end
        
        -- Register the event handler only once
        if not registeredCallbacks[eventName].initialized then
            registeredCallbacks[eventName].initialized = true
            
            RegisterNetEvent(eventName)
            AddEventHandler(eventName, function(responseId, hasItem)
                -- Only process if we have a handler for this response ID
                if registeredCallbacks[eventName] and registeredCallbacks[eventName][responseId] then
                    -- Update license status
                    hasLicense = hasItem
                    
                    -- Call the associated callback
                    if type(registeredCallbacks[eventName][responseId].callback) == "function" then
                        registeredCallbacks[eventName][responseId].callback(hasItem)
                    end
                    
                    -- Clean up this specific callback but keep the event handler
                    registeredCallbacks[eventName][responseId] = nil
                end
            end)
        end
        
        -- Store the callback in our table
        registeredCallbacks[eventName][callbackId] = {
            callback = callback,
            timestamp = currentTime
        }
        
        -- Set a timeout to clean up if server doesn't respond
        Citizen.SetTimeout(3000, function()
            if registeredCallbacks[eventName] and registeredCallbacks[eventName][callbackId] then
                -- Call callback with current value as fallback
                if type(registeredCallbacks[eventName][callbackId].callback) == "function" then
                    registeredCallbacks[eventName][callbackId].callback(hasLicense)
                end
                
                -- Remove the callback entry
                registeredCallbacks[eventName][callbackId] = nil
            end
        end)
        
        -- Send request to server with our callback ID
        TriggerServerEvent("sb_guntricks:forceCheck", callbackId)
    else
        -- Simple check without callback
        TriggerServerEvent("sb_guntricks:forceCheck", nil)
    end
end

-- Event to receive license check result
RegisterNetEvent("sb_guntricks:licenseResult")
AddEventHandler("sb_guntricks:licenseResult", function(hasItem)
    local previousStatus = hasLicense
    hasLicense = hasItem
    
    -- Only print and notify if the status has changed
    if previousStatus ~= hasLicense then
        if hasLicense then
            -- Player received license
            ShowNotification("You now have access to gun tricks. Use /guntrick or /gt to toggle.")
        else
            -- Player lost license
            if tricking then
                tricking = false
                
                -- Always clear animations when license is lost
                local ped = PlayerPedId()
                ClearPedTasks(ped)
                
                ShowNotification("Gun tricks disabled - license lost.")
            elseif previousStatus then
                -- Only notify if they had it before and lost it
                ShowNotification("You no longer have access to gun tricks.")
            end
        end
    end
end)

-- Local variables for prompts and trick management
local TrickDoPrompt
local TrickEndPrompt
local TrickNext
local TrickPrev
local TrickPrompts = GetRandomIntInRange(0, 0xffffff)

local tricking = false
local index = 1
local playingGunTrick = nil

-- Register commands for toggling gun tricks
Citizen.CreateThread(function()
    -- Check for license on script start
    Citizen.Wait(2000) -- Wait 2 seconds after script starts
    CheckBountyLicense()
    
    -- Command: /guntrick or /gt
    RegisterCommand('guntrick', function()
        -- Force a license check before proceeding to ensure we have current status
        ForceCheckLicense(function(hasItem)
            if hasItem then
                ToggleGunTricks()
            else
                ShowNotification("You need a Bounty Hunter License to perform gun tricks.")
            end
        end)
    end, false)
    
    -- Shorter alias
    RegisterCommand('gt', function()
        -- Force a license check before proceeding to ensure we have current status
        ForceCheckLicense(function(hasItem)
            if hasItem then
                ToggleGunTricks()
            else
                ShowNotification("You need a Bounty Hunter License to perform gun tricks.")
            end
        end)
    end, false)
    
    -- Set up a periodic check every 30 seconds (just to be safe)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(30000) -- 30 seconds
            CheckBountyLicense()
        end
    end)
    
    -- Clean up old callbacks periodically
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10000) -- Every 10 seconds
            
            -- Get current time for comparing
            local currentTime = GetGameTimer()
            
            -- Check each event type
            for eventName, callbacks in pairs(registeredCallbacks) do
                -- Skip the initialized flag
                if eventName ~= "initialized" then
                    -- Check each callback in this event
                    for callbackId, callbackData in pairs(callbacks) do
                        -- Skip the initialized flag
                        if callbackId ~= "initialized" then
                            -- If callback is older than 5 seconds, remove it
                            if callbackData.timestamp and (currentTime - callbackData.timestamp) > 5000 then
                                registeredCallbacks[eventName][callbackId] = nil
                            end
                        end
                    end
                end
            end
        end
    end)
end)

-- Setup Trick Prompts
function SetupTrickPrompt()
    Citizen.CreateThread(function()
        local str = 'Do Trick'
        TrickDoPrompt = PromptRegisterBegin()
        PromptSetControlAction(TrickDoPrompt, Config.Prompts.Do)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(TrickDoPrompt, str)
        PromptSetEnabled(TrickDoPrompt, 1)
        PromptSetVisible(TrickDoPrompt, 1)
        PromptSetStandardMode(TrickDoPrompt, 1)
        PromptSetGroup(TrickDoPrompt, TrickPrompts)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, TrickDoPrompt, true)
        PromptRegisterEnd(TrickDoPrompt)

        local str2 = 'Finish'
        TrickEndPrompt = PromptRegisterBegin()
        PromptSetControlAction(TrickEndPrompt, Config.Prompts.End)
        str2 = CreateVarString(10, 'LITERAL_STRING', str2)
        PromptSetText(TrickEndPrompt, str2)
        PromptSetEnabled(TrickEndPrompt, 1)
        PromptSetVisible(TrickEndPrompt, 1)
        PromptSetStandardMode(TrickEndPrompt, 1)
        PromptSetGroup(TrickEndPrompt, TrickPrompts)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, TrickEndPrompt, true)
        PromptRegisterEnd(TrickEndPrompt)

        local str3 = 'Next'
        TrickNext = PromptRegisterBegin()
        PromptSetControlAction(TrickNext, Config.Prompts.Next)
        str3 = CreateVarString(10, 'LITERAL_STRING', str3)
        PromptSetText(TrickNext, str3)
        PromptSetEnabled(TrickNext, 1)
        PromptSetVisible(TrickNext, 1)
        PromptSetStandardMode(TrickNext, 1)
        PromptSetGroup(TrickNext, TrickPrompts)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, TrickNext, true)
        PromptRegisterEnd(TrickNext)

        local str4 = 'Prev'
        TrickPrev = PromptRegisterBegin()
        PromptSetControlAction(TrickPrev, Config.Prompts.Prev)
        str4 = CreateVarString(10, 'LITERAL_STRING', str4)
        PromptSetText(TrickPrev, str4)
        PromptSetEnabled(TrickPrev, 1)
        PromptSetVisible(TrickPrev, 1)
        PromptSetStandardMode(TrickPrev, 1)
        PromptSetGroup(TrickPrev, TrickPrompts)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C, TrickPrev, true)
        PromptRegisterEnd(TrickPrev)
    end)
end

-- Function to toggle gun tricks mode
function ToggleGunTricks()
    -- Perform one more final check before toggling
    ForceCheckLicense(function(hasItem)
        if not hasItem then
            ShowNotification("You need a Bounty Hunter License to perform gun tricks.")
            tricking = false
            
            -- Always clear animations when toggling off
            local ped = PlayerPedId()
            ClearPedTasks(ped)
            
            return
        end
        
        -- If we have the license, proceed with toggle
        tricking = not tricking
        
        if tricking then
            return
        else
            -- Always clear animations when toggling off
            local ped = PlayerPedId()
            ClearPedTasks(ped)
        end
    end)
end

-- Function to smoothly exit the gun tricks menu without interrupting animation
function ExitGunTricksMenu()
    if tricking then
        tricking = false
        
        -- Only clear animations if configured NOT to allow them to finish
        if not Config.AllowAnimationsToFinish then
            local ped = PlayerPedId()
            ClearPedTasks(ped)
        end
    end
end

-- Register the event handler for the keymapping
RegisterNetEvent("sb_guntricks:toggle")
AddEventHandler("sb_guntricks:toggle", function()
    -- Force a license check before proceeding to ensure we have current status
    ForceCheckLicense(function(hasItem)
        if hasItem then
            ToggleGunTricks()
        else
            ShowNotification("You need a Bounty Hunter License to perform gun tricks.")
        end
    end)
end)

-- Display notification based on configuration
function ShowNotification(text)
    if Config.UseVORPNotify and VORPcore then
        VORPcore.NotifyRightTip(text, 3000)
    else
        -- Native notification
        local str = CreateVarString(10, 'LITERAL_STRING', text)
        DisplayTip(str, 3000)
    end
end

-- Thread to detect aiming and shooting to close the tricks menu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if tricking then
            local ped = PlayerPedId()
            
            -- Also check license status periodically when gun tricks are active
            if GetGameTimer() % 5000 < 20 then -- Check roughly every 5 seconds
                CheckBountyLicense()
            end
            
            -- Check if player is aiming (two different aim detection methods for compatibility)
            if IsPlayerFreeAiming(PlayerId()) or Citizen.InvokeNative(0x916B8E075ABC8B4E, ped, true) then
                ExitGunTricksMenu()
            end
            
            -- Check if player is shooting
            if IsPedShooting(ped) then
                ExitGunTricksMenu()
            end
        else
            Citizen.Wait(500) -- Wait longer if not in trick mode to save resources
        end
    end
end)

-- Main thread for trick controls
Citizen.CreateThread(function()
    SetupTrickPrompt()
    while true do
        Citizen.Wait(4)
        
        if tricking and not IsEntityDead(PlayerPedId()) then
            -- Check if player still has license
            if not hasLicense then
                tricking = false
                ShowNotification("Gun tricks disabled - license required.")
                
                -- Always clear animations when license is lost
                local ped = PlayerPedId()
                ClearPedTasks(ped)
                
                Citizen.Wait(500)
                goto continue
            end
            
            local label = CreateVarString(10, 'LITERAL_STRING', "Trick: " .. Config.Tricks[index][2])
            PromptSetActiveGroupThisFrame(TrickPrompts, label)
            
            if Citizen.InvokeNative(0xC92AC953F0A982AE, TrickDoPrompt) then
                if index < 3 then
                    StartTrick(Config.Tricks[index][1])
                else
                    TrickVariation(index)
                end
            end
            
            if Citizen.InvokeNative(0xC92AC953F0A982AE, TrickEndPrompt) then
                -- Exit menu AND stop the animation when TAB is pressed
                tricking = false
                
                -- Always clear animations when TAB is pressed, regardless of config
                local ped = PlayerPedId()
                ClearPedTasks(ped)
            end
            
            if Citizen.InvokeNative(0xC92AC953F0A982AE, TrickNext) then
                index = index + 1
                if index > #Config.Tricks then
                    index = 1
                end
            end
            
            if Citizen.InvokeNative(0xC92AC953F0A982AE, TrickPrev) then
                index = index - 1
                if index == 0 then
                    index = #Config.Tricks
                end
            end
        end
        
        ::continue::
    end
end)

-- Function to check if weapon can be twirled
function CanTwirl(hash)
    if (IsWeaponRevolver(hash) or IsWeaponPistol(hash)) then
        return true
    else
        ShowNotification("You need a pistol or revolver to perform gun tricks")
        return false
    end
end

-- Helper functions for weapon types
function IsWeaponRevolver(hash)
    return Citizen.InvokeNative(0xC212F1D05A8232BB, hash)
end

function IsWeaponPistol(hash)
    return Citizen.InvokeNative(0xDDC64F5E31EEDAB6, hash)
end

-- Start a gun trick
function StartTrick(trickhash)
    local hasw, playerw = GetCurrentPedWeapon(PlayerPedId(), 1)
    if CanTwirl(playerw) then
        playingGunTrick = trickhash
        Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 4, 1, trickhash, 1, 1, 0, 0)
    end
end

-- Perform a trick variation
function TrickVariation(ind)
    local ped = PlayerPedId()
    local hasw, playerw = GetCurrentPedWeapon(ped, 1)
    if CanTwirl(playerw) then
        local emote = `KIT_EMOTE_TWIRL_GUN`
        if playingGunTrick ~= nil then
            emote = playingGunTrick
        end
        -- Set current emote
        Citizen.InvokeNative(0xCBCFFF805F1B4596, ped, emote)
        
        -- Play animation with variation
        Citizen.InvokeNative(0xB31A277C1AC7B7FF, ped, 4, 1, Citizen.InvokeNative(0x2C4FEC3D0EFA9FC0, ped), true, false, false, false, false)
        Citizen.InvokeNative(0x01F661BB9C71B465, ped, 4, N_0xf4601c1203b1a78d(emote, ind))
        Citizen.InvokeNative(0x408CF580C5E96D49, ped, 4)
    end
end

-- Resource cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
end)