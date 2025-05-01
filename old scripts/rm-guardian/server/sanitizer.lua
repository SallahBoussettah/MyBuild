-- Player name and input sanitization system

if Config.Sanitizer.active then
    -- Validate player on connection
    AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
        local _source = source
        local playerName = GetPlayerName(_source)
        
        deferrals.defer()
        deferrals.update(Config.Sanitizer.lang.update)
        
        -- Wait to ensure all checks can be performed
        Citizen.Wait(500)
        
        -- Check for dangerous characters in the player name
        local forbiddenCharacters = {'%', '<', '>', '{', '}', ';', '"', "'", '\\'}
        local hasForbiddenChar = false
        
        for _, char in ipairs(forbiddenCharacters) do
            if string.find(playerName, char, 1, true) then
                hasForbiddenChar = true
                break
            end
        end
        
        -- Check for very long names that might indicate injection attempts
        local isTooLong = string.len(playerName) > 40
        
        -- Check for SQL injection patterns
        local hasSQLPattern = string.find(playerName:lower(), "select", 1, true) or 
                             string.find(playerName:lower(), "insert", 1, true) or
                             string.find(playerName:lower(), "update", 1, true) or
                             string.find(playerName:lower(), "delete", 1, true) or
                             string.find(playerName:lower(), "drop", 1, true) or
                             string.find(playerName:lower(), "union", 1, true)
        
        -- Check for HTML and script injection
        local hasScriptTags = string.find(playerName:lower(), "<script", 1, true) or
                             string.find(playerName:lower(), "</script", 1, true) or
                             string.find(playerName:lower(), "javascript:", 1, true)
        
        if hasForbiddenChar or isTooLong or hasSQLPattern or hasScriptTags then
            -- Log the validation failure
            WebhookAlert.sendMessage(_source, Config.Sanitizer.lang.reason .. ": " .. playerName)
            
            -- Kick player with reason
            deferrals.done(Config.Sanitizer.lang.kick)
        else
            -- Allow connection if validation passes
            deferrals.done()
        end
    end)
    
    -- Additional checks for text input from players (chat, etc.)
    -- Note: This part would need to be integrated with your chat resource
    -- This is an example of how it could be implemented
    
    -- Example event for handling chat or other text input
    RegisterNetEvent('rmg:validateTextInput')
    AddEventHandler('rmg:validateTextInput', function(text)
        local _source = source
        
        -- The same checks as above could be applied to the text input
        local forbiddenCharacters = {'%', '<', '>', '{', '}', ';', '"', "'", '\\'}
        local hasForbiddenChar = false
        
        for _, char in ipairs(forbiddenCharacters) do
            if string.find(text, char, 1, true) then
                hasForbiddenChar = true
                break
            end
        end
        
        local hasSQLPattern = string.find(text:lower(), "select", 1, true) or 
                             string.find(text:lower(), "insert", 1, true) or
                             string.find(text:lower(), "update", 1, true) or
                             string.find(text:lower(), "delete", 1, true) or
                             string.find(text:lower(), "drop", 1, true) or
                             string.find(text:lower(), "union", 1, true)
        
        local hasScriptTags = string.find(text:lower(), "<script", 1, true) or
                             string.find(text:lower(), "</script", 1, true) or
                             string.find(text:lower(), "javascript:", 1, true)
        
        if hasForbiddenChar or hasSQLPattern or hasScriptTags then
            -- Report but don't kick (optional)
            WebhookAlert.sendMessage(_source, "Potentially harmful text input: " .. text)
            return false
        end
        
        return true
    end)
end 