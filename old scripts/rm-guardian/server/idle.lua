-- Store exempt players (staff who should not be kicked for being idle)
local idleExemptPlayers = {}

-- Check if a player is exempt from idle kick
RegisterServerEvent('rmg:checkIdleExempt')
AddEventHandler('rmg:checkIdleExempt', function()
    local _source = source
    local isExempt = idleExemptPlayers[_source] or false
    
    if not isExempt then
        -- Check if player has admin role (using VORP groups)
        local User = VorpCore.getUser(_source)
        if User then
            local Character = User.getUsedCharacter
            if Character then
                local group = Character.group
                for _, role in ipairs(Config.Database.privilegedRoles) do
                    if group == role then
                        isExempt = true
                        idleExemptPlayers[_source] = true
                        break
                    end
                end
            end
        end
    end
    
    TriggerClientEvent('rmg:idleExemptStatus', _source, isExempt)
end)

-- Remove exempt status when player disconnects
AddEventHandler('playerDropped', function()
    local _source = source
    idleExemptPlayers[_source] = nil
end)

-- Admin command to add a player to the idle whitelist
RegisterCommand('idlewhitelist', function(source, args)
    local _source = source
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
            if args[1] and tonumber(args[1]) then
                local targetId = tonumber(args[1])
                
                -- Check if target player exists
                if GetPlayerName(targetId) then
                    idleExemptPlayers[targetId] = true
                    TriggerClientEvent('vorp:TipRight', _source, Config.Idle.lang.whitelist.wlAdded, 5000)
                    TriggerClientEvent('rmg:idleExemptStatus', targetId, true)
                    WebhookAlert.sendMessage(_source, "Added player ID " .. targetId .. " to idle whitelist")
                else
                    TriggerClientEvent('vorp:TipRight', _source, Config.Idle.lang.whitelist.err, 5000)
                end
            else
                TriggerClientEvent('vorp:TipRight', _source, Config.Idle.lang.whitelist.id, 5000)
            end
        end
    end
end, false)

-- Admin command to remove a player from the idle whitelist
RegisterCommand('idleunwhitelist', function(source, args)
    local _source = source
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
            if args[1] and tonumber(args[1]) then
                local targetId = tonumber(args[1])
                
                -- Remove player from whitelist
                idleExemptPlayers[targetId] = nil
                TriggerClientEvent('vorp:TipRight', _source, Config.Idle.lang.whitelist.wlRemoved, 5000)
                TriggerClientEvent('rmg:idleExemptStatus', targetId, false)
                WebhookAlert.sendMessage(_source, "Removed player ID " .. targetId .. " from idle whitelist")
            else
                TriggerClientEvent('vorp:TipRight', _source, Config.Idle.lang.whitelist.id, 5000)
            end
        end
    end
end, false) 