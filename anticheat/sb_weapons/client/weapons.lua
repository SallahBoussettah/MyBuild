-- Weapons and Health Protection System
-- Prevents weapon cheats and health hacks

-- Debug utility function
local function DebugLog(message)
    print("^3[DEBUG:sb_weapons]^7 " .. message)
end

-- Function to check if a player has a blacklisted weapon and remove it
local function CheckBlacklistedWeapons()
    if not Config.Weapons.active then return end
    
    local ped = PlayerPedId()
    
    -- Iterate through all blacklisted weapons
    for weaponHash, _ in pairs(Config.Weapons.blacklist) do
        -- Native call to remove weapon from player (0xF77DE93D is the flag for removing it silently)
        Citizen.InvokeNative(0x4899CB088EDF59B8, ped, weaponHash, true, 0xF77DE93D)
        
        -- Check if player has the weapon after attempted removal
        if HasPedGotWeapon(ped, weaponHash, false) then
            -- Weapon removal failed, this might indicate cheating - notify server
            TriggerServerEvent("sb_weapons:blacklistedWeaponDetected", weaponHash)
        end
    end
end

-- Function to prevent infinite ammo cheats
local function PreventInfiniteAmmo()
    if not Config.InfiniteAmmo.active then return end
    
    local ped = PlayerPedId()
    -- Native call to disable infinite ammo (false parameter)
    Citizen.InvokeNative(0xFBAA1E06B6BCA741, ped, false)
end

-- Function to check for health hacks
local function CheckPlayerHealth()
    if not Config.PlayerStatus.active then return end
    
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    
    -- Check if health exceeds the configured maximum
    if health > Config.PlayerStatus.health then
        TriggerServerEvent("sb_weapons:healthHackDetected", health)
    end
end

-- Event handler for client-side notification
RegisterNetEvent("sb_weapons:notify")
AddEventHandler("sb_weapons:notify", function(message)
    -- Display notification using VORP notification system
    TriggerEvent("vorp:TipBottom", message, 3000)
end)

-- Main thread for weapon blacklist checking
Citizen.CreateThread(function()
    -- Wait for game to fully load
    Citizen.Wait(5000)
    
    while true do
        -- Check for blacklisted weapons
        CheckBlacklistedWeapons()
        
        -- Wait for configured interval
        Citizen.Wait(Config.Weapons.checkInterval)
    end
end)

-- Main thread for infinite ammo prevention
Citizen.CreateThread(function()
    -- Wait for game to fully load
    Citizen.Wait(5000)
    
    while true do
        -- Prevent infinite ammo
        PreventInfiniteAmmo()
        
        -- Wait for configured interval
        Citizen.Wait(Config.InfiniteAmmo.checkInterval)
    end
end)

-- Main thread for health hack detection
Citizen.CreateThread(function()
    -- Wait for game to fully load
    Citizen.Wait(5000)
    
    while true do
        -- Check for health hacks
        CheckPlayerHealth()
        
        -- Wait for configured interval
        Citizen.Wait(Config.PlayerStatus.checkInterval)
    end
end)

-- Debug command to check current player health (admin only)
RegisterCommand("checkhealth", function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    
    TriggerEvent("vorp:TipBottom", "Current health: " .. health, 5000)
    print("^2[sb_weapons]^7 Current health: " .. health)
end, false) 