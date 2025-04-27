--[[
    sb_guntricks
    Gun Trick Script for VORP Framework
    
    Author: Salah
]]

-- Import VORP Core for Notifications (if needed)
local VORPcore = {}

if Config.UseVORPNotify then
    TriggerEvent("getCore", function(core)
        VORPcore = core
    end)
end

-- Debug print to confirm script is running
print("SB Gun Tricks: Script started")

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
    -- Command: /guntrick or /gt
    RegisterCommand('guntrick', function()
        ToggleGunTricks()
    end, false)
    
    -- Shorter alias
    RegisterCommand('gt', function()
        ToggleGunTricks()
    end, false)
    
    -- Show welcome message on script start
    Citizen.Wait(2000) -- Wait 2 seconds after script starts
    ShowNotification("Gun Tricks loaded. Use /guntrick or /gt to toggle tricks.")
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
    tricking = not tricking
    print("SB Gun Tricks: Toggled, tricking = " .. tostring(tricking))
    
    if tricking then
        ShowNotification("Gun tricks enabled")
    else
        ShowNotification("Gun tricks disabled")
        -- No need to clear animations when manually exiting trick mode
    end
end

-- Function to smoothly exit the gun tricks menu without interrupting animation
function ExitGunTricksMenu()
    if tricking then
        tricking = false
        print("SB Gun Tricks: Menu closed due to aim or fire")
        -- No notification when menu is closed due to aiming/shooting
    end
end

-- Register the event handler for the keymapping
RegisterNetEvent("sb_guntricks:toggle")
AddEventHandler("sb_guntricks:toggle", function()
    ToggleGunTricks()
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
                tricking = false
                -- Don't forcibly clear animations when using the end prompt
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
        Citizen.InvokeNative(0xCBCFFF805F1B4596, ped, emote)
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
    tricking = false
    -- Don't clear animations on resource stop
end)