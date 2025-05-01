-- Server-side speed hack detection management

-- Track players who have recently connected to avoid false positives
local recentlyConnected = {}

-- Handle player connect events
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local _source = source
    recentlyConnected[_source] = os.time()
end)

-- Mark a player as loaded after character selection
RegisterNetEvent("vorp:SelectedCharacter") 
AddEventHandler("vorp:SelectedCharacter", function(charid)
    local _source = source
    recentlyConnected[_source] = os.time()
    
    -- Schedule cleanup after the grace period
    Citizen.SetTimeout(60000, function() -- 60 second grace period
        if recentlyConnected[_source] then
            recentlyConnected[_source] = nil
        end
    end)
end)

-- Clean up on disconnect
AddEventHandler('playerDropped', function()
    local _source = source
    recentlyConnected[_source] = nil
end)

-- Handle speed violation reports from clients
RegisterNetEvent("rmg:speedViolation")
AddEventHandler("rmg:speedViolation", function(data)
    local _source = source
    
    -- Skip checks for recently connected players
    if recentlyConnected[_source] and (os.time() - recentlyConnected[_source]) < 60 then
        return -- Still in grace period, ignore violation
    end
    
    if Config.Velocity.active then
        -- Log speed violation for monitoring
        local formatted = string.format(
            "Speed: %.2f (limit: %.2f) - Violations: %d",
            data.speed or 0,
            data.limit or 0,
            data.violations or 0
        )
        
        -- Alert if violation count is high
        if data.violations >= 3 then
            WebhookAlert.sendMessage(_source, "Potential speed hack: " .. formatted)
        end
        
        -- If position data is provided, log it
        if data.position then
            local posString = string.format(
                "Position: X=%.2f, Y=%.2f, Z=%.2f",
                data.position.x or 0,
                data.position.y or 0,
                data.position.z or 0
            )
            
            -- Save to console logs at least for reference
            print("[RedM Guardian] Player ID: " .. _source .. " - " .. formatted .. " - " .. posString)
        end
    end
end)

-- Handle teleport detection
RegisterNetEvent("rmg:suspiciousTeleport")
AddEventHandler("rmg:suspiciousTeleport", function(jsonData)
    local _source = source
    
    -- Skip checks for recently connected players
    if recentlyConnected[_source] and (os.time() - recentlyConnected[_source]) < 60 then
        return -- Still in grace period, ignore teleport detection
    end
    
    if Config.Velocity.active then
        local data = json.decode(jsonData)
        
        if data then
            local distance = data.distance or 0
            
            -- Only report very large distances that are clearly impossible
            if distance > 200.0 then
                local posInfo = string.format(
                    "Teleport detected: %.2fm - From: [%.1f, %.1f, %.1f] To: [%.1f, %.1f, %.1f]",
                    distance,
                    data.from.x or 0, data.from.y or 0, data.from.z or 0,
                    data.to.x or 0, data.to.y or 0, data.to.z or 0
                )
                
                WebhookAlert.sendMessage(_source, posInfo)
                
                -- At extreme distances, this is definitely a hack
                if distance > 500.0 then
                    KickPlayer(_source, Config.Velocity.lang.reason)
                end
            end
        end
    end
end)

-- Allow temporary exemptions for legitimate teleports (admin actions, etc.)
RegisterNetEvent("rmg:allowTeleport")
AddEventHandler("rmg:allowTeleport", function(targetId)
    local _source = source
    
    -- Verify if source has permission to grant teleport exemptions
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
        
        if isAdmin and targetId then
            -- Disable speed checks temporarily for this player
            TriggerClientEvent("rmg:disableSpeedCheck", targetId, 5000) -- 5 second exemption
        end
    end
end)

-- Command to manually exempt players from velocity checks (for admins)
RegisterCommand('velocity_exempt', function(source, args, rawCommand)
    local _source = source
    
    -- Only admins can use this command
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
            local targetId = tonumber(args[1])
            local duration = tonumber(args[2]) or 60
            
            if targetId then
                -- Add to exempt list
                recentlyConnected[targetId] = os.time()
                
                -- Disable client-side checks
                TriggerClientEvent("rmg:disableSpeedCheck", targetId, duration * 1000)
                
                -- Clean up after duration
                Citizen.SetTimeout(duration * 1000, function()
                    recentlyConnected[targetId] = nil
                end)
                
                TriggerClientEvent('vorp:TipRight', _source, "Player " .. targetId .. " exempted from velocity checks for " .. duration .. " seconds", 5000)
            else
                TriggerClientEvent('vorp:TipRight', _source, "Usage: /velocity_exempt [player_id] [duration_seconds]", 5000)
            end
        end
    end
end, false) 