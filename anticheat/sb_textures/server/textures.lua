--[[
    Texture Detection System - Server Side
    Handles kicks and logging for blacklisted texture detections
]]--

-- Only run if the feature is enabled in config
if Config.Textures.active then
    -- Function to send a Discord notification if enabled
    local function sendDiscordMessage(playerId, textureName)
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
                    ["title"] = "Blacklisted Texture Detected",
                    ["description"] = Config.Discord.lang.kick .. Config.Textures.lang.kickReason .. ": " .. textureName,
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
                        },
                        {
                            ["name"] = "Texture Dictionary",
                            ["value"] = textureName,
                            ["inline"] = false
                        }
                    },
                    ["footer"] = {
                        ["text"] = "sb_textures • " .. os.date("%Y-%m-%d %H:%M:%S")
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

    -- Register texture detection event handler
    RegisterServerEvent('sb_textures:detected')
    AddEventHandler('sb_textures:detected', function(textureName)
        local playerId = source
        
        -- Log detection to console
        print('[sb_textures] Player ' .. GetPlayerName(playerId) .. ' (#' .. playerId .. ') had blacklisted texture: ' .. textureName)
        
        -- Send Discord notification if enabled
        local kickReason = Config.Discord.lang.kick .. Config.Textures.lang.kickReason .. ": " .. textureName
        sendDiscordMessage(playerId, textureName)
        
        -- Kick the player
        DropPlayer(playerId, kickReason)
    end)
    
    print('[sb_textures] Server-side texture monitoring initialized')
else
    print('[sb_textures] Texture monitoring disabled in config')
end 