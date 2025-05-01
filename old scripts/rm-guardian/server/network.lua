-- Server-side network monitoring and security

if Config.Network.active then
    -- Track player connection data
    local playerNetworkData = {}
    
    -- Initialize network data when player connects
    AddEventHandler('playerJoining', function(oldID)
        local _source = source
        playerNetworkData[_source] = {
            disconnectCount = 0,
            lastPing = 0,
            pingHistory = {},
            warnings = 0
        }
    end)
    
    -- Clean up when player leaves
    AddEventHandler('playerDropped', function()
        local _source = source
        playerNetworkData[_source] = nil
    end)
    
    -- Handle client network pings
    RegisterNetEvent("rmg:networkPing")
    AddEventHandler("rmg:networkPing", function()
        local _source = source
        
        -- Initialize if not exists
        if not playerNetworkData[_source] then
            playerNetworkData[_source] = {
                disconnectCount = 0,
                lastPing = 0,
                pingHistory = {},
                warnings = 0
            }
        end
        
        -- Send timestamp back to client for round-trip calculation
        TriggerClientEvent("rmg:networkPong", _source, {
            timestamp = os.time() * 1000 -- Convert to ms for client-side comparison
        })
    end)
    
    -- Log ping data from clients
    RegisterNetEvent("rmg:logPing")
    AddEventHandler("rmg:logPing", function(ping)
        local _source = source
        
        if playerNetworkData[_source] then
            -- Store ping history (keep last 10 pings)
            table.insert(playerNetworkData[_source].pingHistory, ping)
            if #playerNetworkData[_source].pingHistory > 10 then
                table.remove(playerNetworkData[_source].pingHistory, 1)
            end
            
            -- Calculate average ping
            local sum = 0
            for _, p in ipairs(playerNetworkData[_source].pingHistory) do
                sum = sum + p
            end
            local avgPing = sum / #playerNetworkData[_source].pingHistory
            
            -- Check for ping spikes or unusual patterns
            if avgPing > 500 then -- Very high average ping
                playerNetworkData[_source].warnings = playerNetworkData[_source].warnings + 1
                
                if playerNetworkData[_source].warnings >= 3 then
                    TriggerClientEvent("rmg:connectionWarning", _source, "Your connection appears unstable. Please check your network.", "medium")
                end
                
                if playerNetworkData[_source].warnings >= 5 then
                    WebhookAlert.sendMessage(_source, "Excessive ping: " .. avgPing .. "ms")
                end
            else
                -- Reduce warnings for stable connections
                playerNetworkData[_source].warnings = math.max(0, playerNetworkData[_source].warnings - 1)
            end
        end
    end)
    
    -- Handle network anomaly reports from client
    RegisterNetEvent("rmg:networkAnomaly")
    AddEventHandler("rmg:networkAnomaly", function(failures)
        local _source = source
        
        if playerNetworkData[_source] then
            playerNetworkData[_source].disconnectCount = playerNetworkData[_source].disconnectCount + 1
            
            -- Warn on repeated failures
            if playerNetworkData[_source].disconnectCount > Config.Network.toleratedDisconnects then
                WebhookAlert.sendMessage(_source, "Possible network manipulation detected: " .. playerNetworkData[_source].disconnectCount .. " disconnects")
                
                -- Kick player if they exceed the limit
                if playerNetworkData[_source].disconnectCount > Config.Network.toleratedDisconnects + 2 then
                    KickPlayer(_source, Config.Network.lang.kickReason)
                end
            end
        end
    end)
end 