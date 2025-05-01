-- Format time remaining into a readable string
function FormatTimeRemaining(time)
    if time < 60 then
        return time .. Config.Idle.lang.seconds
    end

    if time >= 60 and time < 3600 then
        return math.floor(time / 60) .. Config.Idle.lang.minutes .. ' ' .. (time % 60) .. Config.Idle.lang.seconds
    end

    if time >= 3600 then
        local hours = math.floor(time / 3600)
        local minutes = math.floor((time % 3600) / 60)
        local seconds = time % 60
        return hours .. Config.Idle.lang.hours .. ' ' .. minutes .. Config.Idle.lang.minutes .. ' ' .. seconds .. Config.Idle.lang.seconds
    end
end

-- Start monitoring player for AFK status
function StartIdleMonitoring()
    local kickTime = Config.Idle.kickTimeout
    local warnTime = Config.Idle.warningTimeout
    local playerState = {
        previousPos = nil,
        currentPos = nil,
        idleTimer = 0
    }

    local function CheckIdleStatus()
        while true do
            Wait(1000)

            local ped = PlayerPedId()
            if ped then
                local isDead = IsEntityDead(ped)
                if not isDead then
    
                    playerState.currentPos = GetEntityCoords(ped, true)
                    if (playerState.currentPos == playerState.previousPos or IsPedRagdoll(ped)) then
                        if playerState.idleTimer >= kickTime then
                            TriggerServerEvent("rmg:removePlayer", Config.Idle.lang.kickReason)
                            return
                        end
                        
                        if playerState.idleTimer >= warnTime then
                            local timeLeft = kickTime - playerState.idleTimer
                            local formattedTime = FormatTimeRemaining(timeLeft)
                            VORPcore.NotifyCenter(Config.Idle.lang.kick .. formattedTime .. Config.Idle.lang.kick2, 1000)
                        end
                        
                        playerState.idleTimer = playerState.idleTimer + 1
                    else
                        playerState.idleTimer = 0
                    end
    
                    playerState.previousPos = playerState.currentPos
                end
            end
        end
    end

    -- Check if player has idle exemption
    RegisterNetEvent('rmg:idleExemptStatus')
    AddEventHandler('rmg:idleExemptStatus', function(isExempt)
        if not isExempt then
            CheckIdleStatus()
        end
    end)

    Citizen.CreateThread(function()
        TriggerServerEvent('rmg:checkIdleExempt')
    end)
end 