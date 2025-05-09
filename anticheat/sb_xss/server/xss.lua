--[[
    XSS Protection System - Server Side
    Prevents username-based XSS attacks and validates player names
]]--

-- Only run if the feature is enabled in config
if Config.XSS.active then
    -- Function to check if Discord integration is available
    local function sendDiscordNotification(playerId, reason)
        if Config.Discord.active then
            -- Check if sb_discord is available
            if GetResourceState('sb_discord') == 'started' then
                -- Use the discord export
                exports['sb_discord']:sendToDiscord(
                    Config.Discord.webhookType,
                    playerId,
                    Config.Discord.lang.kickTitle,
                    reason,
                    {
                        {
                            ["name"] = "Original Username",
                            ["value"] = GetPlayerName(playerId) or "Unknown",
                            ["inline"] = false
                        }
                    },
                    Config.Discord.logLevel
                )
            else
                print("[sb_xss] Warning: sb_discord resource not found. Discord notifications disabled.")
            end
        end
    end
    
    -- Function to validate username
    local function isUsernameValid(username)
        -- Check username length
        if username and #username > Config.XSS.maxUsernameLength then
            return false, "Username exceeds maximum length"
        end
        
        -- Check for XSS patterns
        if username then
            for _, pattern in ipairs(Config.XSS.patterns) do
                if string.match(username, pattern) then
                    return false, "Username contains suspicious pattern: " .. pattern
                end
            end
        end
        
        return true, nil
    end
    
    -- Check players when they connect
    AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
        local source = source
        local username = GetPlayerName(source)
        
        -- Defer connection while we validate
        deferrals.defer()
        
        -- Update connection status
        deferrals.update(Config.XSS.lang.update)
        
        -- Short wait to ensure username is available
        Citizen.Wait(500)
        
        -- Validate username
        local isValid, reason = isUsernameValid(username)
        
        -- If username is invalid and we're configured to block injection attempts
        if not isValid and Config.XSS.blockInjectionAttempts then
            -- Log to console
            print("[sb_xss] Player blocked - Potential XSS injection: " .. (username or "Unknown") .. " - Reason: " .. reason)
            
            -- Send Discord notification
            sendDiscordNotification(source, Config.XSS.lang.reason .. ": " .. reason)
            
            -- Kick the player
            deferrals.done(Config.XSS.lang.kick)
            return
        end
        
        -- Allow the connection
        deferrals.done()
    end)
    
    print('[sb_xss] XSS protection initialized')
else
    print('[sb_xss] XSS protection disabled in config')
end 