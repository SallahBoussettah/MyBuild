if Config.AFK.active then
    local GetSteamID = function(src)
        local sid = GetPlayerIdentifiers(src)[1] or false
    
        if (sid == false or sid:sub(1,5) ~= "steam") then
            return false
        end
    
        return sid
    end

    local createTable = function()
        print("^2[sb_anticheat]^7 Setting up AFK whitelist table...")
        exports.oxmysql:query_async([[
            CREATE TABLE IF NOT EXISTS `bccacwl` (
                `id` INT(20) NOT NULL AUTO_INCREMENT,
                `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
                `charidentifier` INT(30) NOT NULL DEFAULT '0',
                `afk` TINYINT(2) NOT NULL DEFAULT '0',
                PRIMARY KEY (`id`),
                INDEX `identifier` (`identifier`),
                UNIQUE INDEX `user_character` (`identifier`, `charidentifier`)
            ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;
        ]])
        
        print("^2[sb_anticheat]^7 AFK whitelist table setup complete")
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

    Citizen.CreateThread(function()
        createTable()
    end)

    RegisterCommand("ac-addAFKWL", function(source, args, rawCommand)
        local data = validatePlayerData(source, args[1], true)
        if not data then return end
        
        -- Check permission
        if data.sourceChar.group ~= 'admin' then
            TriggerClientEvent("vorp:TipBottom", data.source, "You don't have permission to use this command", 5000)
            return
        end

        -- Check if already exists and update, otherwise insert
        exports.oxmysql:insert("INSERT INTO bccacwl (identifier, charidentifier, afk) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE afk = 1", 
            {data.steamid, data.charId, 1}, function(insertId)
            if insertId or insertId == 0 then -- Some drivers return 0 for non-insert but successful operations
                TriggerClientEvent("vorp:TipBottom", data.source, Config.AFK.lang.whitelist.wladded, 5000)
                TriggerClientEvent("bccac-updateafk", data.target, false)
            else
                TriggerClientEvent("vorp:TipBottom", data.source, Config.AFK.lang.whitelist.err, 5000)
            end
        end)
    end)

    RegisterCommand("ac-removeAFKWL", function(source, args, rawCommand)
        local data = validatePlayerData(source, args[1], true)
        if not data then return end
        
        -- Check permission
        if data.sourceChar.group ~= 'admin' then
            TriggerClientEvent("vorp:TipBottom", data.source, "You don't have permission to use this command", 5000)
            return
        end

        exports.oxmysql:update("UPDATE bccacwl SET afk = ? WHERE identifier = ? AND charidentifier = ?", 
            {0, data.steamid, data.charId}, function(affectedRows)
            if affectedRows then
                TriggerClientEvent("vorp:TipBottom", data.source, Config.AFK.lang.whitelist.wlremoved, 5000)
                TriggerClientEvent("bccac-updateafk", data.target, true)
            else
                TriggerClientEvent("vorp:TipBottom", data.source, Config.AFK.lang.whitelist.err, 5000)
            end
        end)
    end)

    RegisterServerEvent('bccac-rolecheck')
    AddEventHandler('bccac-rolecheck', function()
        local data = validatePlayerData(source, nil, false)
        if not data then return end
        
        local _source = data.source
        local steamid = GetSteamID(_source)
        if not steamid then return end
        
        local charId = data.sourceChar.charIdentifier

        exports.oxmysql:query("SELECT afk FROM bccacwl WHERE identifier = ? AND charidentifier = ? AND afk > 0 LIMIT 1", 
            {steamid, charId}, function(result)
            local isWhitelisted = result and result[1] and result[1].afk > 0
            TriggerClientEvent("bccac-rolecheck-r", _source, isWhitelisted)
        end)
    end)
end