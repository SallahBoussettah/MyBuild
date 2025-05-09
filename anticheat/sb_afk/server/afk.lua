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
            ["title"] = "AFK System",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "sb_afk | " .. os.date("%Y-%m-%d %H:%M:%S"),
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

if Config.AFK.active then
    local GetSteamID = function(src)
        local sid = GetPlayerIdentifiers(src)[1] or false
    
        if (sid == false or sid:sub(1,5) ~= "steam") then
            return false
        end
    
        return sid
    end

    -- Create AFK whitelist table if it doesn't exist
    local createTable = function()
        print("^2[sb_afk]^7 Setting up AFK whitelist table...")
        exports.oxmysql:query_async([[
            CREATE TABLE IF NOT EXISTS `sb_afk_whitelist` (
                `id` INT(20) NOT NULL AUTO_INCREMENT,
                `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
                `charidentifier` INT(30) NOT NULL DEFAULT '0',
                `afk` TINYINT(2) NOT NULL DEFAULT '0',
                PRIMARY KEY (`id`),
                INDEX `identifier` (`identifier`),
                UNIQUE INDEX `user_character` (`identifier`, `charidentifier`)
            ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;
        ]])
        
        print("^2[sb_afk]^7 AFK whitelist table setup complete")
    end

    -- Utility function to validate player data
    local function validatePlayerData(source, target, requireTarget)
        local _source = source
        
        -- Validate source player
        local sourceChar = VorpCore.getUser(_source).getUsedCharacter
        if not sourceChar then
            TriggerClientEvent("vorp:TipBottom", _source, "Character not found", 5000)
            return false
        end
        
        -- If no target is needed, return just source data
        if not requireTarget then
            return {
                source = _source,
                sourceChar = sourceChar
            }
        end
        
        -- Validate target is provided
        if target == nil or target == '' then
            TriggerClientEvent("vorp:TipBottom", _source, Config.AFK.lang.whitelist.id, 5000)
            return false
        end
        
        -- Get target user
        local User = VorpCore.getUser(target)
        if not User then
            TriggerClientEvent("vorp:TipBottom", _source, "Target player not found", 5000)
            return false
        end
        
        -- Get target character
        local targetChar = User.getUsedCharacter
        if not targetChar then
            TriggerClientEvent("vorp:TipBottom", _source, "Target character not found", 5000)
            return false
        end
        
        -- Get steam ID
        local steamid = GetSteamID(target)
        if not steamid then
            TriggerClientEvent("vorp:TipBottom", _source, "Target player needs Steam ID", 5000)
            return false
        end
        
        return {
            source = _source,
            target = target,
            sourceChar = sourceChar,
            steamid = steamid,
            charId = targetChar.charIdentifier
        }
    end

    -- Create database table on resource start
    Citizen.CreateThread(function()
        createTable()
    end)

    -- Process kick events
    RegisterServerEvent("sb_afk:kick")
    AddEventHandler("sb_afk:kick", function(reason)
        local _source = source
        local playerName = GetPlayerName(_source) or "Unknown"
        
        -- Log to console
        print("^1[SB_AFK]^7 " .. playerName .. " (ID: " .. _source .. ") was kicked. Reason: " .. reason)
        
        -- Send to Discord if enabled
        SendDiscordMessage(_source, Config.Discord.lang.kick .. reason)
        
        -- Perform the actual kick
        DropPlayer(_source, Config.Discord.lang.kick .. reason)
    end)

    -- Command to add a player to the AFK whitelist
    RegisterCommand("afk-addWhitelist", function(source, args, rawCommand)
        local data = validatePlayerData(source, args[1], true)
        if not data then return end
        
        -- Check permission
        if data.sourceChar.group ~= 'admin' then
            TriggerClientEvent("vorp:TipBottom", data.source, "You don't have permission to use this command", 5000)
            return
        end

        -- Check if already exists and update, otherwise insert
        exports.oxmysql:insert("INSERT INTO sb_afk_whitelist (identifier, charidentifier, afk) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE afk = 1", 
            {data.steamid, data.charId, 1}, function(insertId)
            if insertId or insertId == 0 then -- Some drivers return 0 for non-insert but successful operations
                TriggerClientEvent("vorp:TipBottom", data.source, Config.AFK.lang.whitelist.wladded, 5000)
                TriggerClientEvent("sb_afk:updateafk", data.target, false)
            else
                TriggerClientEvent("vorp:TipBottom", data.source, Config.AFK.lang.whitelist.err, 5000)
            end
        end)
    end)

    -- Command to remove a player from the AFK whitelist
    RegisterCommand("afk-removeWhitelist", function(source, args, rawCommand)
        local data = validatePlayerData(source, args[1], true)
        if not data then return end
        
        -- Check permission
        if data.sourceChar.group ~= 'admin' then
            TriggerClientEvent("vorp:TipBottom", data.source, "You don't have permission to use this command", 5000)
            return
        end

        exports.oxmysql:update("UPDATE sb_afk_whitelist SET afk = ? WHERE identifier = ? AND charidentifier = ?", 
            {0, data.steamid, data.charId}, function(affectedRows)
            if affectedRows then
                TriggerClientEvent("vorp:TipBottom", data.source, Config.AFK.lang.whitelist.wlremoved, 5000)
                TriggerClientEvent("sb_afk:updateafk", data.target, true)
            else
                TriggerClientEvent("vorp:TipBottom", data.source, Config.AFK.lang.whitelist.err, 5000)
            end
        end)
    end)

    -- Check if player is in the AFK whitelist
    RegisterServerEvent('sb_afk:rolecheck')
    AddEventHandler('sb_afk:rolecheck', function()
        local data = validatePlayerData(source, nil, false)
        if not data then return end
        
        local _source = data.source
        local steamid = GetSteamID(_source)
        if not steamid then return end
        
        local charId = data.sourceChar.charIdentifier

        exports.oxmysql:query("SELECT afk FROM sb_afk_whitelist WHERE identifier = ? AND charidentifier = ? AND afk > 0 LIMIT 1", 
            {steamid, charId}, function(result)
            local isWhitelisted = result and result[1] and result[1].afk > 0
            TriggerClientEvent("sb_afk:rolecheck-r", _source, isWhitelisted)
        end)
    end)
end 