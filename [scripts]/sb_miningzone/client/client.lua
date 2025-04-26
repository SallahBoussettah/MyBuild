local VORPcore = exports.vorp_core:GetCore()
local blips = {}
local inMiningZone = false
local currentZone = nil
local debugMode = Config.Debug
local playerMiningState = "idle" -- Can be: idle, mining

-- Function to check if a player is in a mining zone
local function IsPlayerInMiningZone()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local result = { inZone = false, zoneName = nil, zoneObject = nil }
    
    for _, zone in pairs(Config.MiningZones) do
        local distance = #(playerCoords - vector3(zone.coords.x, zone.coords.y, zone.coords.z))
        
        if distance <= zone.radius then
            result.inZone = true
            result.zoneName = zone.name
            result.zoneObject = zone
            break
        end
    end
    
    return result
end

-- Create blips for mining zones
local function CreateMiningZoneBlips()
    if not Config.ShowMiningZoneBlips then return end
    
    for _, zone in pairs(Config.MiningZones) do
        if not zone.blip then goto continue end
        
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(blip, Config.Blip.sprite, 1)
        SetBlipScale(blip, Config.Blip.scale)
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, Config.Blip.color)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, zone.name)
        
        table.insert(blips, blip)
        
        ::continue::
    end
end

-- Function to create zone markers for debug purposes
local function CreateDebugZoneMarkers()
    if not Config.Debug then return end
    
    CreateThread(function()
        while debugMode do
            Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for _, zone in pairs(Config.MiningZones) do
                local zoneCenter = vector3(zone.coords.x, zone.coords.y, zone.coords.z)
                local distance = #(playerCoords - zoneCenter)
                
                -- Draw a marker at the zone center - Using a more visible color and style
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x50638AB9, zone.coords.x, zone.coords.y, zone.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, zone.radius, zone.radius, zone.radius, 0, 255, 255, 150, false, false, 2, false, false, false, false)
                
                -- Draw a central marker that's easier to spot
                Citizen.InvokeNative(0x2A32FAA57B937173, 0x50638AB9, zone.coords.x, zone.coords.y, zone.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 255, false, false, 2, false, false, false, false)
                
                -- Show debug text with zone info for nearby zones
                if distance <= 200.0 then
                    local onScreen, x, y = GetScreenCoordFromWorldCoord(zone.coords.x, zone.coords.y, zone.coords.z + 2.0)
                    if onScreen then
                        SetTextScale(0.35, 0.35)
                        SetTextFontForCurrentCommand(1)
                        SetTextColor(255, 255, 0, 255) -- Brighter yellow text
                        local str = "Mining Zone: " .. zone.name
                        Citizen.InvokeNative(0xADA9255D, 1)
                        DisplayText(CreateVarString(10, "LITERAL_STRING", str), x, y)
                        SetTextColor(255, 255, 255, 255)
                        SetTextScale(0.25, 0.25)
                        DisplayText(CreateVarString(10, "LITERAL_STRING", "Radius: " .. zone.radius .. "m"), x, y + 0.0175)
                        
                        -- Add distance info
                        SetTextColor(100, 255, 100, 255)
                        DisplayText(CreateVarString(10, "LITERAL_STRING", "Distance: " .. math.floor(distance) .. "m"), x, y + 0.035)
                    end
                end
            end
        end
    end)
end

-- Thread to continuously check if player is in a mining zone
CreateThread(function()
    Wait(2000) -- Give time for configs to load
    
    CreateMiningZoneBlips()
    CreateDebugZoneMarkers()
    
    while true do
        local zoneInfo = IsPlayerInMiningZone()
        
        if zoneInfo.inZone ~= inMiningZone then
            inMiningZone = zoneInfo.inZone
            currentZone = zoneInfo.zoneObject
            
            -- Trigger state change events
            if inMiningZone then
                TriggerEvent("sb_miningzone:enteredMiningZone", currentZone)
                VORPcore.NotifyRightTip("Entered Mining Zone: " .. currentZone.name, 4000)
                if debugMode then
                    print("Entered mining zone: " .. currentZone.name)
                end
            else
                TriggerEvent("sb_miningzone:exitedMiningZone")
                if currentZone then
                    VORPcore.NotifyRightTip("Exited Mining Zone: " .. currentZone.name, 4000)
                else
                    VORPcore.NotifyRightTip("Exited Mining Zone", 4000)
                end
                if debugMode then
                    print("Exited mining zone")
                end
            end
        end
        
        Wait(Config.CheckInterval)
    end
end)

-- EVENT HANDLERS

-- When mining finishes reset state
AddEventHandler("vorp_mining:finishedMining", function()
    playerMiningState = "idle"
end)

-- Register the exports
exports("IsPlayerInMiningZone", IsPlayerInMiningZone)
exports("GetCurrentMiningZone", function() return currentZone end)
exports("GetConfigValue", function(key) 
    if Config[key] ~= nil then
        return Config[key]
    end
    return nil
end)

-- Resource cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Clean up blips
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
end) 