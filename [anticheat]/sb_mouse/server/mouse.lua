--[[
    Mouse Spam Protection - Server Side
    Handles kicks and logging for mouse click spam detection
]]--

-- Only run if the feature is enabled in config
if Config.MouseSpam.active then
    -- Function to check if Discord integration is available
    local function sendDiscordNotification(playerId)
        if Config.Discord.active then
            -- Check if sb_discord is available
            if GetResourceState('sb_discord') == 'started' then
                -- Use the discord export
                exports['sb_discord']:sendToDiscord(
                    Config.Discord.webhookType,
                    playerId,
                    Config.Discord.lang.kickTitle,
                    Config.Discord.lang.kickReason,
                    nil,
                    Config.Discord.logLevel
                )
            else
                print("[sb_mouse] Warning: sb_discord resource not found. Discord notifications disabled.")
            end
        end
    end
    
    -- Register kick event handler
    RegisterServerEvent('sb_mouse:kick')
    AddEventHandler('sb_mouse:kick', function()
        local playerId = source
        
        -- Log detection to console
        print('[sb_mouse] Player ' .. GetPlayerName(playerId) .. ' (#' .. playerId .. ') kicked for mouse spam clicking')
        
        -- Send Discord notification if enabled
        sendDiscordNotification(playerId)
        
        -- Kick the player
        DropPlayer(playerId, Config.MouseSpam.lang.kickReason)
    end)
    
    print('[sb_mouse] Server-side mouse spam protection initialized')
else
    print('[sb_mouse] Mouse spam protection disabled in config')
end 