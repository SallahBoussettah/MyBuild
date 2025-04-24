--[[ 
    SB_SAFEZONE Script
    Original author: Salah
    
    This script creates safe zones where players cannot use weapons or fight
    Zone locations and settings can be configured in config.lua
]]

-- Local Variables
local ActiveZone = nil
local PlayerCoords = nil
local InSafeZone = false
local ZoneName = nil
local VORPcore = nil

-- Initialize VORP Core when resource starts
Citizen.CreateThread(function()
    TriggerEvent("getCore", function(core)
        VORPcore = core
    end)
    
    -- Wait for VORP Core to initialize
    while VORPcore == nil do
        Citizen.Wait(100)
    end
end)

-- Show notification with appropriate system
function ShowNotification(message, type)
    if not Config.UseCustomUI then
        -- Use VORP notification system
        if type == "top" then
            TriggerEvent("vorp:NotifyTop", message, Config.NotificationTime)
        else
            VORPcore.NotifyRightTip(message, Config.NotificationTime)
        end
    else
        -- Custom UI notification is handled by the UI system
    end
end

-- Main thread that checks if player is in any safe zone
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        PlayerCoords = GetEntityCoords(ped)
        local isInAnyZone = false
        
        -- Loop through all safe zones
        for zoneName, zones in pairs(Config.SafeZones) do
            for _, zone in pairs(zones) do
                local distance = #(PlayerCoords - vector3(zone.x, zone.y, zone.z))
                
                -- Check if player is inside this zone
                if distance < zone.radius + 1.5 then
                    isInAnyZone = true
                    InSafeZone = true
                    ActiveZone = zone
                    ZoneName = zoneName
                    
                    -- Handle player actions in safe zone
                    HandleSafeZone(ped, zone, zoneName)
                    
                    -- Break out of the loop since we found a zone player is in
                    break
                end
            end
            
            if isInAnyZone then
                break
            end
        end
        
        -- If not in any zone but was previously in a zone
        if not isInAnyZone and InSafeZone then
            InSafeZone = false
            ActiveZone = nil
            ZoneName = nil
            
            -- Hide UI notification when leaving zone
            if Config.UseCustomUI then
                HideUiZone()
            end
        end
        
        -- Shorter wait time when in a zone for responsive controls
        if InSafeZone then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)

-- Handle player actions while in safe zone
function HandleSafeZone(ped, zone, zoneName)
    -- Set invincibility if enabled in config
    SetEntityInvincible(ped, Config.GodModeInSafeZone)
    
    -- Cancel combat actions if player is fighting
    if Citizen.InvokeNative(0x2311F15D971AA680, ped) > -1 or  -- Melee
       Citizen.InvokeNative(0x0E99E3BF11BB6367, ped) or      -- Grappling
       Citizen.InvokeNative(0x3BDFCF25B58B0415, ped) then    -- Aiming
        
        -- Cancel the action
        Citizen.InvokeNative(0xAAA34F8A7CB32098, ped, false, false)
        
        -- Show notification
        if not Config.UseCustomUI then
            ShowNotification(Config.Language.NoFighting, "right")
        end
    end
    
    -- Disable combat controls
    DisableCombatControls()
    
    -- Show zone UI if using custom UI
    if Config.UseCustomUI and ActiveZone ~= nil then
        ShowUiZone()
    elseif not Config.UseCustomUI and not WasNotificationShown then
        -- Show VORP notification when entering zone
        ShowNotification(Config.Language.EnteringSafeZone .. ": " .. zoneName, "top")
        WasNotificationShown = true
        
        -- Reset notification flag after delay
        Citizen.SetTimeout(5000, function()
            WasNotificationShown = false
        end)
    end
end

-- Disable all combat-related controls
function DisableCombatControls()
    -- Melee attack controls
    DisableControlAction(0, 0x60c81cde, true)  -- INPUT_ATTACK
    DisableControlAction(0, 0xc904196d, true)  -- INPUT_MELEE_ATTACK
    
    -- Weapon firing controls
    DisableControlAction(0, 0xD0C1FEFF, true)  -- INPUT_WEAPON_FIRE
    DisableControlAction(0, 0xADEAF48C, true)  -- INPUT_AIM
    DisableControlAction(0, 0x018C47CF, true)  -- INPUT_SPECIAL_ABILITY
    
    -- Weapon switching/draw controls
    DisableControlAction(0, 0x91C9A817, true)  -- INPUT_WEAPON_WHEEL
    DisableControlAction(0, 0xBE1F4699, true)  -- INPUT_WEAPON_WHEEL_NEXT
    DisableControlAction(0, 0x67ED272E, true)  -- INPUT_WEAPON_WHEEL_PREV
    
    -- Additional combat controls
    DisableControlAction(0, 0x78ed2132, true)  -- INPUT_MELEE_BLOCK
    DisableControlAction(0, 0x162afeb8, true)  -- INPUT_RELOAD
    DisableControlAction(0, 0x0283c582, true)  -- INPUT_WEAPON_SPECIAL
    DisableControlAction(0, 0x07ce1e61, true)  -- INPUT_WEAPON_SPECIAL_TWO
    DisableControlAction(0, 0xb2f377e8, true)  -- INPUT_WEAPON_SPECIAL_ABILITY
end

-- Thread for debug visuals and UI management
Citizen.CreateThread(function()
    if Config.Debug then
        -- Debug mode: Draw zone boundaries
        while true do
            if ActiveZone ~= nil then
                -- Draw a cylinder to visualize the zone boundary
                Citizen.InvokeNative(0x2A32FAA57B937173, -1795314153, 
                    ActiveZone.x, ActiveZone.y, ActiveZone.z - 1.1, 
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                    ActiveZone.radius * 2, ActiveZone.radius * 2, 20.0, 
                    100, 255, 100, 150, false, false, 0, false, false)
            end
            Citizen.Wait(0)
        end
    elseif Config.UseCustomUI then
        -- Normal mode: Manage custom UI
        while true do
            Citizen.Wait(250)
            
            -- Update UI visibility based on zone status
            if InSafeZone and ActiveZone ~= nil and ZoneName ~= nil then
                ShowUiZone()
            elseif not InSafeZone and ActiveZone == nil then
                HideUiZone()
            end
        end
    end
end)

-- Show custom UI for safe zone
function ShowUiZone() 
    SendNUIMessage({
        action = 'show',
        zoneName = ZoneName,
        message = Config.Language.NoFighting,
        prefix = Config.Language.ZonePrefix
    })
end

-- Hide custom UI when leaving safe zone
function HideUiZone()
    SendNUIMessage({
        action = 'hide'
    })
end

-- Legacy Draw Text function (used in some configurations)
function DrawText(x, y, text)
    SetTextScale(0.35, 0.35)
    SetTextDropshadow(5, 0, 0, 0, 255)
    SetTextFontForCurrentCommand(1)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str, x, y)
    
    -- Add background
    local factor = (string.len(text)) / 225
    DrawSprite("generic_textures", "hud_menu_4a", x, y + 0.018, 0.0075 + factor, 0.035, 0.1, 0, 0, 0, 200, 0)
end 