-- Version checking and management system

local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
local resourceName = GetCurrentResourceName()

-- Function to compare version strings
local function compareVersions(v1, v2)
    local v1Parts = {}
    local v2Parts = {}
    
    for part in string.gmatch(v1, "%d+") do
        table.insert(v1Parts, tonumber(part))
    end
    
    for part in string.gmatch(v2, "%d+") do
        table.insert(v2Parts, tonumber(part))
    end
    
    -- Compare each part of the version numbers
    local maxParts = math.max(#v1Parts, #v2Parts)
    for i = 1, maxParts do
        local v1Part = v1Parts[i] or 0
        local v2Part = v2Parts[i] or 0
        
        if v1Part > v2Part then
            return 1
        elseif v1Part < v2Part then
            return -1
        end
    end
    
    return 0 -- Versions are equal
end

-- Check for updates on resource start
Citizen.CreateThread(function()
    -- Only proceed if we have a version number
    if currentVersion then
        -- Log the current version
        print('^2' .. resourceName .. '^7: Anti-cheat system initialized v' .. currentVersion)
        
        -- Here you would typically implement a version check against your update server
        -- Since this is a sample and not connecting to a real update server, we'll simulate it
        
        -- In a real implementation, you would use PerformHttpRequest to check a versioning API
        Citizen.Wait(10000) -- Wait 10 seconds after startup
        
        -- Simulated version check
        if GetConvar("rmg_development", "false") == "true" then
            print('^3' .. resourceName .. '^7: Running in development mode, version checks disabled.')
        else
            -- You would implement your actual version check here
            -- Example structure:
            --[[
            PerformHttpRequest("https://api.yourdomain.com/versions/rm-guardian", function(statusCode, response, headers)
                if statusCode == 200 and response then
                    local data = json.decode(response)
                    if data and data.latestVersion then
                        local comparison = compareVersions(currentVersion, data.latestVersion)
                        
                        if comparison < 0 then
                            print('^3' .. resourceName .. '^7: Update available! Current: v' .. currentVersion .. ', Latest: v' .. data.latestVersion)
                            if data.criticalUpdate then
                                print('^1WARNING^7: This is a critical security update! Please update as soon as possible.')
                            end
                        else
                            print('^2' .. resourceName .. '^7: You are running the latest version.')
                        end
                    end
                else
                    print('^1' .. resourceName .. '^7: Unable to check for updates. Status code: ' .. (statusCode or "unknown"))
                end
            end, 'GET', '', { ['Content-Type'] = 'application/json' })
            --]]
        end
    else
        print('^1' .. resourceName .. '^7: Warning - Version information missing from fxmanifest.lua')
    end
end)

-- Register commands to check version manually
RegisterCommand('guardian_version', function(source, args, rawCommand)
    local _source = source
    
    if _source > 0 then
        -- Player executed command
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
                TriggerClientEvent('vorp:TipRight', _source, "RedM Guardian Version: " .. currentVersion, 5000)
            end
        end
    else
        -- Server console executed command
        print('^2' .. resourceName .. '^7: Currently running version ' .. currentVersion)
    end
end, false) 