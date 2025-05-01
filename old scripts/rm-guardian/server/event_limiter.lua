-- Event rate limiting system to prevent event spamming

if Config.EventLimiter.active then
    -- Track event invocations per player
    local playerEvents = {}
    local eventCount = {}
    
    -- Input violation tracking
    local inputViolations = {}
    
    -- Add a new handler to monitor and rate-limit all server events
    AddEventHandler('playerDropped', function()
        local _source = source
        playerEvents[_source] = nil
        inputViolations[_source] = nil
    end)
    
    -- Handle input violations from the client
    RegisterNetEvent('rmg:inputViolation')
    AddEventHandler('rmg:inputViolation', function(clickCount, controlCode)
        local _source = source
        
        -- Initialize tracking for this player
        if not inputViolations[_source] then
            inputViolations[_source] = {
                count = 0,
                lastViolation = os.time(),
                warnings = 0
            }
        end
        
        -- Log high click counts for monitoring
        local currentTime = os.time()
        
        -- Reset if it's been a while since last violation
        if currentTime - inputViolations[_source].lastViolation > 60 then
            inputViolations[_source].count = 0
            inputViolations[_source].warnings = 0
        end
        
        -- Update violation count
        inputViolations[_source].count = inputViolations[_source].count + 1
        inputViolations[_source].lastViolation = currentTime
        
        -- Get control name for better logging
        local controlName = "Unknown"
        local controls = {
            [0x07CE1E61] = "Left Mouse Button",
            [0xF84FA74F] = "Right Mouse Button",
            [0x8FFC75D6] = "Spacebar",
            [0xD9D0E1C0] = "Enter",
            [0xCEFD9220] = "E key",
            [0x8CC9CD42] = "F key"
        }
        
        if controls[controlCode] then
            controlName = controls[controlCode]
        end
        
        -- Log very high values but don't kick immediately
        if clickCount > Config.InputLimit.maxViolations * 3 then
            -- Send webhook alert with details
            local message = string.format(
                "Input spam detected: Player %s (%d) has unusual input rate (%d clicks on %s)",
                GetPlayerName(_source) or "Unknown",
                _source,
                clickCount,
                controlName
            )
            
            WebhookAlert.sendMessage(_source, message)
            
            -- Increase warning count
            inputViolations[_source].warnings = inputViolations[_source].warnings + 1
            
            -- Only kick if pattern persists after multiple warnings
            if inputViolations[_source].warnings >= 3 and clickCount > Config.InputLimit.maxViolations * 4 then
                local kickReason = Config.InputLimit.lang.kickReason
                
                -- Give the player a temporary exemption
                -- Only really kick on extreme and persistent cases
                if inputViolations[_source].warnings >= 5 and clickCount > Config.InputLimit.maxViolations * 5 then
                    KickPlayer(_source, kickReason)
                else
                    -- Just send a warning to the player
                    TriggerClientEvent('vorp:TipRight', _source, "WARNING: Input rate too high, please slow down.", 5000)
                    
                    -- Create a temporary exemption for this player
                    TriggerClientEvent("rmg:disableInputMonitoring", _source, 30000) -- 30 second temp exemption
                end
            end
        end
    end)
    
    -- Register a handler to monitor all events
    RegisterNetEvent('rmg:monitorEvent')
    AddEventHandler('rmg:monitorEvent', function(eventName, eventData)
        local _source = source
        
        -- Check if event is whitelisted
        for _, whitelistedEvent in ipairs(Config.EventLimiter.whitelistedEvents) do
            if eventName == whitelistedEvent then
                return
            end
        end
        
        -- Initialize tracking for this player
        if not playerEvents[_source] then
            playerEvents[_source] = {}
        end
        
        -- Initialize tracking for this event
        if not playerEvents[_source][eventName] then
            playerEvents[_source][eventName] = {
                count = 0,
                lastReset = os.time(),
                data = {}
            }
        end
        
        -- Track event data for analysis
        table.insert(playerEvents[_source][eventName].data, eventData or "none")
        if #playerEvents[_source][eventName].data > 10 then
            table.remove(playerEvents[_source][eventName].data, 1)
        end
        
        -- Increment counter
        playerEvents[_source][eventName].count = playerEvents[_source][eventName].count + 1
        
        -- Reset counter after 1 second if needed
        if os.time() - playerEvents[_source][eventName].lastReset >= 1 then
            playerEvents[_source][eventName].count = 1
            playerEvents[_source][eventName].lastReset = os.time()
            return
        end
        
        -- Check for excessive events
        if playerEvents[_source][eventName].count > Config.EventLimiter.threshold then
            -- Convert event data to string for logging
            local eventDataString = "unknown"
            if playerEvents[_source][eventName].data and #playerEvents[_source][eventName].data > 0 then
                if type(playerEvents[_source][eventName].data[1]) == "table" then
                    eventDataString = SafeJsonEncode(playerEvents[_source][eventName].data[1])
                else
                    eventDataString = tostring(playerEvents[_source][eventName].data[1])
                end
            end
            
            -- Format kick reason with placeholders
            local reason = string.format(
                Config.EventLimiter.lang.kickReason,
                GetPlayerName(_source) or "Unknown",
                eventName,
                eventDataString
            )
            
            -- Log the violation and kick the player
            WebhookAlert.sendMessage(_source, reason)
            KickPlayer(_source, reason)
        end
    end)
    
    -- Helper function to automatically monitor triggered events
    local originalTriggerEvent = TriggerEvent
    TriggerEvent = function(eventName, ...)
        originalTriggerEvent(eventName, ...)
        
        if eventName:sub(1, 4) ~= "rmg:" then -- Don't monitor our own events
            local source = source
            if source and source > 0 then
                local args = {...}
                local eventData = args[1] or "none"
                TriggerEvent('rmg:monitorEvent', eventName, eventData)
            end
        end
    end
    
    -- Command to exempt players from input monitoring temporarily
    RegisterCommand('input_exempt', function(source, args, rawCommand)
        local _source = source
        
        -- Check if the user has admin permissions
        local User = VorpCore.getUser(_source)
        if User and User.getGroup then
            local group = User.getGroup
            local isAdmin = false
            
            for _, role in ipairs(Config.Database.privilegedRoles) do
                if group == role then
                    isAdmin = true
                    break
                end
            end
            
            if isAdmin then
                local targetId = tonumber(args[1])
                local duration = tonumber(args[2]) or 60 -- Default 1 minute
                
                if targetId then
                    -- Clear violations
                    if inputViolations[targetId] then
                        inputViolations[targetId].count = 0
                        inputViolations[targetId].warnings = 0
                    end
                    
                    -- Disable input monitoring for the specified duration
                    TriggerClientEvent("rmg:disableInputMonitoring", targetId, duration * 1000)
                    
                    TriggerClientEvent('vorp:TipRight', _source, "Player " .. targetId .. " exempted from input monitoring for " .. duration .. " seconds", 5000)
                else
                    TriggerClientEvent('vorp:TipRight', _source, "Usage: /input_exempt [player_id] [duration_seconds]", 5000)
                end
            end
        end
    end, false)
end 