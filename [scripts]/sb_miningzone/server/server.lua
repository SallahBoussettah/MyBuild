local VORPcore = exports.vorp_core:GetCore()

-- Log initialization
print("^2SB Mining Zones^7: Initialized ^3" .. #Config.MiningZones .. "^7 mining zones.")

-- Register callback to check if a player is allowed to mine at a location
RegisterServerEvent("sb_miningzone:checkMiningPermission")
AddEventHandler("sb_miningzone:checkMiningPermission", function(coords)
    local _source = source
    
    -- Add additional server-side permission checks here if needed
    -- For example, check if player has a specific item or job to allow mining
    
    TriggerClientEvent("sb_miningzone:miningPermissionResult", _source, true)
end)

-- Export functions for other resources to use
exports('GetMiningZones', function()
    return Config.MiningZones
end)

-- Get number of players currently in each mining zone
exports('GetPlayersInMiningZones', function()
    local zonePlayerCounts = {}
    
    for _, zone in pairs(Config.MiningZones) do
        zonePlayerCounts[zone.name] = 0
    end
    
    -- This would need additional tracking of player positions
    -- which would require regular updates from clients
    
    return zonePlayerCounts
end) 