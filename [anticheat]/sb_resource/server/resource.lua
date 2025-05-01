--[[
    Resource Injection Detection - Server Side
    Verifies client resources against server resources to detect injections
]]--

-- Only run if the feature is enabled in config
if Config.ResourceProtection.active then
    -- Initialize resource list
    local serverResources = {}
    
    -- Function to retrieve all server resources
    local function retrieveServerResources()
        serverResources = {}
        for i = 0, GetNumResources() - 1 do
            serverResources[GetResourceByFindIndex(i)] = true
        end
    end
    
    -- Function to send a Discord notification if enabled
    local function sendDiscordMessage(playerId, reason)
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
                    ["title"] = "Resource Injection Detected",
                    ["description"] = reason,
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
                        ["text"] = "sb_resource • " .. os.date("%Y-%m-%d %H:%M:%S")
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

    -- Update resource list whenever resources change
    AddEventHandler("onResourceListRefresh", retrieveServerResources)
    
    -- Register client resource check event handler
    RegisterServerEvent("sb_resource:check")
    AddEventHandler("sb_resource:check", function(clientResources)
        local playerId = source
        
        -- Verify that each client resource exists on the server
        for _, resourceName in ipairs(clientResources) do
            if not serverResources[resourceName] then
                -- Found an injected resource - kick player
                local kickReason = Config.Discord.lang.kick .. Config.ResourceProtection.lang.kickReason
                print('[sb_resource] Player ' .. GetPlayerName(playerId) .. ' (#' .. playerId .. ') detected with injected resource: ' .. resourceName)
                
                -- Send Discord notification if enabled
                sendDiscordMessage(playerId, kickReason)
                
                -- Kick the player
                DropPlayer(playerId, kickReason)
                break
            end
        end
    end)
    
    -- Register direct kick event (triggered when client verification is tampered with)
    RegisterServerEvent("sb_resource:kick")
    AddEventHandler("sb_resource:kick", function(reason)
        local playerId = source
        local kickReason = Config.Discord.lang.kick .. reason
        
        -- Send Discord notification if enabled
        sendDiscordMessage(playerId, kickReason)
        
        -- Kick the player
        DropPlayer(playerId, kickReason)
    end)
    
    -- Initialize server resources on startup
    retrieveServerResources()
    
    print('[sb_resource] Server-side resource protection initialized')
else
    print('[sb_resource] Resource protection disabled in config')
end 