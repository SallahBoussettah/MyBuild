WebhookAlert = {}

-- Function to send new Discord webhook message with customization options
WebhookAlert.sendNewMessage = function(name, description, embeds, customWebhook, customName, customAvatar, forceApi)
    local hookName = Config.Webhook.webhookName
    local avatar = Config.Webhook.webhookAvatar
    local webhook = Config.Webhook.webhookUrl

    if customWebhook ~= nil then
        webhook = customWebhook
    end

    if customAvatar ~= nil then
        avatar = customAvatar
    end

    if customName ~= nil then
        hookName = customName
    end

    if embeds == nil then
        embeds = {{
            color = 15158332, -- Red color for alerts
            title = name,
            description = description,
            footer = {
                text = "RedM Guardian | " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    end

    local payload = {
        username = hookName,
        avatar_url = avatar,
        type = 'rich',
        embeds = embeds
    }

    if Config.Webhook.active or forceApi == true then
        PerformHttpRequest(webhook, function(err, text, headers)end, 'POST', json.encode(payload), {
            ['Content-Type'] = 'application/json'
        })
    else
        print("[RedM Guardian]", name, description)
    end
end

-- Simplified function to send a message for a specific player
WebhookAlert.sendMessage = function(_source, description)
    local name
    if _source then
        name = GetPlayerName(_source) or "Unknown Player"
    else
        name = "System Alert"
    end
    WebhookAlert.sendNewMessage(name, description)
end

-- Export function for other resources to use
exports('webhookAlert', function()
    local self = {}

    self.sendMessage = function(webhook, webhookName, webhookAvatar, name, description, embeds)
        WebhookAlert.sendNewMessage(name, description, embeds, webhook, webhookName, webhookAvatar, true)
    end

    return self
end) 