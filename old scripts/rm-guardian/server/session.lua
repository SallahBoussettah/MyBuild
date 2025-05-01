-- Server-side session tracking and management

local playerSessions = {}

-- Handle session start notification from client
RegisterNetEvent("rmg:sessionStarted")
AddEventHandler("rmg:sessionStarted", function(data)
    local _source = source
    local playerId = GetPlayerIdentifiers(_source)[1] or "unknown"
    
    playerSessions[_source] = {
        player = playerId,
        startTime = os.time(),
        characterId = data.characterId or 0,
        playTime = 0,
        activityEvents = 0,
        idleTime = 0,
        lastUpdate = os.time()
    }
    
    -- Log session start
    print("[RedM Guardian] Player session started: " .. GetPlayerName(_source) .. " (" .. _source .. ")")
end)

-- Handle periodic updates from client
RegisterNetEvent("rmg:sessionUpdate")
AddEventHandler("rmg:sessionUpdate", function(data)
    local _source = source
    
    if playerSessions[_source] then
        -- Update session data
        playerSessions[_source].playTime = data.playTime or 0
        playerSessions[_source].activityEvents = (playerSessions[_source].activityEvents or 0) + (data.activityEvents or 0)
        playerSessions[_source].idleTime = data.idleTime or 0
        playerSessions[_source].lastUpdate = os.time()
        
        -- Check for suspicious activity patterns
        local activityRatio = playerSessions[_source].activityEvents / (data.playTime / 60) -- Events per minute
        
        -- If activity is too low but player is not idle, may be using automated tools
        if activityRatio < 0.5 and data.idleTime < 300 and data.playTime > 600 then
            WebhookAlert.sendMessage(_source, "Suspiciously low activity: " .. string.format("%.2f", activityRatio) .. " actions/min over " .. string.format("%.1f", data.playTime / 60) .. " minutes")
        end
        
        -- If activity is unnaturally high, may be using macros
        if activityRatio > 300 then -- Over 5 inputs per second sustained
            WebhookAlert.sendMessage(_source, "Unnaturally high activity: " .. string.format("%.2f", activityRatio) .. " actions/min")
        end
    end
end)

-- Handle time manipulation reports
RegisterNetEvent("rmg:timeManipulation")
AddEventHandler("rmg:timeManipulation", function(reportedTime)
    local _source = source
    
    -- Log the suspicious time value
    WebhookAlert.sendMessage(_source, "Possible game time manipulation: " .. tostring(reportedTime) .. " seconds")
end)

-- Handle session end reports
RegisterNetEvent("rmg:sessionEnded")
AddEventHandler("rmg:sessionEnded", function(data)
    local _source = source
    
    if playerSessions[_source] then
        local sessionDuration = os.time() - playerSessions[_source].startTime
        
        -- Check for time inconsistencies
        local reportedTime = data.playTime or 0
        
        -- Allow for some variance due to timing differences, but flag large discrepancies
        if math.abs(sessionDuration - reportedTime) > 300 then -- More than 5 minutes difference
            local discrepancy = string.format(
                "Session time discrepancy: Server recorded %d seconds, client reported %.1f seconds",
                sessionDuration,
                reportedTime
            )
            WebhookAlert.sendMessage(_source, discrepancy)
        end
        
        -- Clean up session data
        playerSessions[_source] = nil
    end
end)

-- Clean up when player disconnects
AddEventHandler('playerDropped', function(reason)
    local _source = source
    
    if playerSessions[_source] then
        local sessionDuration = os.time() - playerSessions[_source].startTime
        
        -- Record session info in console log at minimum
        print(string.format(
            "[RedM Guardian] Player session ended: %s (%s) - Duration: %d minutes",
            GetPlayerName(_source) or "Unknown",
            _source,
            math.floor(sessionDuration / 60)
        ))
        
        -- Clean up
        playerSessions[_source] = nil
    end
end)

-- Admin command to view session data
RegisterCommand('sessions', function(source, args, rawCommand)
    local _source = source
    
    -- Only allow admins to use this command
    if _source > 0 then
        local User = VorpCore.getUser(_source)
        if User and User.getGroup then
            local group = User.getGroup
            local isAdmin = false
            
            for _, role in ipairs(Config.Database.privilegedRoles) do
                if group == role then
                    isAdmin = true
                    break
                end
            end
            
            if isAdmin then
                -- Count active sessions
                local activeSessions = 0
                for _ in pairs(playerSessions) do
                    activeSessions = activeSessions + 1
                end
                
                TriggerClientEvent('vorp:TipRight', _source, "Active sessions: " .. activeSessions, 5000)
            end
        end
    else
        -- Output to server console
        local activeSessions = 0
        for _ in pairs(playerSessions) do
            activeSessions = activeSessions + 1
        end
        
        print("[RedM Guardian] Active sessions: " .. activeSessions)
        
        -- Print detailed session info if requested
        if args[1] == "detail" then
            for id, session in pairs(playerSessions) do
                print(string.format(
                    "Player %s (%s): %d minutes, %d events, Idle: %d seconds",
                    GetPlayerName(id) or "Unknown",
                    id,
                    math.floor((session.playTime or 0) / 60),
                    session.activityEvents or 0,
                    session.idleTime or 0
                ))
            end
        end
    end
end, false) 