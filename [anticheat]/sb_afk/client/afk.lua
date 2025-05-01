-- Utility functions for time formatting
function getTimeString(time)
    if time < 60 then
        return time .. Config.AFK.lang.seconds
    elseif time < 3600 then
        local minutes = math.floor(time / 60)
        local seconds = time % 60
        return minutes .. Config.AFK.lang.minutes .. ' ' .. seconds .. Config.AFK.lang.seconds
    else
        local hours = math.floor(time / 3600)
        local minutes = math.floor((time % 3600) / 60)
        local seconds = time % 60
        return hours .. Config.AFK.lang.hours .. ' ' .. minutes .. Config.AFK.lang.minutes .. ' ' .. seconds .. Config.AFK.lang.seconds
    end
end

-- Format time as mm:ss for display
function formatTimeMMSS(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", minutes, secs)
end

-- Initialize VORPcore
VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

-- Main AFK check function
function startAFKChecks()
    local kicktime = Config.AFK.kicktime
    local warntime = Config.AFK.warntime
    local player = {
        last = nil,
        current = nil,
        timer = 0,
        warned = false,
        displayActive = false
    }
    
    -- Thread for AFK timer display
    local function startTimerDisplay()
        Citizen.CreateThread(function()
            while player.displayActive do
                local timeleft = kicktime - player.timer
                if timeleft <= 0 then
                    player.displayActive = false
                    return
                end
                
                -- Display timer using native Redm text functions
                local timeString = formatTimeMMSS(timeleft)
                local message = Config.AFK.lang.kick .. timeString .. Config.AFK.lang.kick2
                
                -- Use VORPcore notification
                VORPcore.NotifyBottomRight(message, 1000)
                
                Wait(1000)
            end
        end)
    end

    -- Main AFK check thread
    local function runCheck()
        Citizen.CreateThread(function()
            while true do
                Wait(1000)

                local ped = PlayerPedId()
                if ped and not IsEntityDead(ped) then
                    player.current = GetEntityCoords(ped, true)
                    
                    -- Check if player hasn't moved or is in ragdoll state
                    if (player.last and vector3(player.current.x, player.current.y, player.current.z) == vector3(player.last.x, player.last.y, player.last.z)) or IsPedRagdoll(ped) then
                        player.timer = player.timer + 1
                        
                        -- Start warning display if we've reached warning time
                        if player.timer >= warntime and not player.warned then
                            player.warned = true
                            player.displayActive = true
                            startTimerDisplay()
                            
                            -- Play a sound to alert the player (using a compatible RedM sound)
                            PlaySoundFrontend("CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", true, 1)
                        end
                        
                        -- Kick player when time exceeds kicktime
                        if player.timer >= kicktime then
                            player.displayActive = false
                            TriggerServerEvent("sb_afk:kick", Config.AFK.lang.kickreason)
                            return
                        end
                    else
                        -- Reset timer and warned status if player moves
                        player.timer = 0
                        player.warned = false
                        player.displayActive = false
                    end
                    
                    player.last = player.current
                end
            end
        end)
    end

    -- Event handlers for whitelist check
    RegisterNetEvent('sb_afk:updateafk')
    AddEventHandler('sb_afk:updateafk', function(state)
        runCheck()
    end)

    Citizen.CreateThread(function()
        TriggerServerEvent('sb_afk:rolecheck')
    end)

    RegisterNetEvent('sb_afk:rolecheck-r')
    AddEventHandler('sb_afk:rolecheck-r', function(response)
        if not response then
            runCheck()
        end
    end)
end

-- Start AFK checks when resource starts
Citizen.CreateThread(function()
    if Config.AFK.active then
        startAFKChecks()
    end
end) 