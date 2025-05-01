-- Client-side asset and texture validation

if Config.AssetValidator.active then
    local checkedTextures = {}
    local suspiciousAssets = 0
    
    -- Function to check if a texture is blacklisted
    local function isBlacklistedTexture(textureName)
        for _, blacklisted in ipairs(Config.AssetValidator.list) do
            if string.find(string.lower(textureName), string.lower(blacklisted), 1, true) then
                return true
            end
        end
        return false
    end
    
    -- Monitor for suspicious texture loads
    Citizen.CreateThread(function()
        while true do
            Wait(10000) -- Check periodically
            
            -- Scan requested textures (this approach is limited but can catch some injections)
            for i = 0, GetNumStreamingRequests() - 1 do
                local textureName = GetNameOfStreamingRequest(i)
                
                -- Avoid checking the same texture repeatedly
                if textureName and not checkedTextures[textureName] then
                    checkedTextures[textureName] = true
                    
                    -- Check against blacklist
                    if isBlacklistedTexture(textureName) then
                        suspiciousAssets = suspiciousAssets + 1
                        
                        -- Report to server
                        TriggerServerEvent("rmg:suspiciousTexture", textureName)
                        
                        -- If multiple detections, consider it malicious
                        if suspiciousAssets >= 3 then
                            TriggerServerEvent("rmg:removePlayer", Config.AssetValidator.lang.kickReason)
                            return
                        end
                    end
                end
                
                -- Limit number of entries in the checked table to prevent memory issues
                if table.count(checkedTextures) > 1000 then
                    checkedTextures = {}
                end
            end
        end
    end)
    
    -- Additional check for model modifications (limited effectiveness in RedM)
    Citizen.CreateThread(function()
        while true do
            Wait(30000) -- Less frequent check
            
            local ped = PlayerPedId()
            if ped then
                local pedModel = GetEntityModel(ped)
                
                -- Base male/female models in RedM
                local validPlayerModels = {
                    `mp_male`, -- Male multiplayer model
                    `mp_female` -- Female multiplayer model
                }
                
                local isValidModel = false
                for _, model in ipairs(validPlayerModels) do
                    if pedModel == model then
                        isValidModel = true
                        break
                    end
                end
                
                -- Only trigger if player model has been completely replaced
                if not isValidModel then
                    -- Report suspicious model to server
                    TriggerServerEvent("rmg:suspiciousModel", pedModel)
                end
            end
        end
    end)
end

-- Monkey patch if not defined elsewhere
if not table.count then
    table.count = function(tbl)
        local count = 0
        for _ in pairs(tbl) do
            count = count + 1
        end
        return count
    end
end 