--[[
    Speed Hack Detection - Server Side
    Tracks client heartbeats to detect time manipulation hacks
]]--

-- Only run if the feature is enabled in config
if Config.Speed.active then
    -- Track player heartbeat times
    local players = {}

    -- Function to send a Discord notification if enabled
    local function sendDiscordMessage(playerId)
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
                    ["title"] = "Speed Hack Detected",
                    ["description"] = Config.Discord.lang.kick .. Config.Speed.lang.kickReason,
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
                        ["text"] = "sb_speed • " .. os.date("%Y-%m-%d %H:%M:%S")
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
        players[tostring(playerId)] = nil
    end)

    -- Register heartbeat event handler
    RegisterServerEvent('sb_speed:heartbeat')
    AddEventHandler('sb_speed:heartbeat', function()
        local playerId = source
        local playerIdStr = tostring(playerId)
        local currentTime = os.time()
        
        -- Initialize player data if first heartbeat
        if not players[playerIdStr] then
            players[playerIdStr] = {
                lastHeartbeat = currentTime
            }
            return
        end
        
        -- Check time difference between heartbeats
        local timeDiff = currentTime - players[playerIdStr].lastHeartbeat
        
        -- Update last heartbeat time
        players[playerIdStr].lastHeartbeat = currentTime
        
        -- If time difference is too small, player might be using speed hacks
        if timeDiff < Config.Speed.timeTolerance then
            -- Log detection to console
            print('[sb_speed] Player ' .. GetPlayerName(playerId) .. ' (#' .. playerId .. ') detected with speed hack (time diff: ' .. timeDiff .. 's)')
            
            -- Send Discord notification if enabled
            local kickReason = Config.Discord.lang.kick .. Config.Speed.lang.kickReason
            sendDiscordMessage(playerId)
            
            -- Kick the player
            DropPlayer(playerId, kickReason)
        end
    end)
    
    print('[sb_speed] Server-side speed hack detection initialized')
else
    print('[sb_speed] Speed hack detection disabled in config')
end 