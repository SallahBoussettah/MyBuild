--[[
    Mouse Spam Protection - Client Side
    Detects rapid clicking and prevents click spam exploits
]]--

-- Only run if the feature is enabled in config
if Config.MouseSpam.active then
    -- Initialize local variables
    local lastClick = 0
    local infractions = Config.MouseSpam.infractions
    local warningDisplayed = false
    local resetTimer = nil
    
    -- Initialize VORPcore if available for notifications
    local VORPcore = nil
    if GetResourceState('vorp_core') == 'started' then
        TriggerEvent("getCore", function(core)
            VORPcore = core
        end)
    end
    
    -- Function to display warning to player
    local function displayWarning()
        if not warningDisplayed and Config.MouseSpam.warningMessage then
            warningDisplayed = true
            
            -- Use VORP notification if available
            if VORPcore then
                VORPcore.NotifyRightTip(Config.MouseSpam.lang.warning, Config.MouseSpam.warningDuration)
            else
                -- Fallback to basic notification
                TriggerEvent("vorp:TipRight", Config.MouseSpam.lang.warning, Config.MouseSpam.warningDuration)
            end
            
            -- Reset warning flag after duration
            Citizen.SetTimeout(Config.MouseSpam.warningDuration, function()
                warningDisplayed = false
            end)
        end
    end
    
    -- Function to schedule infraction reset
    local function scheduleReset()
        -- Clear existing timer if any
        if resetTimer then
            resetTimer = nil
        end
        
        -- Create new reset timer
        resetTimer = true
        Citizen.SetTimeout(Config.MouseSpam.resetTime, function()
            if resetTimer then
                infractions = 0
                resetTimer = nil
            end
        end)
    end
    
    -- Main detection function
    local function checkMouseSpam()
        local currentTime = GetGameTimer()
        local timeDiff = currentTime - lastClick
        
        -- Update last click time
        lastClick = currentTime
        
        -- Check if click is too fast (spam)
        if timeDiff < Config.MouseSpam.sensitivity then
            infractions = infractions + 1
            
            -- Display warning if needed
            if infractions >= math.floor(Config.MouseSpam.maxInfractions / 2) then
                displayWarning()
            end
            
            -- Check if player should be kicked
            if infractions >= Config.MouseSpam.maxInfractions then
                -- Notify server to kick the player
                TriggerServerEvent('sb_mouse:kick')
                return
            end
            
            -- Schedule reset of infractions
            scheduleReset()
        end
    end
    
    -- Register control handlers for left and right clicks
    Citizen.CreateThread(function()
        print('[sb_mouse] Client-side mouse spam protection initialized')
        
        while true do
            Citizen.Wait(0)
            
            -- Check main attack button (left click / shoot)
            if IsControlJustPressed(0, 0x07CE1E61) then -- MOUSE1 / VK_LBUTTON
                checkMouseSpam()
            end
            
            -- Check secondary attack button (right click / aim)
            if IsControlJustPressed(0, 0xF84FA74F) then -- MOUSE2 / VK_RBUTTON
                checkMouseSpam()
            end
        end
    end)
else
    print('[sb_mouse] Mouse spam protection disabled in config')
end 