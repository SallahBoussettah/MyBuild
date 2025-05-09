--[[
    Network Connection Check - Server Side
    Monitors player connection status through heartbeat checks
]]--

-- Only run if the feature is enabled in config
if Config.Network.active then
    -- Track all connected players and their heartbeat status
    local players = {}

    -- Function to send a Discord notification if enabled
    local function sendDiscordMessage(playerId, message)
        if Config.Discord.active and Config.Discord.webhook ~= "" then
            local playerName = GetPlayerName(playerId) or "Unknown"
            local playerIdentifiers = GetPlayerIdentifiers(playerId)
            local steam = "Unknown"
            
            for _, identifier in pairs(playerIdentifiers) do
                if string.find(identifier, "steam:") then
                    steam = identifier
                    break
                end
            end
            
            local message = {
                {
                    ["color"] = 16711680, -- Red color for kick messages
                    ["title"] = "Network Connection Issue",
                    ["description"] = message,
                    ["fields"] = {
                        {
                            ["name"] = "Player Name",
                            ["value"] = playerName,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Player ID",
                            ["value"] = playerId,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Steam",
                            ["value"] = steam,
                            ["inline"] = false
                        }
                    },
                    ["footer"] = {
                        ["text"] = "sb_network • " .. os.date("%Y-%m-%d %H:%M:%S")
                    }
                }
            }
            
            PerformHttpRequest(Config.Discord.webhook, function(err, text, headers) end, 'POST', json.encode({
                username = Config.Discord.webhookName, 
                embeds = message, 
                avatar_url = Config.Discord.webhookAvatar
            }), { ['Content-Type'] = 'application/json' })
        end
    end

    -- Clean up player data when they disconnect
    AddEventHandler('playerDropped', function(reason)
        local playerId = source
        if players[tostring(playerId)] then
            players[tostring(playerId)] = nil
        end
    end)

    -- Main heartbeat thread
    Citizen.CreateThread(function()
        while true do
            -- Check all connected players
            for _, playerId in ipairs(GetPlayers()) do
                if GetPlayerPed(playerId) ~= 0 then
                    local playerIdStr = tostring(playerId)
                    
                    -- Initialize player data if not exists
                    if not players[playerIdStr] then
                        players[playerIdStr] = {
                            name = GetPlayerName(playerId),
                            id = playerId,
                            responseReceived = true,
                            offenses = 0,
                            kickScheduled = false
                        }
                    end

                    -- If player hasn't responded to previous heartbeat
                    if not players[playerIdStr].responseReceived then
                        players[playerIdStr].offenses = players[playerIdStr].offenses + 1
                        
                        -- If player has exceeded allowed offenses and isn't already scheduled for kick
                        if players[playerIdStr].offenses >= Config.Network.allowedOffenses and not players[playerIdStr].kickScheduled then
                            players[playerIdStr].kickScheduled = true
                            
                            -- Schedule kick after delay
                            Citizen.SetTimeout(Config.Network.kickDelay, function()
                                if players[playerIdStr] and GetPlayerPing(playerId) > 0 then
                                    local kickReason = Config.Discord.lang.kick .. Config.Network.lang.kickReason
                                    sendDiscordMessage(playerId, kickReason)
                                    DropPlayer(playerId, kickReason)
                                end
                            end)
                        end
                    end
                    
                    -- Reset response flag and send new heartbeat
                    players[playerIdStr].responseReceived = false
                    TriggerClientEvent('sb_network:heartbeat', playerId)
                end
            end

            -- Wait for next check interval
            Citizen.Wait(Config.Network.checkInterval)
        end
    end)

    -- Register heartbeat response event
    RegisterServerEvent('sb_network:response')
    AddEventHandler('sb_network:response', function()
        local playerId = source
        local playerIdStr = tostring(playerId)
        
        if players[playerIdStr] then
            players[playerIdStr].responseReceived = true
            players[playerIdStr].offenses = 0
            players[playerIdStr].kickScheduled = false
        end
    end)

    print('[sb_network] Server-side network monitoring initialized')
else
    print('[sb_network] Network monitoring disabled in config')
end 