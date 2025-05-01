--[[
    Database Role Protection - Server Side
    Monitors for unauthorized changes to admin roles in the database
]]--

-- Only run if the feature is enabled in config
if Config.DBRoles.active then
    -- Initialize storage for role tracking
    local validRoles = {}
    local initialScanComplete = false
    
    -- Function to check if Discord integration is available
    local function sendDiscordNotification(data)
        if Config.Discord.active then
            -- Check if sb_discord is available
            if GetResourceState('sb_discord') == 'started' then
                -- Prepare extra fields for the notification
                local extraFields = {}
                
                -- Add player name if available
                if data.playerName then
                    table.insert(extraFields, {
                        ["name"] = Config.DBRoles.lang.discord.playerName,
                        ["value"] = data.playerName,
                        ["inline"] = true
                    })
                end
                
                -- Add character ID if available
                if data.charId then
                    table.insert(extraFields, {
                        ["name"] = Config.DBRoles.lang.discord.character,
                        ["value"] = data.charId,
                        ["inline"] = true
                    })
                end
                
                -- Add role information
                table.insert(extraFields, {
                    ["name"] = Config.DBRoles.lang.discord.oldGroup,
                    ["value"] = data.oldGroup or "None",
                    ["inline"] = true
                })
                
                table.insert(extraFields, {
                    ["name"] = Config.DBRoles.lang.discord.newGroup,
                    ["value"] = data.newGroup or "None",
                    ["inline"] = true
                })
                
                -- Add action taken if any
                if data.action then
                    table.insert(extraFields, {
                        ["name"] = Config.DBRoles.lang.discord.action,
                        ["value"] = data.action,
                        ["inline"] = false
                    })
                end
                
                -- Use the discord export
                exports['sb_discord']:sendToDiscord(
                    Config.Discord.webhookType,
                    nil, -- Not player related directly
                    Config.DBRoles.lang.discord.title,
                    Config.DBRoles.lang.discord.description,
                    extraFields,
                    Config.Discord.logLevel
                )
            else
                print("[sb_roles] Warning: sb_discord resource not found. Discord notifications disabled.")
            end
        end
    end
    
    -- Function to verify role change is valid
    local function isRoleChangeValid(identifier, newRole)
        -- Always valid if not a protected role
        if not table.concat(Config.DBRoles.protectedRoles, ","):find(newRole) then
            return true
        end
        
        -- Check against the appropriate method
        if Config.DBRoles.method == "whitelist" then
            -- Check if this identifier is in the whitelist with this role
            return Config.DBRoles.whitelistedAdmins[identifier] == newRole
        else -- snapshot method
            -- Check if this identifier had this role in our initial snapshot
            return validRoles[identifier] == newRole
        end
    end
    
    -- Function to get character info from database
    local function getCharacterInfo(identifier, callback)
        local query = string.format(
            "SELECT %s, firstname, lastname FROM %s WHERE %s = ?",
            Config.DBRoles.database.characterIdColumn,
            Config.DBRoles.database.characterTable,
            Config.DBRoles.database.characterIdentifier
        )
        
        MySQL.Async.fetchAll(query, {identifier}, function(results)
            if results and #results > 0 then
                local charInfo = {
                    id = results[1][Config.DBRoles.database.characterIdColumn],
                    name = results[1].firstname .. " " .. results[1].lastname
                }
                callback(charInfo)
            else
                callback(nil)
            end
        end)
    end
    
    -- Function to revert a role change
    local function revertRoleChange(identifier, oldGroup)
        if Config.Discord.actions.revert then
            -- Wrap column name in backticks to handle reserved words
            local query = string.format(
                "UPDATE %s SET `%s` = ? WHERE %s = ?",
                Config.DBRoles.database.table,
                Config.DBRoles.database.groupColumn,
                Config.DBRoles.database.identifier
            )
            
            MySQL.Async.execute(query, {oldGroup or "user", identifier}, function(rowsChanged)
                if rowsChanged > 0 then
                    print("[sb_roles] Reverted unauthorized role change for " .. identifier .. " back to " .. (oldGroup or "user"))
                else
                    print("[sb_roles] Failed to revert role change for " .. identifier)
                end
            end)
            
            return "Reverted change to " .. (oldGroup or "user")
        end
        
        return "No action taken (revert disabled)"
    end
    
    -- Function to scan for role changes
    local function scanRoles()
        -- Get all user roles from database
        -- Wrap column name in backticks to handle reserved words
        local query = string.format(
            "SELECT %s, `%s` FROM %s",
            Config.DBRoles.database.identifier,
            Config.DBRoles.database.groupColumn,
            Config.DBRoles.database.table
        )
        
        MySQL.Async.fetchAll(query, {}, function(results)
            if not results then
                print("[sb_roles] Error fetching roles from database")
                return
            end
            
            -- First run - create snapshot of valid roles
            if not initialScanComplete and Config.DBRoles.method == "snapshot" then
                for _, row in ipairs(results) do
                    local identifier = row[Config.DBRoles.database.identifier]
                    local group = row[Config.DBRoles.database.groupColumn]
                    
                    -- Only track protected roles
                    if table.concat(Config.DBRoles.protectedRoles, ","):find(group) then
                        validRoles[identifier] = group
                    end
                end
                
                initialScanComplete = true
                print("[sb_roles] Initial role snapshot created - monitoring " .. #Config.DBRoles.protectedRoles .. " protected roles")
                return
            end
            
            -- Check each user in the database
            for _, row in ipairs(results) do
                local identifier = row[Config.DBRoles.database.identifier]
                local currentGroup = row[Config.DBRoles.database.groupColumn]
                
                -- Only check protected roles
                if table.concat(Config.DBRoles.protectedRoles, ","):find(currentGroup) then
                    -- Check if this is a valid role assignment
                    if not isRoleChangeValid(identifier, currentGroup) then
                        -- Get character info for better logging
                        getCharacterInfo(identifier, function(charInfo)
                            -- Prepare notification data
                            local data = {
                                steam = identifier,
                                charId = charInfo and charInfo.id or "Unknown",
                                playerName = charInfo and charInfo.name or "Unknown",
                                oldGroup = validRoles[identifier] or "user",
                                newGroup = currentGroup
                            }
                            
                            -- Log the unauthorized change
                            if Config.Discord.actions.log then
                                print("[sb_roles] Unauthorized role change detected!")
                                print("  Player: " .. (charInfo and charInfo.name or "Unknown"))
                                print("  Identifier: " .. identifier)
                                print("  Character: " .. (charInfo and charInfo.id or "Unknown"))
                                print("  Previous role: " .. (validRoles[identifier] or "user"))
                                print("  New role: " .. currentGroup)
                            end
                            
                            -- Revert the change
                            data.action = revertRoleChange(identifier, validRoles[identifier])
                            
                            -- Send notification
                            if Config.Discord.actions.notify then
                                sendDiscordNotification(data)
                            end
                        end)
                    end
                end
            end
        end)
    end
    
    -- Start the monitoring process
    Citizen.CreateThread(function()
        -- Wait for the server to fully start
        Citizen.Wait(10000)
        
        -- Do the initial scan to create a snapshot of valid roles
        scanRoles()
        
        -- Start regular monitoring
        while true do
            Citizen.Wait(Config.DBRoles.checkInterval)
            scanRoles()
        end
    end)
    
    print('[sb_roles] Database role protection initialized')
else
    print('[sb_roles] Database role protection disabled in config')
end 