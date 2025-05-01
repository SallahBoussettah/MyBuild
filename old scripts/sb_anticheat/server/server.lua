-- Initialize VorpCore
VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

-- Startup message
Citizen.CreateThread(function()
    print("^2[sb_anticheat]^7 Anti-cheat system initialized")
    print("^2[sb_anticheat]^7 Version: " .. GetResourceMetadata(GetCurrentResourceName(), "version", 0))
end)

-- Tracking for player kicks to prevent abuse
local recentKicks = {}

-- Log and process kick events 
RegisterServerEvent("ac:kick")
AddEventHandler("ac:kick", function(reason)
    local _source = source
    local playerName = GetPlayerName(_source) or "Unknown"
    
    -- Validate reason
    if not reason or reason == "" then
        reason = "Anti-cheat violation"
    end
    
    -- Check if player has been recently kicked to prevent event spam
    local playerIdentifier = GetPlayerIdentifier(_source, 0)
    if playerIdentifier then
        local currentTime = os.time()
        if recentKicks[playerIdentifier] and (currentTime - recentKicks[playerIdentifier]) < 5 then
            -- Duplicate kick request within 5 seconds, ignore
            return
        end
        recentKicks[playerIdentifier] = currentTime
    end
    
    -- Log to console
    print("^1[ANTICHEAT KICK]^7 " .. playerName .. " (ID: " .. _source .. ") was kicked. Reason: " .. reason)
    
    -- Send to Discord if enabled
    Discord.sendMessage(_source, Config.Discord.lang.kick .. reason)
    
    -- Perform the actual kick
    DropPlayer(_source, Config.Discord.lang.kick .. reason)
    
    -- Cleanup old kick records every 30 seconds to prevent memory leaks
    Citizen.CreateThread(function()
        local currentTime = os.time()
        for identifier, kickTime in pairs(recentKicks) do
            if (currentTime - kickTime) > 60 then -- Remove records older than 1 minute
                recentKicks[identifier] = nil
            end
        end
    end)
end)

-- Additional utility functions for other scripts
function IsUserAdmin(source)
    local Character = VorpCore.getUser(source).getUsedCharacter
    if Character and Character.group then
        return Character.group == "admin"
    end
    return false
end

-- Exposed for other resources
exports('isAdmin', function(source)
    return IsUserAdmin(source)
end)

-- Generic log function that works with or without Discord
function LogAction(source, action, details)
    local playerName = "System"
    if source > 0 then
        playerName = GetPlayerName(source) or "Unknown"
    end
    
    -- Always log to console
    print("^3[ANTICHEAT LOG]^7 " .. playerName .. " - " .. action .. (details and (" - " .. details) or ""))
    
    -- Log to Discord if enabled
    if Config.Discord.active then
        Discord.sendMessage(source, action .. (details and ("\n" .. details) or ""))
    end
end

-- Export the log function
exports('logAction', function(source, action, details)
    LogAction(source, action, details)
end)