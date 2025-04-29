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
        print("[SB_PRISONBREAK] " .. msg)
    end
end

-- Remove dynamite from player inventory
RegisterServerEvent("sb_prisonbreak:removeDynamite")
AddEventHandler("sb_prisonbreak:removeDynamite", function()
    local _source = source
    VORPinv.subItem(_source, Config.Dynamite.itemName, 1)
    Debug("Removed 1 dynamite from player " .. _source)
end)

-- Check if the action is on cooldown
RegisterServerEvent("sb_prisonbreak:checkCooldown")
AddEventHandler("sb_prisonbreak:checkCooldown", function(type)
    local _source = source
    
    if type == "dynamite" then
        -- First check if player has dynamite before proceeding
        local hasDynamite = VORPinv.getItemCount(_source, Config.Dynamite.itemName) > 0
        
        -- If player doesn't have dynamite, don't proceed regardless of cooldown
        if not hasDynamite then
            TriggerClientEvent("sb_prisonbreak:cooldownCheck", _source, true, type, "no_item") -- Add reason parameter "no_item"
            TriggerClientEvent("vorp:NotifyLeft", _source, "No Dynamite", "You don't have any dynamite", "generic_textures", "cross", 4000)
            return
        end
        
        -- Only if player has dynamite, check the actual cooldown
        TriggerClientEvent("sb_prisonbreak:cooldownCheck", _source, dynamiteCooldownActive, type, "cooldown") -- Add reason parameter "cooldown"
    else
        -- For teleporting, never use cooldown - always allow if teleport is enabled
        local isOnCooldown = false -- Never apply cooldown to teleporting
        TriggerClientEvent("sb_prisonbreak:cooldownCheck", _source, isOnCooldown, type, "cooldown") -- Add reason parameter "cooldown"
    end
end)

-- Handle explosion event
RegisterServerEvent("sb_prisonbreak:explode")
AddEventHandler("sb_prisonbreak:explode", function(coords)
    local _source = source
    
    -- Record the explosion time
    lastExplosionTime = os.time()
    
    -- Notify all players about the explosion (within range)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        -- Let each client handle the explosion effect based on their location
        -- Each client will determine if they're inside the cell and protected
        TriggerClientEvent("sb_prisonbreak:explosionEffect", player, coords)
    end
    
    -- Alert law enforcement
    local officersAlerted = 0
    
    -- Check if sb_police is running and use its alert system
    local resourceState = GetResourceState('sb_police')
    if resourceState == 'started' then
        -- Use the sb_police export for alert with our custom explosion message
        officersAlerted = exports['sb_police']:AlertPolice(_source, coords, "Explosion detected at Strawberry Jail! Possible break attempt.")
    else
        -- Fallback to original notification method if sb_police isn't available
        local maxOfficersToAlert = 4 -- Number of closest officers to alert
        local officerDistances = {}
        
        -- Find all on-duty police officers
        for _, player in ipairs(players) do
            -- Check specifically for the jobs: police, marshal, sheriffrhodes, lawmen
            local Character = VORPcore.getUser(tonumber(player)).getUsedCharacter
            local job = Character.job
            
            -- Check if the player's job is one of the specified law enforcement jobs
            if job == "police" or job == "marshal" or job == "sheriffrhodes" or job == "lawmen" then
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
RegisterServerEvent("sb_prisonbreak:alertLaw")
AddEventHandler("sb_prisonbreak:alertLaw", function(coords)
    local _source = source
    
    -- Get all online players
    local players = GetPlayers()
    local officersAlerted = 0
    
    -- Check if sb_police is running and use its alert system
    local resourceState = GetResourceState('sb_police')
    if resourceState == 'started' then
        -- Use the sb_police export for alert with our custom prison break message
        officersAlerted = exports['sb_police']:AlertPolice(_source, coords, "Prison break in progress at Strawberry Jail!")
    else
        -- Fallback to original notification method if sb_police isn't available
        local maxOfficersToAlert = 4 -- Number of closest officers to alert
        local officerDistances = {}
        
        -- Find all on-duty police officers
        for _, player in ipairs(players) do
            -- Check specifically for the jobs: police, marshal, sheriffrhodes, lawmen
            local Character = VORPcore.getUser(tonumber(player)).getUsedCharacter
            local job = Character.job
            
            -- Check if the player's job is one of the specified law enforcement jobs
            if job == "police" or job == "marshal" or job == "sheriffrhodes" or job == "lawmen" then
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
    end
    
    -- Record teleport time
    lastTeleportTime = os.time()
    
    -- Log the event
    if Config.Debug then
        Debug("Prison teleport used by player " .. _source .. " - " .. officersAlerted .. " officers alerted")
    end
end)

-- Admin command to check if player is admin and reset cooldown/teleport
RegisterServerEvent("sb_prisonbreak:checkAdmin")
AddEventHandler("sb_prisonbreak:checkAdmin", function()
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
        TriggerClientEvent("sb_prisonbreak:setCooldown", -1, false)
        TriggerClientEvent("sb_prisonbreak:setTeleportState", -1, false)
        
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
RegisterServerEvent("sb_prisonbreak:saveTeleportState")
AddEventHandler("sb_prisonbreak:saveTeleportState", function(state)
    teleportEnabled = state
    
    -- If enabled, update the last explosion time
    if state then
        lastExplosionTime = os.time()
    end
    
    -- Propagate state to all clients to ensure synchronization
    TriggerClientEvent("sb_prisonbreak:setTeleportState", -1, state)
    
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
            TriggerClientEvent("sb_prisonbreak:setTeleportState", -1, teleportEnabled)
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
                    TriggerClientEvent("sb_prisonbreak:setTeleportState", -1, true)
                    
                    Citizen.Wait(remainingTime * 1000)
                    teleportEnabled = false
                    TriggerClientEvent("sb_prisonbreak:setTeleportState", -1, false)
                end)
            end
            
            -- Check if we are still within the cooldown period
            if elapsedSinceExplosion < Config.Dynamite.cooldownTime then
                dynamiteCooldownActive = true
                
                -- Set a timer for the remaining cooldown
                Citizen.CreateThread(function()
                    local remainingTime = Config.Dynamite.cooldownTime - elapsedSinceExplosion
                    
                    -- Notify all clients
                    TriggerClientEvent("sb_prisonbreak:setCooldown", -1, true)
                    
                    Citizen.Wait(remainingTime * 1000)
                    dynamiteCooldownActive = false
                    TriggerClientEvent("sb_prisonbreak:setCooldown", -1, false)
                end)
            end
        end
        
        if data and data.teleportTime then
            lastTeleportTime = data.teleportTime
        end
    end
end)

-- Event handler for when a player rejoins - sends them the current teleport state
RegisterServerEvent("sb_prisonbreak:getServerState")
AddEventHandler("sb_prisonbreak:getServerState", function()
    local _source = source
    TriggerClientEvent("sb_prisonbreak:setTeleportState", _source, teleportEnabled)
end)

-- ADDED: Handle unjail player request from client after successful teleport
RegisterServerEvent("sb_prisonbreak:unjailPlayer")
AddEventHandler("sb_prisonbreak:unjailPlayer", function()
    local _source = source
    local target_id = _source -- The player who wants to be unjailed is the one who sent the event
    
    -- Check if sb_police is running
    local resourceState = GetResourceState('sb_police')
    if resourceState == 'started' then
        -- Get the jail location of the player first
        local Character = VORPcore.getUser(target_id).getUsedCharacter
        local CharacterID = Character.charIdentifier
        local steam_id = Character.identifier
        
        -- Query the jail database to get the player's jail location
        exports.ghmattimysql:execute("SELECT * FROM `jail` WHERE characterid = @characterid",
            { ["@characterid"] = CharacterID }
            , function(result)
                if result[1] then
                    local jailLocation = result[1]["jaillocation"]
                    
                    -- Check if the player is in Strawberry jail
                    if jailLocation == "st" then
                        -- For Strawberry jail, we'll handle the teleport differently
                        -- First, delete the player from jail database to free them
                        exports.ghmattimysql:execute("DELETE FROM jail WHERE identifier = @identifier AND characterid = @characterid",
                            { ["@identifier"] = steam_id, ["@characterid"] = CharacterID })
                        
                        -- Then trigger a custom unjail event that won't teleport the player
                        TriggerClientEvent("sb_prisonbreak:CustomUnjail", target_id)
                        
                        -- Debug message
                        if Config.Debug then
                            Debug("Player " .. _source .. " automatically unjailed from Strawberry jail without teleport")
                        end
                    else
                        -- For other jails, use the regular unjail system
                        TriggerEvent("sb_police:finishedjail", target_id)
                        
                        -- Debug message
                        if Config.Debug then
                            Debug("Player " .. _source .. " automatically unjailed from " .. jailLocation .. " jail")
                        end
                    end
                    
                    -- Notify the player they were unjailed
                    TriggerClientEvent("vorp:NotifyLeft", _source, 
                        "Prison Break", 
                        "You have successfully escaped from jail!", 
                        "inventory_items", 
                        "consumable_special_treasure_map", 
                        8000, 
                        "COLOR_GREEN")
                else
                    -- If no jail record was found
                    if Config.Debug then
                        Debug("Player " .. _source .. " tried to unjail but no jail record was found")
                    end
                end
            end)
    else
        -- If sb_police is not running, log a debug message
        if Config.Debug then
            Debug("Failed to unjail player " .. _source .. " - sb_police resource not running")
        end
    end
end) 