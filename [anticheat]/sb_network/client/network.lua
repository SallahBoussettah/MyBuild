--[[
    Network Connection Check - Client Side
    Responds to heartbeat events from the server to verify active network connection
]]--

-- Heartbeat response event
RegisterNetEvent('sb_network:heartbeat')
AddEventHandler('sb_network:heartbeat', function()
    -- Respond to server that we received the heartbeat
    TriggerServerEvent('sb_network:response')
end)

-- Notify the player if they're about to be kicked (optional feature)
RegisterNetEvent('sb_network:warning')
AddEventHandler('sb_network:warning', function()
    -- You could add a visual notification here if desired
    -- For example with a UI notification or screen effect
end)

print('[sb_network] Client-side network monitoring initialized') 