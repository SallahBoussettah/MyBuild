--[[
    Speed Hack Detection - Client Side
    Sends regular heartbeats to server for time manipulation detection
]]--

-- Only run if the feature is enabled in config
if Config.Speed.active then
    Citizen.CreateThread(function()
        print('[sb_speed] Client-side speed detection initialized')
        
        -- Main heartbeat loop
        while true do
            -- Wait for the configured interval
            Citizen.Wait(Config.Speed.heartbeatInterval)
            
            -- Send heartbeat to server with current client time
            TriggerServerEvent('sb_speed:heartbeat')
        end
    end)
end 