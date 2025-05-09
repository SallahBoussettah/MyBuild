-- Command blacklist detection system
-- Credit: Badger (original implementation)

Citizen.CreateThread(function()
    -- Wait for resources to load
    Citizen.Wait(1000)
    
    -- Main detection loop
    while true do
        Citizen.Wait(500)
        
        -- Only run if feature is active
        if Config.Commands.active then
            local blacklistedCommands = Config.Commands.list
            local registeredCommands = GetRegisteredCommands()
            local cheatCommandFound = false
            
            -- Check each registered command against our blacklist
            for _, command in ipairs(registeredCommands) do
                for _, blacklistedCommand in pairs(blacklistedCommands) do
                    local commandName = string.lower(command.name)
                    
                    -- Check for various command prefix patterns
                    if (commandName == string.lower(blacklistedCommand) or
                            commandName == string.lower('+' .. blacklistedCommand) or
                            commandName == string.lower('_' .. blacklistedCommand) or
                            commandName == string.lower('-' .. blacklistedCommand) or
                            commandName == string.lower('/' .. blacklistedCommand)) then
                        cheatCommandFound = true

                        -- Trigger the kick event with the command that was detected
                        TriggerServerEvent("sb_commands:kick", Config.Commands.lang.kickreason .. ': ' .. blacklistedCommand)
                        break
                    end
                end

                -- Exit the loop early if a cheat command was found
                if cheatCommandFound == true then
                    break
                end
            end
        end
    end
end) 