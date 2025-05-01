-- Initialize VorpCore
VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

-- Discord webhook integration
function SendDiscordMessage(source, model)
    if not Config.Discord.active then return end
    
    local name = GetPlayerName(source) or "Unknown"
    local steamid = GetPlayerIdentifier(source, 0) or "Unknown"
    
    local embed = {
        {
            ["color"] = 15105570, -- Yellow color
            ["title"] = "Blacklisted Object Detected",
            ["description"] = Config.Discord.lang.message .. model,
            ["footer"] = {
                ["text"] = "sb_objects | " .. os.date("%Y-%m-%d %H:%M:%S"),
            },
            ["fields"] = {
                {
                    ["name"] = "Player",
                    ["value"] = name,
                    ["inline"] = true
                },
                {
                    ["name"] = "Steam ID",
                    ["value"] = steamid,
                    ["inline"] = true
                },
                {
                    ["name"] = "Object Hash",
                    ["value"] = model,
                    ["inline"] = false
                }
            }
        }
    }
    
    PerformHttpRequest(Config.Discord.webhook, function(err, text, headers) end, 'POST', json.encode({
        username = Config.Discord.webhookname,
        embeds = embed,
        avatar_url = Config.Discord.webhookavatar
    }), { ['Content-Type'] = 'application/json' })
end

-- Handle object removed event
RegisterServerEvent("sb_objects:objectRemoved")
AddEventHandler("sb_objects:objectRemoved", function(model)
    local _source = source
    local playerName = GetPlayerName(_source) or "Unknown"
    
    -- Log to console
    -- print("^3[SB_OBJECTS]^7 " .. playerName .. " (ID: " .. _source .. ") tried to spawn blacklisted object: " .. model)
    
    -- Send to Discord if enabled
    SendDiscordMessage(_source, model)
end)

-- Startup message
Citizen.CreateThread(function()
    print("^2[sb_objects]^7 Object protection system initialized")
end)

-- Command to reload config (admin only)
RegisterCommand("objects_reload", function(source, args, rawCommand)
    local _source = source
    
    -- Check if player has permission
    if _source > 0 then
        local User = VorpCore.getUser(_source)
        if User then
            local Character = User.getUsedCharacter
            if Character and Character.group == "admin" then
                TriggerClientEvent("sb_objects:reloadConfig", -1)
                TriggerClientEvent("vorp:TipBottom", _source, "Object protection config reloaded", 3000)
                print("^2[sb_objects]^7 Object protection config reloaded by " .. GetPlayerName(_source))
            else
                TriggerClientEvent("vorp:TipBottom", _source, "You don't have permission to use this command", 3000)
            end
        end
    else
        -- Command run from server console
        TriggerClientEvent("sb_objects:reloadConfig", -1)
        print("^2[sb_objects]^7 Object protection config reloaded from console")
    end
end, false) 