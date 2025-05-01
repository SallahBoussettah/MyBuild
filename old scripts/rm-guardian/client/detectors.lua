-- Client-side detection system for common cheats and exploits

-- Check for weapon modifications
Citizen.CreateThread(function()
    if Config.AmmoValidator.active then
        -- Wait for player to be fully loaded before starting ammo checks
        Wait(30000) -- Initial delay to allow for loading

        while true do
            Wait(5000)
            
            local ped = PlayerPedId()
            if ped and DoesEntityExist(ped) then
                -- Skip check if loading screen is active
                if IsLoadingScreenActive() or IsPauseMenuActive() then
                    goto continue
                end

                -- Check for infinite ammo hacks
                local weapons = {
                    0x64356159, -- Revolver Schofield
                    0x169F59F7, -- Pistol Mauser
                    0x5B78B8DD, -- Revolver Double Action
                    0x22D8FE39, -- Pistol Volcanic
                    0x2BE6766B, -- Pistol Semi-Auto
                    0x657065D6, -- Revolver Cattleman
                    0x8580C63E, -- Rifle Springfield
                    0x95B24592, -- Rifle Bolt Action
                    0xDDF7BC1E, -- Repeater Carbine
                    0x63F46DE6, -- Repeater Winchester
                    0xA84762EC, -- Shotgun Double Barrel
                    0x20D13FF  -- Shotgun Pump
                }
                
                for _, weaponHash in ipairs(weapons) do
                    if HasPedGotWeapon(ped, weaponHash, false) then
                        local maxAmmo = GetMaxAmmoInClip(ped, weaponHash, true)
                        local currentAmmo = GetAmmoInPedWeapon(ped, weaponHash)
                        
                        -- Check for suspiciously high ammo count
                        if currentAmmo > maxAmmo * 10 then
                            TriggerServerEvent("rmg:removePlayer", "Ammunition modification detected")
                            return
                        end
                    end
                end
            end
            
            ::continue::
        end
    end
end)

-- Check for teleport hacking
local lastPosition = vector3(0, 0, 0)
local teleportChecks = 0
local teleportCheckEnabled = false

-- Add a delay before enabling teleport checks
Citizen.CreateThread(function()
    -- Wait for player to be loaded
    Wait(60000) -- 1 minute grace period after startup
    teleportCheckEnabled = true
    print("[RedM Guardian] Teleport monitoring enabled")
end)

-- Handle character selection events
RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function(charid)
    -- Reset position tracking
    lastPosition = vector3(0, 0, 0)
    teleportChecks = 0
    
    -- Disable checks temporarily
    teleportCheckEnabled = false
    
    -- Re-enable after delay
    Citizen.SetTimeout(60000, function()
        teleportCheckEnabled = true
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        
        -- Only check if explicitly enabled and after initial grace period
        if not teleportCheckEnabled then
            goto continue
        end
        
        local ped = PlayerPedId()
        if ped and not IsEntityDead(ped) and DoesEntityExist(ped) then
            -- Skip if still loading
            if IsLoadingScreenActive() or IsPauseMenuActive() then
                lastPosition = vector3(0, 0, 0) -- Reset position during loading screens
                goto continue
            end
            
            local currentPos = GetEntityCoords(ped)
            
            -- Skip first position check
            if lastPosition == vector3(0, 0, 0) then
                lastPosition = currentPos
                goto continue
            end
            
            if not IsEntityInWater(ped) and not IsPedInAnyVehicle(ped, true) and not IsPedOnMount(ped) then
                local distance = #(lastPosition - currentPos)
                
                -- Use more forgiving thresholds
                if distance > 150.0 and teleportChecks > 10 then
                    TriggerServerEvent("rmg:suspiciousTeleport", json.encode({
                        from = {x = lastPosition.x, y = lastPosition.y, z = lastPosition.z},
                        to = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
                        distance = distance
                    }))
                end
            end
            
            lastPosition = currentPos
        else
            -- Reset if ped doesn't exist or is dead
            lastPosition = vector3(0, 0, 0)
        end
        
        teleportChecks = teleportChecks + 1
        
        ::continue::
    end
end)

-- Temporarily disable teleport checks (for admin teleports, etc.)
RegisterNetEvent("rmg:disableSpeedCheck")
AddEventHandler("rmg:disableSpeedCheck", function(duration)
    teleportCheckEnabled = false
    lastPosition = vector3(0, 0, 0)
    
    Citizen.SetTimeout(duration or 5000, function()
        teleportCheckEnabled = true
    end)
end) 