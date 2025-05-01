-- Initialize VorpCore
VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

-- Discord webhook integration
function SendDiscordMessage(source, message)
    if not Config.Discord.active then return end
    
    local name = GetPlayerName(source) or "Unknown"
    local steamid = GetPlayerIdentifier(source, 0) or "Unknown"
    
    local embed = {
        {
            ["color"] = 16711680, -- Red color
            ["title"] = "Key Blacklist Detection",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "sb_keys | " .. os.date("%Y-%m-%d %H:%M:%S"),
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

-- Tracking for player kicks to prevent abuse
local recentKicks = {}

-- Process kick events
RegisterServerEvent("sb_keys:kick")
AddEventHandler("sb_keys:kick", function(reason)
    local _source = source
    local playerName = GetPlayerName(_source) or "Unknown"
    
    -- Validate reason
    if not reason or reason == "" then
        reason = "Key blacklist violation"
    end
    
    -- Check if player has been recently kicked to prevent event spam
    local playerIdentifier = GetPlayerIdentifier(_source, 0)
    if playerIdentifier then
        local currentTime = os.time()
        if recentKicks[playerIdentifier] and (currentTime - recentKicks[playerIdentifier]) < 5 then
            -- Duplicate kick request within 5 seconds, ignore
            return
        end
        recentKicks[playerIdentifier] = currentTime
    end
    
    -- Log to console
    print("^1[SB_KEYS]^7 " .. playerName .. " (ID: " .. _source .. ") was kicked. Reason: " .. reason)
    
    -- Send to Discord if enabled
    SendDiscordMessage(_source, Config.Discord.lang.kick .. reason)
    
    -- Perform the actual kick
    DropPlayer(_source, Config.Discord.lang.kick .. reason)
    
    -- Cleanup old kick records every 30 seconds to prevent memory leaks
    Citizen.CreateThread(function()
        local currentTime = os.time()
        for identifier, kickTime in pairs(recentKicks) do
            if (currentTime - kickTime) > 60 then -- Remove records older than 1 minute
                recentKicks[identifier] = nil
            end
        end
    end)
end)

-- Startup message
Citizen.CreateThread(function()
    print("^2[sb_keys]^7 Key blacklist system initialized")
end) 