local VORPcore = {}
local VORPinv = {}
local cooldownActive = false
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
        print("[VORP_WALLBREAK] " .. msg)
    end
end

-- Remove dynamite from player inventory
RegisterServerEvent("vorp_wallbreak:removeDynamite")
AddEventHandler("vorp_wallbreak:removeDynamite", function()
    local _source = source
    VORPinv.subItem(_source, Config.Dynamite.itemName, 1)
    Debug("Removed 1 dynamite from player " .. _source)
end)

-- Check if the wall break action is on cooldown
RegisterServerEvent("vorp_wallbreak:checkCooldown")
AddEventHandler("vorp_wallbreak:checkCooldown", function()
    local _source = source
    TriggerClientEvent("vorp_wallbreak:cooldownCheck", _source, cooldownActive)
end)

-- Handle explosion event
RegisterServerEvent("vorp_wallbreak:explode")
AddEventHandler("vorp_wallbreak:explode", function(coords)
    local _source = source
    
    -- Record the explosion time
    lastExplosionTime = os.time()
    
    -- Notify all players about the explosion (within range)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        TriggerClientEvent("vorp_wallbreak:explosionEffect", player, coords)
    end
    
    -- Alert law enforcement
    for _, player in ipairs(players) do
        local character = VORPcore.getUser(player).getUsedCharacter
        if character then
            -- Check if player is law enforcement (you may need to adapt this to your job system)
            local job = character.job
            if job == "sheriff" or job == "police" or job == "marshal" then
                TriggerClientEvent("vorp_wallbreak:alertLaw", player, coords)
            end
        end
    end
    
    -- Log the event
    Debug("Wall explosion triggered by player " .. _source)
end)

-- Start cooldown period
RegisterServerEvent("vorp_wallbreak:startCooldown")
AddEventHandler("vorp_wallbreak:startCooldown", function()
    local _source = source
    cooldownActive = true
    
    -- Notify all clients about the cooldown
    TriggerClientEvent("vorp_wallbreak:setCooldown", -1, true)
    
    -- Set a timer to reset the cooldown
    Citizen.CreateThread(function()
        Citizen.Wait(Config.Dynamite.cooldownTime * 1000)
        cooldownActive = false
        TriggerClientEvent("vorp_wallbreak:setCooldown", -1, false)
        Debug("Wall break cooldown has ended")
    end)
    
    Debug("Wall break cooldown started by player " .. _source)
end)

-- Admin command to check if player is admin and reset wall
RegisterServerEvent("vorp_wallbreak:checkAdmin")
AddEventHandler("vorp_wallbreak:checkAdmin", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    
    -- Check if player is admin (using VORP's group system)
    if Character.group == "admin" or Character.group == "moderator" then
        -- Reset cooldown
        cooldownActive = false
        TriggerClientEvent("vorp_wallbreak:setCooldown", -1, false)
        
        -- Trigger wall reset on the client
        TriggerClientEvent("vorp_wallbreak:resetWall", _source)
        
        Debug("Admin " .. _source .. " reset the wall state")
    else
        -- Not an admin
        TriggerClientEvent("vorp:NotifyLeft", _source, "Access Denied", "You need admin privileges to use this command", "generic_textures", "tick", 4000, "COLOR_RED")
        Debug("Player " .. _source .. " tried to reset wall without permission")
    end
end)

-- Admin command to directly reset the cooldown
RegisterServerEvent("vorp_wallbreak:resetCooldown")
AddEventHandler("vorp_wallbreak:resetCooldown", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    
    -- Double check if player is admin (using VORP's group system)
    if Character.group == "admin" or Character.group == "moderator" then
        cooldownActive = false
        TriggerClientEvent("vorp_wallbreak:setCooldown", -1, false)
        Debug("Cooldown reset by admin " .. _source)
    end
end)

-- Save the explosion state on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    -- Save the last explosion time to a file so we can load it when the resource restarts
    if lastExplosionTime > 0 then
        SaveResourceFile(GetCurrentResourceName(), "explosion_time.json", json.encode({time = lastExplosionTime}), -1)
    end
end)

-- Load the explosion state on resource start
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    -- Load the last explosion time from file
    local explosionData = LoadResourceFile(GetCurrentResourceName(), "explosion_time.json")
    if explosionData then
        local data = json.decode(explosionData)
        if data and data.time then
            lastExplosionTime = data.time
            local currentTime = os.time()
            local elapsedTime = currentTime - lastExplosionTime
            
            -- Check if we are still within the cooldown period
            if elapsedTime < Config.Dynamite.cooldownTime then
                cooldownActive = true
                
                -- Set a timer for the remaining cooldown time
                Citizen.CreateThread(function()
                    local remainingTime = Config.Dynamite.cooldownTime - elapsedTime
                    Debug("Resuming wall break cooldown with " .. remainingTime .. " seconds remaining")
                    
                    Citizen.Wait(remainingTime * 1000)
                    cooldownActive = false
                    TriggerClientEvent("vorp_wallbreak:setCooldown", -1, false)
                    Debug("Wall break cooldown has ended")
                end)
            end
            
            -- Check if wall should still be broken
            if elapsedTime < Config.WallRepairTime then
                -- Wall is still broken, notify clients
                TriggerClientEvent("vorp_wallbreak:setCooldown", -1, true)
                
                -- Set a timer for the remaining wall broken time
                Citizen.CreateThread(function()
                    local remainingTime = Config.WallRepairTime - elapsedTime
                    Debug("Wall will remain broken for " .. remainingTime .. " more seconds")
                    
                    Citizen.Wait(remainingTime * 1000)
                    TriggerClientEvent("vorp_wallbreak:setCooldown", -1, false)
                    Debug("Wall has been repaired")
                end)
            end
        end
    end
end)