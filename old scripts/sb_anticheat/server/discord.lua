Discord = {}

-- Helper function to validate data
local function validateWebhookData(data)
    -- Ensure webhook URL is valid
    if data.webhook == nil or data.webhook == "" then
        print("^1[ERROR]^7 Discord webhook URL is missing")
        return false
    end
    
    -- Ensure name is valid
    if data.name == nil or data.name == "" then
        data.name = "Anti-Cheat Alert"
    end
    
    return true
end

-- Process the HTTP response from Discord webhook
local function processWebhookResponse(err, text, headers)
    if err ~= 200 and err ~= 204 then
        print("^1[ERROR]^7 Discord webhook request failed: " .. tostring(err))
        if text then
            print("^1[ERROR]^7 Discord response: " .. tostring(text))
        end
    end
end

-- Format player info for webhook
local function formatPlayerInfo(source)
    if not source then return "System" end
    
    local playerName = GetPlayerName(source) or "Unknown"
    local playerIP = GetPlayerEndpoint(source) or "Unknown"
    local playerIdentifiers = {}
    
    for k, identifier in ipairs(GetPlayerIdentifiers(source)) do
        local idType = string.match(identifier, "([^:]+)")
        local idValue = string.sub(identifier, string.len(idType) + 2)
        playerIdentifiers[idType] = idValue
    end
    
    return {
        name = playerName,
        ip = playerIP,
        identifiers = playerIdentifiers,
        source = source
    }
end

-- Main function to send webhook messages
Discord.sendNewMessage = function(name, description, embeds, webhookurl, webhookname, webhookavatar, api)
    -- Set defaults from config
    local data = {
        webhook = webhookurl or Config.Discord.webhook,
        name = webhookname or Config.Discord.webhookname,
        avatar = webhookavatar or Config.Discord.webhookavatar,
        embeds = embeds
    }
    
    -- Validate data
    if not validateWebhookData(data) then
        print("^3[WARNING]^7 Discord webhook not sent - Invalid data")
        return false
    end
    
    -- Format default embeds if none provided
    if data.embeds == nil then
        data.embeds = {{
            color = 11342935,
            title = name or "Alert",
            description = description or "No description provided",
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    end
    
    -- Prepare payload
    local payload = {
        username = data.name,
        avatar_url = data.avatar,
        type = 'rich',
        embeds = data.embeds
    }
    
    -- Send to Discord or log locally based on configuration
    if Config.Discord.active or api == true then
        PerformHttpRequest(data.webhook, processWebhookResponse, 'POST', json.encode(payload), {
            ['Content-Type'] = 'application/json'
        })
        return true
    else
        -- Log to console if Discord is disabled
        print("^3[DISCORD WEBHOOK DISABLED]^7 " .. name .. ": " .. description)
        return false
    end
end

-- Simplified function to send player messages
Discord.sendMessage = function(source, description)
    local playerInfo = formatPlayerInfo(source)
    local title = playerInfo.name
    
    -- Enhance embed with player info
    local embed = {
        color = 11342935,
        title = title,
        description = description,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        fields = {}
    }
    
    -- Add steam if available
    if playerInfo.identifiers and playerInfo.identifiers.steam then
        table.insert(embed.fields, {
            name = "Steam",
            value = playerInfo.identifiers.steam,
            inline = true
        })
    end
    
    -- Add server ID
    table.insert(embed.fields, {
        name = "Server ID",
        value = tostring(source),
        inline = true
    })
    
    Discord.sendNewMessage(title, description, {embed})
end

-- Simplified export version for other resources
exports('discord', function()
    local self = {}
    
    -- Send a custom message with optional embeds
    self.sendMessage = function(webhookurl, webhookname, webhookavatar, name, description, embeds)
        return Discord.sendNewMessage(name, description, embeds, webhookurl, webhookname, webhookavatar, true)
    end
    
    -- Send a player alert with standard formatting
    self.sendPlayerAlert = function(source, reason, extraInfo)
        local playerInfo = formatPlayerInfo(source)
        local embed = {
            color = 15158332, -- Red color for alerts
            title = "Player Alert: " .. playerInfo.name,
            description = reason,
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            fields = {
                {
                    name = "Player ID",
                    value = tostring(source),
                    inline = true
                }
            }
        }
        
        -- Add steam if available
        if playerInfo.identifiers and playerInfo.identifiers.steam then
            table.insert(embed.fields, {
                name = "Steam ID",
                value = playerInfo.identifiers.steam,
                inline = true
            })
        end
        
        -- Add extra info if provided
        if extraInfo then
            table.insert(embed.fields, {
                name = "Additional Info",
                value = extraInfo
            })
        end
        
        return Discord.sendNewMessage("Anti-Cheat Alert", reason, {embed}, nil, nil, nil, true)
    end
    
    return self
end)