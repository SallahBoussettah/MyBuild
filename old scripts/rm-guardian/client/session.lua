-- Client-side session monitoring and management system

local sessionData = {
    startTime = 0,
    lastActivity = 0,
    totalPlayTime = 0,
    activityEvents = 0
}

-- Initialize session data when character is selected
RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function(charid)
    sessionData.startTime = GetGameTimer()
    sessionData.lastActivity = GetGameTimer()
    
    -- Send initial session data to server
    Citizen.SetTimeout(10000, function()
        TriggerServerEvent("rmg:sessionStarted", {
            startTime = sessionData.startTime,
            characterId = charid
        })
    end)
end)

-- Update session data periodically
Citizen.CreateThread(function()
    while true do
        Wait(60000) -- Update every minute
        
        if sessionData.startTime > 0 then
            local currentTime = GetGameTimer()
            sessionData.totalPlayTime = (currentTime - sessionData.startTime) / 1000 -- Convert to seconds
            
            -- Check for potential time manipulation
            if sessionData.totalPlayTime < 0 or sessionData.totalPlayTime > 86400 * 2 then -- More than 2 days in one session is suspicious
                sessionData.startTime = currentTime -- Reset the timer
                TriggerServerEvent("rmg:timeManipulation", sessionData.totalPlayTime)
            else
                -- Report session data to server
                TriggerServerEvent("rmg:sessionUpdate", {
                    playTime = sessionData.totalPlayTime,
                    activityEvents = sessionData.activityEvents,
                    idleTime = (currentTime - sessionData.lastActivity) / 1000
                })
                
                -- Reset activity counter after reporting
                sessionData.activityEvents = 0
            end
        end
    end
end)

-- Monitor player activity events to detect AFK status or bots
local activityControls = {
    0x07CE1E61, -- Left Mouse Button
    0xF84FA74F, -- Right Mouse Button
    0x8FFC75D6, -- Spacebar
    0xD9D0E1C0, -- Enter
    0xCEFD9220, -- E key
    0x8CC9CD42, -- F key
    0xD27782E3, -- W key
    0x7065027D, -- A key
    0xB4E465B4, -- S key
    0xB73BCA77  -- D key
}

Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        for _, control in ipairs(activityControls) do
            if IsControlJustPressed(0, control) then
                sessionData.lastActivity = GetGameTimer()
                sessionData.activityEvents = sessionData.activityEvents + 1
                break
            end
        end
    end
end)

-- Report final session data when player disconnects (may not always fire)
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() and sessionData.startTime > 0 then
        local currentTime = GetGameTimer()
        sessionData.totalPlayTime = (currentTime - sessionData.startTime) / 1000
        
        TriggerServerEvent("rmg:sessionEnded", {
            playTime = sessionData.totalPlayTime,
            activityEvents = sessionData.activityEvents
        })
    end
end) 