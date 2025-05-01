-- Watch for unauthorized resource manipulations and injections
Citizen.CreateThread(function()
    if Config.ResourceProtection.active then
        -- Stop the current resource if player tries to stop it
        AddEventHandler('onClientResourceStop', function(resourceName)
            if resourceName == GetCurrentResourceName() then
                TriggerServerEvent("rmg:removePlayer", Config.ResourceStopProtection.lang.kickReason)
            end
        end)
        
        -- Periodic resource list validation
        Citizen.CreateThread(function()
            while true do
                Wait(60000) -- Check every minute
                
                local resources = {}
                for i = 0, GetNumResources() - 1 do
                    table.insert(resources, GetResourceByFindIndex(i))
                end
                
                TriggerServerEvent("rmg:validateResources", resources)
                
                Wait(5000) -- Add buffer to prevent spam
            end
        end)
    end
end)

-- Blacklisted entity detection
Citizen.CreateThread(function()
    if Config.EntityBlacklist.active then
        while true do
            Wait(1000)
            
            local ped = PlayerPedId()
            if ped then
                local entities = GetGamePool('CObject')
                for _, entity in ipairs(entities) do
                    local model = GetEntityModel(entity)
                    
                    -- Check against blacklisted models
                    for blacklistedModel, _ in pairs(Config.EntityBlacklist.blacklistedModels) do
                        if model == blacklistedModel then
                            -- Delete the entity
                            NetworkRequestControlOfEntity(entity)
                            SetEntityAsMissionEntity(entity, true, true)
                            DeleteEntity(entity)
                            
                            -- Report to server
                            TriggerServerEvent("rmg:entityViolation", model)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- Weapon check for blacklisted weapons
Citizen.CreateThread(function()
    if Config.WeaponBlacklist.active then
        while true do
            Wait(2000)
            
            local ped = PlayerPedId()
            if ped then
                for weapon, _ in pairs(Config.WeaponBlacklist.blacklistedWeapons) do
                    if HasPedGotWeapon(ped, weapon, false) then
                        -- Remove the weapon
                        RemoveWeaponFromPed(ped, weapon)
                        
                        -- Report to server
                        TriggerServerEvent("rmg:weaponViolation", weapon)
                    end
                end
            end
        end
    end
end)

-- Health integrity check
Citizen.CreateThread(function()
    if Config.IntegrityCheck.active then
        while true do
            Wait(2000)
            
            local ped = PlayerPedId()
            if ped and not IsEntityDead(ped) then
                local maxHealth = GetEntityMaxHealth(ped)
                
                -- Check if health is abnormally high (allowing for golden cores)
                if maxHealth > 2100 then
                    TriggerServerEvent("rmg:removePlayer", Config.IntegrityCheck.lang.kickReason)
                    return
                end
            end
        end
    end
end)