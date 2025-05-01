VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

-- Main kick event that will be used by all anti-cheat modules
RegisterServerEvent("rmg:removePlayer")
AddEventHandler("rmg:removePlayer", function(reason)
    local _source = source
    WebhookAlert.sendMessage(_source, Config.Webhook.lang.kick .. reason)
    DropPlayer(_source, Config.Webhook.lang.kick .. reason)
end)

-- Global function to handle kicks with logging
function KickPlayer(playerId, reason)
    if playerId and reason then
        WebhookAlert.sendMessage(playerId, Config.Webhook.lang.kick .. reason)
        DropPlayer(playerId, Config.Webhook.lang.kick .. reason)
    end
end

-- Server-side version check
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    print('^2RedM Guardian^7: Anti-cheat system initialized v1.0.0')
end) 