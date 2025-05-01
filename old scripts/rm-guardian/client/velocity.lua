-- Client-side speed hack detection system

if Config.Velocity.active then
    local speedCheckEnabled = false -- Initially disabled until player is fully loaded
    local lastPosition = vector3(0, 0, 0)
    local speedViolations = 0
    local playerFullyLoaded = false
    local initialSpawnDelay = 30000 -- 30 seconds grace period after selection
    
    -- Speed thresholds (in units per second)
    local maxSpeedOnFoot = 12.0         -- Normal running speed max
    local maxSpeedOnMount = 30.0        -- Mounted speed max
    local maxSpeedInVehicle = 40.0      -- Vehicle max speed
    local absurdSpeed = 100.0           -- Clearly impossible speed
    
    -- Wait for player to be fully loaded before enabling checks
    Citizen.CreateThread(function()
        -- Wait for the first character selection event
        local initialLoadComplete = false
        
        while not initialLoadComplete do
            Wait(1000)
            if NetworkIsPlayerActive(PlayerId()) then
                initialLoadComplete = true
            end
        end
        
        -- Additional safety delay after player is active
        Wait(initialSpawnDelay)
        
        -- Now enable speed checking
        playerFullyLoaded = true
        speedCheckEnabled = true
        print("[RedM Guardian] Velocity monitoring enabled")
    end)
    
    -- Monitoring thread
    Citizen.CreateThread(function()
        while true do
            Wait(1000) -- Check every second
            
            if speedCheckEnabled and playerFullyLoaded then
                local ped = PlayerPedId()
                
                if ped and not IsEntityDead(ped) and DoesEntityExist(ped) then
                    local currentPos = GetEntityCoords(ped)
                    
                    -- Skip initial position check
                    if lastPosition == vector3(0, 0, 0) then
                        lastPosition = currentPos
                        Wait(1000) -- Wait an extra second for first measurement
                        goto continue
                    end
                    
                    -- Skip if loading screen is still active
                    if IsLoadingScreenActive() or IsPauseMenuActive() then
                        lastPosition = currentPos
                        goto continue
                    end
                    
                    local distance = #(currentPos - lastPosition)
                    local speed = distance -- Units per second
                    
                    -- Determine appropriate speed limit based on player state
                    local speedLimit = maxSpeedOnFoot
                    
                    if IsPedInAnyVehicle(ped, true) then
                        speedLimit = maxSpeedInVehicle
                    elseif IsPedOnMount(ped) then
                        speedLimit = maxSpeedOnMount
                    end
                    
                    -- Immediate detection of absurd speeds (obvious hacks)
                    if speed > absurdSpeed then
                        TriggerServerEvent("rmg:removePlayer", Config.Velocity.lang.reason)
                        return
                    end
                    
                    -- Progressive violation system for edge cases
                    if speed > speedLimit * 1.5 then
                        speedViolations = speedViolations + 1
                        
                        -- Log significant violations for monitoring
                        if speedViolations % 3 == 0 then
                            TriggerServerEvent("rmg:speedViolation", {
                                speed = speed,
                                limit = speedLimit,
                                position = {x = currentPos.x, y = currentPos.y, z = currentPos.z},
                                violations = speedViolations
                            })
                        end
                        
                        -- Kick after multiple violations and only if they're serious
                        if speedViolations >= 5 and speed > speedLimit * 3 then
                            TriggerServerEvent("rmg:removePlayer", Config.Velocity.lang.reason)
                            return
                        end
                    else
                        -- Decrease violation count for consistent normal behavior
                        speedViolations = math.max(0, speedViolations - 0.5)
                    end
                    
                    lastPosition = currentPos
                end
            end
            
            ::continue::
        end
    end)
    
    -- Reset position when player respawns to avoid false positives
    AddEventHandler("playerSpawned", function()
        lastPosition = vector3(0, 0, 0)
        speedViolations = 0
        
        -- Temporarily disable speed checks when spawning
        speedCheckEnabled = false
        Wait(5000) -- 5 second grace period after spawn
        speedCheckEnabled = true
    end)
    
    -- Provide a safe hook for character selection
    RegisterNetEvent("vorp:SelectedCharacter")
    AddEventHandler("vorp:SelectedCharacter", function(charid)
        -- Reset position tracking after character selection
        lastPosition = vector3(0, 0, 0)
        speedViolations = 0
        
        -- Disable speed checks temporarily to allow for initial spawn
        speedCheckEnabled = false
        
        -- Re-enable after a delay
        Citizen.SetTimeout(initialSpawnDelay, function()
            speedCheckEnabled = true
        end)
    end)
    
    -- Temporarily disable speed checks when teleporting is legitimate
    RegisterNetEvent("rmg:disableSpeedCheck")
    AddEventHandler("rmg:disableSpeedCheck", function(duration)
        speedCheckEnabled = false
        lastPosition = vector3(0, 0, 0)
        
        Citizen.SetTimeout(duration or 5000, function()
            speedCheckEnabled = true
        end)
    end)
end 