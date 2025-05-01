-- Input monitoring system to detect spam clicking and other rapid input behaviors
function StartInputMonitoring()
    local lastClickTime = 0
    local clickCount = 0
    local warned = false
    local inputMonitoringActive = false
    
    -- Key controls to monitor for rapid input
    local monitoredControls = {
        0x07CE1E61, -- Left Mouse Button
        0xF84FA74F, -- Right Mouse Button
        0x8FFC75D6, -- Spacebar
        0xD9D0E1C0, -- Enter
        0xCEFD9220, -- E key
        0x8CC9CD42  -- F key
    }
    
    -- Add a delay before starting input monitoring to avoid initial loading clicks
    Citizen.SetTimeout(60000, function()
        inputMonitoringActive = true
        print("[RedM Guardian] Input monitoring activated")
    end)
    
    -- Reset monitoring on character selection
    RegisterNetEvent("vorp:SelectedCharacter")
    AddEventHandler("vorp:SelectedCharacter", function(charid)
        -- Reset counters
        clickCount = 0
        warned = false
        inputMonitoringActive = false
        
        -- Re-enable after a delay
        Citizen.SetTimeout(60000, function()
            inputMonitoringActive = true
        end)
    end)
    
    Citizen.CreateThread(function()
        -- Initial startup delay
        Wait(30000)
        
        while true do
            Wait(0)
            
            -- Skip if monitoring not active yet or loading screen is showing
            if not inputMonitoringActive or IsLoadingScreenActive() or IsPauseMenuActive() then
                Wait(1000) -- Longer wait if not active
                goto continue
            end
            
            for _, control in ipairs(monitoredControls) do
                if IsControlJustPressed(0, control) then
                    local currentTime = GetGameTimer()
                    local timeDiff = currentTime - lastClickTime
                    
                    -- Use a more lenient sensitivity check
                    if timeDiff < Config.InputLimit.sensitivity / 2 then
                        clickCount = clickCount + 1
                        
                        -- Only count consecutive rapid clicks
                        if timeDiff > 150 then
                            clickCount = math.max(1, clickCount - 1) -- Some forgiveness
                        end
                        
                        -- Warn at a higher threshold
                        if clickCount > 15 and not warned then
                            VORPcore.NotifyCenter(Config.InputLimit.lang.warning, 3000)
                            warned = true
                        end
                        
                        -- Require many more violations before kicking (much higher threshold)
                        if clickCount >= Config.InputLimit.maxViolations * 3 then
                            -- Log to server before kicking
                            TriggerServerEvent("rmg:inputViolation", clickCount, control)
                            
                            -- Only kick in extreme cases
                            if clickCount >= Config.InputLimit.maxViolations * 5 then
                                TriggerServerEvent("rmg:removePlayer", Config.InputLimit.lang.kickReason)
                                return
                            end
                        end
                    else
                        -- More aggressive reset for normal input patterns
                        if timeDiff > 500 then
                            clickCount = math.max(0, clickCount - 2)
                            if clickCount <= 3 then
                                warned = false
                            end
                        end
                    end
                    
                    lastClickTime = currentTime
                    break
                end
            end
            
            ::continue::
        end
    end)
    
    -- Reset counter periodically to avoid false positives from legitimate rapid inputs
    Citizen.CreateThread(function()
        while true do
            Wait(3000) -- Faster decay
            if clickCount > 0 then
                clickCount = math.max(0, clickCount - 2) -- Faster reduction
            end
            if clickCount == 0 then
                warned = false
            end
        end
    end)
    
    -- Handle temporary disabling (for UI interactions, inventory, etc.)
    RegisterNetEvent("rmg:disableInputMonitoring")
    AddEventHandler("rmg:disableInputMonitoring", function(duration)
        inputMonitoringActive = false
        clickCount = 0
        warned = false
        
        Citizen.SetTimeout(duration or 10000, function()
            inputMonitoringActive = true
        end)
    end)
end 