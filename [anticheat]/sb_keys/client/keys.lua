-- Key blacklist detection system
-- Credit: Badger (original implementation)

-- Debug function to print detected keys to console (for testing purposes)
local function TestKeyPressed(keyCode)
    if IsControlPressed(0, keyCode) or IsDisabledControlPressed(0, keyCode) then
        return true
    end
    return false
end

-- Main detection thread
Citizen.CreateThread(function()
    -- Wait for game to load fully
    Citizen.Wait(5000)
    print("^2[sb_keys]^7 Key detection system active")
    
    -- Main detection loop
    while true do
        Wait(0)
        
        -- Only run if feature is active
        if Config.Keys.active then
            local blacklistedKeys = Config.Keys.list
            
            -- Check each blacklisted key combination
            for i = 1, #blacklistedKeys do
                local keyCombo = blacklistedKeys[i][1]
                local keyStr = blacklistedKeys[i][2]

                -- Handle single key detection
                if #keyCombo == 1 then
                    local key1 = keyCombo[1]
                    if IsControlJustReleased(0, key1) or IsDisabledControlJustReleased(0, key1) then
                        print("^3[DEBUG]^7 Single key detected: " .. keyStr)
                        TriggerServerEvent("sb_keys:kick", Config.Keys.lang.kickreason .. ': ' .. keyStr)
                    end
                
                -- Handle 2-key combination detection
                elseif #keyCombo == 2 then
                    local key1 = keyCombo[1]
                    local key2 = keyCombo[2]
                    
                    -- Check using both regular and disabled controls to ensure detection
                    if (IsControlPressed(0, key1) or IsDisabledControlPressed(0, key1)) and 
                       (IsControlPressed(0, key2) or IsDisabledControlPressed(0, key2)) then
                        print("^3[DEBUG]^7 Two-key combo detected: " .. keyStr)
                        TriggerServerEvent("sb_keys:kick", Config.Keys.lang.kickreason .. ': ' .. keyStr)
                        Wait(20000) -- Wait 20 seconds before checking again to prevent spam
                    end
                
                -- Handle 3-key combination detection
                elseif #keyCombo == 3 then
                    local key1 = keyCombo[1]
                    local key2 = keyCombo[2]
                    local key3 = keyCombo[3]
                    
                    if (IsControlPressed(0, key1) or IsDisabledControlPressed(0, key1)) and 
                       (IsControlPressed(0, key2) or IsDisabledControlPressed(0, key2)) and 
                       (IsControlPressed(0, key3) or IsDisabledControlPressed(0, key3)) then
                        print("^3[DEBUG]^7 Three-key combo detected: " .. keyStr)
                        TriggerServerEvent("sb_keys:kick", Config.Keys.lang.kickreason .. ': ' .. keyStr)
                        Wait(20000) -- Wait 20 seconds before checking again to prevent spam
                    end
                
                -- Handle 4-key combination detection
                elseif #keyCombo == 4 then
                    local key1 = keyCombo[1]
                    local key2 = keyCombo[2]
                    local key3 = keyCombo[3]
                    local key4 = keyCombo[4]
                    
                    if (IsControlPressed(0, key1) or IsDisabledControlPressed(0, key1)) and 
                       (IsControlPressed(0, key2) or IsDisabledControlPressed(0, key2)) and 
                       (IsControlPressed(0, key3) or IsDisabledControlPressed(0, key3)) and 
                       (IsControlPressed(0, key4) or IsDisabledControlPressed(0, key4)) then
                        print("^3[DEBUG]^7 Four-key combo detected: " .. keyStr)
                        TriggerServerEvent("sb_keys:kick", Config.Keys.lang.kickreason .. ': ' .. keyStr)
                        Wait(20000) -- Wait 20 seconds before checking again to prevent spam
                    end
                end
            end
        end
    end
end)

-- Additional thread to log when certain keys are pressed (for debugging)
if Config.Keys.active then
    Citizen.CreateThread(function()
        Wait(5000)
        while true do
            Wait(500)
            -- Check for Shift + G in multiple ways
            if (IsControlPressed(0, 0x8FFC75D6) or IsDisabledControlPressed(0, 0x8FFC75D6)) and 
               (IsControlPressed(0, 0x760A9C6F) or IsDisabledControlPressed(0, 0x760A9C6F)) then
                print("^3[DEBUG]^7 Left Shift + G detected!")
            end
        end
    end)
end 