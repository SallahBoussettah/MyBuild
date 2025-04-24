local VORPcore = {}
local VORPinv = {}
local dynamiteCooldownActive = false -- Renamed from cooldownActive to be more specific
local teleportEnabled = false
local lastTeleportTime = 0
local lastExplosionTime = 0

-- Initialize VORP Core
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

-- Initialize VORP Inventory
VORPinv = exports.vorp_inventory:vorp_inventoryApi()

-- Debug function
local function Debug(msg)
    if Config.Debug then
        print("[SL_TELEPORT] " .. msg)
    end
end

-- Remove dynamite from player inventory
RegisterServerEvent("sl_teleport:removeDynamite")
AddEventHandler("sl_teleport:removeDynamite", function()
    local _source = source
    VORPinv.subItem(_source, Config.Dynamite.itemName, 1)
    Debug("Removed 1 dynamite from player " .. _source)
end)

-- Check if the action is on cooldown
RegisterServerEvent("sl_teleport:checkCooldown")
AddEventHandler("sl_teleport:checkCooldown", function(type)
    local _source = source
    
    if type == "dynamite" then
        -- First check if player has dynamite before proceeding
        local hasDynamite = VORPinv.getItemCount(_source, Config.Dynamite.itemName) > 0
        
        -- If player doesn't have dynamite, don't proceed regardless of cooldown
        if not hasDynamite then
            TriggerClientEvent("sl_teleport:cooldownCheck", _source, true, type, "no_item") -- Add reason parameter "no_item"
            TriggerClientEvent("vorp:NotifyLeft", _source, "No Dynamite", "You don't have any dynamite", "generic_textures", "cross", 4000)
            return
        end
        
        -- Only if player has dynamite, check the actual cooldown
        TriggerClientEvent("sl_teleport:cooldownCheck", _source, dynamiteCooldownActive, type, "cooldown") -- Add reason parameter "cooldown"
    else
        -- For teleporting, never use cooldown - always allow if teleport is enabled
        local isOnCooldown = false -- Never apply cooldown to teleporting
        TriggerClientEvent("sl_teleport:cooldownCheck", _source, isOnCooldown, type, "cooldown") -- Add reason parameter "cooldown"
    end
end)

-- Handle explosion event
RegisterServerEvent("sl_teleport:explode")
AddEventHandler("sl_teleport:explode", function(coords)
    local _source = source
    
    -- Record the explosion time
    lastExplosionTime = os.time()
    
    -- Notify all players about the explosion (within range)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        -- Let each client handle the explosion effect based on their location
        -- Each client will determine if they're inside the cell and protected
        TriggerClientEvent("sl_teleport:explosionEffect", player, coords)
    end
    
    -- Alert law enforcement
    local officersAlerted = 0
    local maxOfficersToAlert = 4 -- Number of closest officers to alert (matching VORP doorlocks config)
    local officerDistances = {}
    
    -- Find all on-duty police officers
    for _, player in ipairs(players) do
        -- Check if player is police and on duty (using VORP police state system)
        if Player(tonumber(player)).state.isPoliceDuty then
            local officerCoords = GetEntityCoords(GetPlayerPed(tonumber(player)))
            local distance = #(coords - officerCoords)
            table.insert(officerDistances, { id = player, distance = distance })
        end
    end
    
    -- Sort officers by distance
    if #officerDistances > 0 then
        table.sort(officerDistances, function(a, b) return a.distance < b.distance end)
        
        -- Alert the closest officers (up to maxOfficersToAlert)
        for i = 1, math.min(maxOfficersToAlert, #officerDistances) do
            local officer = officerDistances[i]
            -- Create blip and notification for each officer
            TriggerClientEvent("vorp_police:Client:AlertPolice", tonumber(officer.id), coords)
            
            -- Send custom notification
            TriggerClientEvent("vorp:NotifyLeft", tonumber(officer.id), 
                "Explosion Alert", 
                "Explosion detected at Strawberry Jail! Possible break attempt.", 
                "inventory_items", 
                "provision_sheriff_star", 
                8000, 
                "COLOR_RED")
                
            officersAlerted = officersAlerted + 1
        end
    end
    
    -- Set the teleport as available
    teleportEnabled = true
    
    -- Start dynamite cooldown
    dynamiteCooldownActive = true
    
    -- Set a timer to disable the teleport after the configured time
    Citizen.CreateThread(function()
        Citizen.Wait(Config.TeleportActiveTime * 1000)
        teleportEnabled = false
    end)
    
    -- Set a timer to reset the dynamite cooldown
    Citizen.CreateThread(function()
        Citizen.Wait(Config.Dynamite.cooldownTime * 1000)
        dynamiteCooldownActive = false
    end)
    
    -- Log the event
    if Config.Debug then
        Debug("Explosion triggered by player " .. _source .. " - " .. officersAlerted .. " officers alerted")
    end
end)

-- Alert law enforcement for teleport
RegisterServerEvent("sl_teleport:alertLaw")
AddEventHandler("sl_teleport:alertLaw", function(coords)
    local _source = source
    
    -- Get all online players
    local players = GetPlayers()
    local officersAlerted = 0
    local maxOfficersToAlert = 4 -- Number of closest officers to alert (matching VORP doorlocks config)
    local officerDistances = {}
    
    -- Find all on-duty police officers
    for _, player in ipairs(players) do
        -- Check if player is police and on duty (using VORP police state system)
        if Player(tonumber(player)).state.isPoliceDuty then
            local officerCoords = GetEntityCoords(GetPlayerPed(tonumber(player)))
            local distance = #(coords - officerCoords)
            table.insert(officerDistances, { id = player, distance = distance })
        end
    end
    
    -- Sort officers by distance
    if #officerDistances > 0 then
        table.sort(officerDistances, function(a, b) return a.distance < b.distance end)
        
        -- Alert the closest officers (up to maxOfficersToAlert)
        for i = 1, math.min(maxOfficersToAlert, #officerDistances) do
            local officer = officerDistances[i]
            -- Create blip and notification for each officer
            TriggerClientEvent("vorp_police:Client:AlertPolice", tonumber(officer.id), coords)
            
            -- Send custom notification
            TriggerClientEvent("vorp:NotifyLeft", tonumber(officer.id), 
                "Prison Break Alert", 
                "Prison break in progress at Strawberry Jail!", 
                "inventory_items", 
                "provision_sheriff_star", 
                8000, 
                "COLOR_RED")
                
            officersAlerted = officersAlerted + 1
        end
    end
    
    -- Record teleport time
    lastTeleportTime = os.time()
    
    -- Log the event
    if Config.Debug then
        Debug("Prison teleport used by player " .. _source .. " - " .. officersAlerted .. " officers alerted")
    end
end)

-- Admin command to check if player is admin and reset cooldown/teleport
RegisterServerEvent("sl_teleport:checkAdmin")
AddEventHandler("sl_teleport:checkAdmin", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    
    -- Check if player is admin (using VORP's group system)
    if Character.group == "admin" or Character.group == "moderator" then
        -- Reset all jail system states
        dynamiteCooldownActive = false
        teleportEnabled = false
        lastTeleportTime = 0
        lastExplosionTime = 0
        
        -- Notify all clients to reset their states
        TriggerClientEvent("sl_teleport:setCooldown", -1, false)
        TriggerClientEvent("sl_teleport:setTeleportState", -1, false)
        
        -- Save the reset state to the JSON file to ensure persistence
        local data = {
            explosionTime = 0,
            teleportTime = 0,
            teleportEnabled = false
        }
        SaveResourceFile(GetCurrentResourceName(), "teleport_state.json", json.encode(data), -1)
        
        -- Notify the admin
        TriggerClientEvent("vorp:NotifyLeft", _source, "Reset Complete", "Jail teleport system has been completely reset", "generic_textures", "tick", 4000)
        Debug("Admin " .. _source .. " performed a full reset of the jail teleport system")
    else
        -- Not an admin
        TriggerClientEvent("vorp:NotifyLeft", _source, "Access Denied", "You need admin privileges to use this command", "generic_textures", "tick", 4000, "COLOR_RED")
        Debug("Player " .. _source .. " tried to reset jail teleport without permission")
    end
end)

-- Save the teleport state from client
RegisterServerEvent("sl_teleport:saveTeleportState")
AddEventHandler("sl_teleport:saveTeleportState", function(state)
    teleportEnabled = state
    
    -- If enabled, update the last explosion time
    if state then
        lastExplosionTime = os.time()
    end
    
    -- Propagate state to all clients to ensure synchronization
    TriggerClientEvent("sl_teleport:setTeleportState", -1, state)
    
    -- Save state to file immediately
    local data = {
        explosionTime = lastExplosionTime,
        teleportTime = lastTeleportTime,
        teleportEnabled = teleportEnabled
    }
    
    SaveResourceFile(GetCurrentResourceName(), "teleport_state.json", json.encode(data), -1)
end)

-- Save the teleport state on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    -- Save the last explosion and teleport times to a file
    local data = {
        explosionTime = lastExplosionTime,
        teleportTime = lastTeleportTime,
        teleportEnabled = teleportEnabled
    }
    
    SaveResourceFile(GetCurrentResourceName(), "teleport_state.json", json.encode(data), -1)
end)

-- Load the teleport state on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    -- Load the last explosion and teleport times from file
    local stateData = LoadResourceFile(GetCurrentResourceName(), "teleport_state.json")
    if stateData then
        local data = json.decode(stateData)
        local currentTime = os.time()
        
        -- Direct teleport state override if saved
        if data and data.teleportEnabled ~= nil then
            teleportEnabled = data.teleportEnabled
            -- Notify all clients of the current state
            TriggerClientEvent("sl_teleport:setTeleportState", -1, teleportEnabled)
        end
        
        if data and data.explosionTime then
            lastExplosionTime = data.explosionTime
            local elapsedSinceExplosion = currentTime - lastExplosionTime
            
            -- Check if we are still within the teleport active time
            if elapsedSinceExplosion < Config.TeleportActiveTime then
                teleportEnabled = true
                
                -- Set a timer for the remaining teleport active time
                Citizen.CreateThread(function()
                    local remainingTime = Config.TeleportActiveTime - elapsedSinceExplosion
                    
                    -- Notify all clients
                    TriggerClientEvent("sl_teleport:setTeleportState", -1, true)
                    
                    Citizen.Wait(remainingTime * 1000)
                    teleportEnabled = false
                    TriggerClientEvent("sl_teleport:setTeleportState", -1, false)
                end)
            end
            
            -- Check if we are still within the cooldown period
            if elapsedSinceExplosion < Config.Dynamite.cooldownTime then
                dynamiteCooldownActive = true
                
                -- Set a timer for the remaining cooldown
                Citizen.CreateThread(function()
                    local remainingTime = Config.Dynamite.cooldownTime - elapsedSinceExplosion
                    
                    -- Notify all clients
                    TriggerClientEvent("sl_teleport:setCooldown", -1, true)
                    
                    Citizen.Wait(remainingTime * 1000)
                    dynamiteCooldownActive = false
                    TriggerClientEvent("sl_teleport:setCooldown", -1, false)
                end)
            end
        end
        
        if data and data.teleportTime then
            lastTeleportTime = data.teleportTime
        end
    end
end) 