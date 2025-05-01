-- Client-side network monitoring and manipulation detection

-- Set up network stability checks
if Config.Network.active then
    Citizen.CreateThread(function()
        while true do
            -- Ping the server periodically to verify connection
            TriggerServerEvent("rmg:networkPing")
            Wait(Config.Network.checkInterval)
        end
    end)
    
    -- Register network response event
    RegisterNetEvent("rmg:networkPong")
    AddEventHandler("rmg:networkPong", function(data)
        local currentTime = GetGameTimer()
        local ping = currentTime - data.timestamp
        
        -- Send ping data back to server for logging
        if ping > 0 then
            TriggerServerEvent("rmg:logPing", ping)
        end
    end)
    
    -- Handle connection warnings
    RegisterNetEvent("rmg:connectionWarning")
    AddEventHandler("rmg:connectionWarning", function(message, severity)
        -- Display warnings to player based on severity
        if severity == "low" then
            VORPcore.NotifyLeft("Connection Warning", message, "generic_textures", "tick", 4000)
        elseif severity == "medium" then
            VORPcore.NotifyCenter(message, 4000)
        elseif severity == "high" then
            VORPcore.Notify("ALERT", message, "error", 5000)
        end
    end)
end

-- Network blocking mitigation (VPN/lag switch detection)
local lastNetworkCheck = 0
local networkFailures = 0

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        
        local currentTime = GetGameTimer()
        if currentTime - lastNetworkCheck > 5000 then
            local isNetworkActive = NetworkIsSessionActive()
            
            if not isNetworkActive then
                networkFailures = networkFailures + 1
                
                if networkFailures > 3 then
                    -- Potential network manipulation detected
                    TriggerServerEvent("rmg:networkAnomaly", networkFailures)
                end
            else
                -- Reset failure count if connection is stable
                networkFailures = math.max(0, networkFailures - 1)
            end
            
            lastNetworkCheck = currentTime
        end
    end
end) 