-- Keybind monitoring system to block suspicious key combinations
Citizen.CreateThread(function()
    if Config.KeyBlacklist.active then
        while true do
            Wait(0)
            
            for _, keyCombo in ipairs(Config.KeyBlacklist.list) do
                local keys = keyCombo[1]
                local allKeysPressed = true
                
                -- Check if all keys in the combination are pressed
                for _, key in ipairs(keys) do
                    if not IsControlPressed(0, key) then
                        allKeysPressed = false
                        break
                    end
                end
                
                if allKeysPressed then
                    -- Suspicious key combination detected
                    TriggerServerEvent("rmg:removePlayer", Config.KeyBlacklist.lang.kickReason)
                    return
                end
            end
        end
    end
end)

-- Additional monitoring for quick key sequences that might indicate macro usage
if Config.KeyBlacklist.active then
    local keyPressHistory = {}
    local lastPressTime = 0
    
    Citizen.CreateThread(function()
        local monitoredKeys = {
            0x4AF4D473, -- Delete
            0x3076E97C, -- Insert
            0x308588E6, -- F8
            0xCE8B7A3E, -- F4
            0x43CDA5B0  -- F3
        }
        
        while true do
            Wait(0)
            
            for _, key in ipairs(monitoredKeys) do
                if IsControlJustPressed(0, key) then
                    local currentTime = GetGameTimer()
                    local timeDiff = currentTime - lastPressTime
                    
                    -- Check for rapid key sequence that might indicate a macro
                    if #keyPressHistory > 0 and timeDiff < 100 then
                        table.insert(keyPressHistory, key)
                        
                        -- Check for suspicious patterns in the key history
                        if #keyPressHistory >= 3 then
                            -- Example: 3 different hotkeys pressed within 300ms
                            local distinctKeys = {}
                            for _, k in ipairs(keyPressHistory) do
                                distinctKeys[k] = true
                            end
                            
                            if table.count(distinctKeys) >= 3 then
                                TriggerServerEvent("rmg:suspiciousKeyPattern", keyPressHistory)
                                keyPressHistory = {}
                            end
                        end
                    else
                        -- Start a new sequence
                        keyPressHistory = {key}
                    end
                    
                    lastPressTime = currentTime
                    break
                end
            end
            
            -- Clear key history if too much time has passed
            if #keyPressHistory > 0 and (GetGameTimer() - lastPressTime) > 1000 then
                keyPressHistory = {}
            end
        end
    end)
end

-- Monkey patch for the table.count function if it doesn't exist
if not table.count then
    table.count = function(tbl)
        local count = 0
        for _ in pairs(tbl) do
            count = count + 1
        end
        return count
    end
end 