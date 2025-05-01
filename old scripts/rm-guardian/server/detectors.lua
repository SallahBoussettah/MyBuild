-- Resource validation system
local resourceList = {}

-- Initialize the resource list
local function collectResources()
    resourceList = {}
    for i = 0, GetNumResources() - 1 do
        resourceList[GetResourceByFindIndex(i)] = true
    end
end

-- Check if a resource is valid
RegisterNetEvent("rmg:validateResources")
AddEventHandler("rmg:validateResources", function(clientResources)
    local _source = source
    
    if not Config.ResourceProtection.active then return end
    
    for _, resource in ipairs(clientResources) do
        if not resourceList[resource] then
            -- Unauthorized resource detected
            WebhookAlert.sendMessage(_source, "Unauthorized resource detected: " .. resource)
            KickPlayer(_source, Config.ResourceProtection.lang.reason)
            return
        end
    end
end)

-- Update resource list when resources change
AddEventHandler("onResourceListRefresh", collectResources)
AddEventHandler("onResourceStart", function(resource) resourceList[resource] = true end)
AddEventHandler("onResourceStop", function(resource) resourceList[resource] = nil end)

-- Initialize resource list when this resource starts
AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    collectResources()
end)

-- Handle entity violations
RegisterNetEvent("rmg:entityViolation")
AddEventHandler("rmg:entityViolation", function(model)
    local _source = source
    WebhookAlert.sendMessage(_source, "Blacklisted entity detected: " .. model)
    -- Note: We don't kick here as client has already removed the entity
end)

-- Handle weapon violations
RegisterNetEvent("rmg:weaponViolation")
AddEventHandler("rmg:weaponViolation", function(weapon)
    local _source = source
    WebhookAlert.sendMessage(_source, "Blacklisted weapon detected: " .. weapon)
    -- Note: We don't kick here as client has already removed the weapon
end)

-- Ammunition validation
if Config.AmmoValidator.active then
    Citizen.CreateThread(function()
        while true do
            Wait(10000) -- Check every 10 seconds
            
            for _, playerId in ipairs(GetPlayers()) do
                local ped = GetPlayerPed(playerId)
                if ped then
                    -- This would ideally check for abnormal ammo amounts
                    -- However, RedM doesn't expose direct ammo checking functions in the same way as FiveM
                    -- This could be enhanced with community-developed solutions
                end
            end
        end
    end)
end 