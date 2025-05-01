-- Command monitoring system
Citizen.CreateThread(function()
    if Config.CommandBlacklist.active then
        -- Override the default command processor to check for blacklisted commands
        local originalExecute = ExecuteCommand
        
        -- Create a map of blacklisted commands for faster lookup
        local blacklistedCommands = {}
        for _, command in ipairs(Config.CommandBlacklist.list) do
            blacklistedCommands[command:lower()] = true
        end
        
        -- Register a new handler to process commands before execution
        RegisterNUICallback('chatResult', function(data, cb)
            if data.message and data.message:sub(1, 1) == '/' then
                -- Extract the command name without the leading slash
                local commandName = data.message:sub(2):match("^(%S+)")
                
                if commandName and blacklistedCommands[commandName:lower()] then
                    -- Suspicious command detected
                    TriggerServerEvent("rmg:removePlayer", Config.CommandBlacklist.lang.kickReason)
                    
                    -- Prevent command execution
                    cb({ status = "error" })
                    return
                end
            end
            
            -- Allow normal command processing
            cb({ status = "ok" })
        end)
        
        -- Additional protection via native command system if NUI doesn't catch it
        ExecuteCommand = function(command, ...)
            if command then
                local commandName = command:match("^(%S+)")
                
                if commandName and blacklistedCommands[commandName:lower()] then
                    -- Suspicious command detected
                    TriggerServerEvent("rmg:removePlayer", Config.CommandBlacklist.lang.kickReason)
                    return
                end
            end
            
            -- Execute the original command if not blacklisted
            return originalExecute(command, ...)
        end
    end
end) 