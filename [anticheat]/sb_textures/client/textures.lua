--[[
    Texture Detection System - Client Side
    Monitors for blacklisted texture dictionaries that may indicate mod menu usage
]]--

-- Only run if the feature is enabled in config
if Config.Textures.active then
    Citizen.CreateThread(function()
        -- Check if we have any textures to monitor
        if #Config.Textures.list == 0 then
            print('[sb_textures] No texture dictionaries in blacklist. Detection inactive.')
            return
        end
        
        print('[sb_textures] Client-side texture monitoring initialized')
        
        -- Main monitoring loop
        while true do
            Citizen.Wait(Config.Textures.checkInterval)
            
            -- Check for each blacklisted texture dictionary
            for _, textureDictionary in ipairs(Config.Textures.list) do
                if HasStreamedTextureDictLoaded(textureDictionary) then
                    -- Found a blacklisted texture, notify server
                    TriggerServerEvent('sb_textures:detected', textureDictionary)
                    
                    -- Break after first detection to avoid spam
                    return
                end
            end
        end
    end)
end 