-- Initialize VorpCore
VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

-- Discord webhook integration
function SendDiscordMessage(source, type, details)
    if not Config.Discord.active then return end
    
    local name = GetPlayerName(source) or "Unknown"
    local steamid = GetPlayerIdentifier(source, 0) or "Unknown"
    
    local title = "Unknown Violation"
    local description = "A violation was detected."
    local color = 16711680 -- Red color
    
    if type == "weapon" then
        title = "Blacklisted Weapon Detected"
        description = "Player tried to use a blacklisted weapon: " .. details
    elseif type == "health" then
        title = "Health Hack Detected"
        description = "Player's health exceeded maximum: " .. details .. " (max: " .. Config.PlayerStatus.health .. ")"
    end
    
    local embed = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = description,
            ["footer"] = {
                ["text"] = "sb_weapons | " .. os.date("%Y-%m-%d %H:%M:%S"),
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

-- Process blacklisted weapon detection
RegisterServerEvent("sb_weapons:blacklistedWeaponDetected")
AddEventHandler("sb_weapons:blacklistedWeaponDetected", function(weaponHash)
    local _source = source
    local playerName = GetPlayerName(_source) or "Unknown"
    
    -- Log to console
    print("^1[SB_WEAPONS]^7 " .. playerName .. " (ID: " .. _source .. ") tried to use blacklisted weapon: " .. weaponHash)
    
    -- Send notification to player
    if Config.Weapons.notification.enabled then
        TriggerClientEvent("sb_weapons:notify", _source, Config.Weapons.notification.message)
    end
    
    -- Send to Discord if enabled
    SendDiscordMessage(_source, "weapon", weaponHash)
end)

-- Process health hack detection
RegisterServerEvent("sb_weapons:healthHackDetected")
AddEventHandler("sb_weapons:healthHackDetected", function(health)
    local _source = source
    local playerName = GetPlayerName(_source) or "Unknown"
    
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
    print("^1[SB_WEAPONS]^7 " .. playerName .. " (ID: " .. _source .. ") health hack detected: " .. health .. " (max: " .. Config.PlayerStatus.health .. ")")
    
    -- Send to Discord if enabled
    SendDiscordMessage(_source, "health", health)
    
    -- Kick the player
    DropPlayer(_source, Config.Discord.lang.kick .. Config.PlayerStatus.lang.kickreason)
    
    -- Cleanup old kick records to prevent memory leaks
    Citizen.CreateThread(function()
        local currentTime = os.time()
        for identifier, kickTime in pairs(recentKicks) do
            if (currentTime - kickTime) > 60 then -- Remove records older than 1 minute
                recentKicks[identifier] = nil
            end
        end
    end)
end)

-- Admin command to set max health (for testing and configuration)
RegisterCommand("setmaxhealth", function(source, args, rawCommand)
    local _source = source
    
    -- Only allow admins to use this command
    if _source > 0 then
        local User = VorpCore.getUser(_source)
        if User then
            local Character = User.getUsedCharacter
            if Character and Character.group == "admin" then
                if args[1] and tonumber(args[1]) then
                    local newMaxHealth = tonumber(args[1])
                    -- Update config
                    Config.PlayerStatus.health = newMaxHealth
                    -- Notify admin
                    TriggerClientEvent("vorp:TipBottom", _source, "Max health set to: " .. newMaxHealth, 5000)
                    -- Log change
                    print("^2[sb_weapons]^7 Max health set to: " .. newMaxHealth .. " by " .. GetPlayerName(_source))
                else
                    TriggerClientEvent("vorp:TipBottom", _source, "Usage: /setmaxhealth [value]", 5000)
                end
            else
                TriggerClientEvent("vorp:TipBottom", _source, "You don't have permission to use this command", 5000)
            end
        end
    else
        -- Command run from server console
        if args[1] and tonumber(args[1]) then
            local newMaxHealth = tonumber(args[1])
            Config.PlayerStatus.health = newMaxHealth
            print("^2[sb_weapons]^7 Max health set to: " .. newMaxHealth .. " from console")
        else
            print("^2[sb_weapons]^7 Usage: setmaxhealth [value]")
        end
    end
end, false)

-- Startup message
Citizen.CreateThread(function()
    print("^2[sb_weapons]^7 Weapons and health protection system initialized")
end) 