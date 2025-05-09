--[[
    Discord Webhook System - Server Side
    Provides centralized Discord notification functionality for all anticheat modules
]]--

-- Initialize
local Discord = {}

-- Function to extract player identifiers
local function GetPlayerIdentifiers(playerId)
    local identifiers = {
        steam = "Unknown",
        license = "Unknown",
        discord = "Unknown",
        ip = "Unknown"
    }
    
    -- Get all player identifiers
    local playerIdentifiers = GetPlayerIdentifiers(playerId)
    
    -- Extract specific identifiers
    for _, identifier in pairs(playerIdentifiers) do
        if string.find(identifier, "steam:") and Config.Discord.identifiers.includeSteam then
            identifiers.steam = identifier
        elseif string.find(identifier, "license:") and Config.Discord.identifiers.includeLicense then
            identifiers.license = identifier
        elseif string.find(identifier, "discord:") and Config.Discord.identifiers.includeDiscord then
            -- Remove the "discord:" prefix and convert to a format that can be displayed as a mention
            local discordId = string.gsub(identifier, "discord:", "")
            identifiers.discord = "<@" .. discordId .. ">"
        elseif string.find(identifier, "ip:") and Config.Discord.identifiers.includeIP then
            identifiers.ip = string.gsub(identifier, "ip:", "")
        end
    end
    
    return identifiers
end

-- Function to build and send Discord webhook
function Discord.sendToDiscord(webhookType, playerId, title, description, extraFields, logLevel)
    -- Check if Discord integration is enabled
    if not Config.Discord.active then return end
    
    -- Set defaults for optional parameters
    webhookType = webhookType or "anticheat"
    logLevel = logLevel or 1
    
    -- Check if we should send this message based on log level
    if logLevel > Config.Discord.logLevel then return end
    
    -- Get webhook configuration
    local webhook = Config.Discord.webhooks[webhookType]
    if not webhook or webhook.url == "" then
        -- Fall back to main anticheat webhook if specific one not found
        webhook = Config.Discord.webhooks.anticheat
        if not webhook or webhook.url == "" then
            print("[sb_discord] Warning: No valid webhook URL configured for " .. webhookType)
            return
        end
    end
    
    -- Build base message fields
    local fields = {}
    
    -- Add player details if a valid player ID is provided
    if playerId and tonumber(playerId) > 0 then
        local playerName = GetPlayerName(playerId) or "Unknown"
        local identifiers = GetPlayerIdentifiers(playerId)
        
        -- Add standard player fields
        table.insert(fields, {
            ["name"] = Config.Discord.lang.fields.playerName,
            ["value"] = playerName,
            ["inline"] = true
        })
        
        table.insert(fields, {
            ["name"] = Config.Discord.lang.fields.playerId,
            ["value"] = playerId,
            ["inline"] = true
        })
        
        -- Add identifiers
        if Config.Discord.identifiers.includeSteam then
            table.insert(fields, {
                ["name"] = Config.Discord.lang.fields.steam,
                ["value"] = identifiers.steam,
                ["inline"] = false
            })
        end
        
        if Config.Discord.identifiers.includeLicense then
            table.insert(fields, {
                ["name"] = Config.Discord.lang.fields.license,
                ["value"] = identifiers.license,
                ["inline"] = false
            })
        end
        
        if Config.Discord.identifiers.includeDiscord then
            table.insert(fields, {
                ["name"] = Config.Discord.lang.fields.discord,
                ["value"] = identifiers.discord,
                ["inline"] = false
            })
        end
        
        if Config.Discord.identifiers.includeIP then
            table.insert(fields, {
                ["name"] = Config.Discord.lang.fields.ip,
                ["value"] = identifiers.ip,
                ["inline"] = false
            })
        end
    end
    
    -- Add any extra fields provided
    if extraFields and type(extraFields) == "table" then
        for _, field in ipairs(extraFields) do
            table.insert(fields, field)
        end
    end
    
    -- Construct the final message
    local message = {
        {
            ["color"] = webhook.color or 16711680, 
            ["title"] = title,
            ["description"] = description,
            ["fields"] = fields,
            ["footer"] = {
                ["text"] = "sb_discord • " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }
    
    -- Send the message
    PerformHttpRequest(webhook.url, function(err, text, headers) 
        if err ~= 200 then
            print("[sb_discord] Failed to send Discord message. Error: " .. tostring(err))
        end
    end, 'POST', json.encode({
        username = webhook.name, 
        embeds = message, 
        avatar_url = webhook.avatar
    }), { ['Content-Type'] = 'application/json' })
end

-- Register exports
exports('sendToDiscord', Discord.sendToDiscord)

-- Announce initialization
if Config.Discord.active then
    print('[sb_discord] Discord webhook system initialized')
else
    print('[sb_discord] Discord webhook system loaded but inactive (disabled in config)')
end

-- Return the Discord module for use within this resource
return Discord 