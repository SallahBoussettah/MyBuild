-- --[[
--     Resource Injection Detection - Client Side
--     Monitors for suspicious resource manipulation and detects cheat menus
-- ]]--

-- -- Only run if the feature is enabled in config
-- if Config.ResourceProtection.active then
--     -- Handle verification requests from server
--     RegisterNetEvent('sb_resource:verify')
--     AddEventHandler('sb_resource:verify', function()
--         -- If this event is called directly (which should not happen), it indicates tampering
--         TriggerServerEvent("sb_resource:kick", Config.ResourceProtection.lang.kickReason)
--     end)

--     -- Main resource check thread
--     Citizen.CreateThread(function()
--         print('[sb_resource] Client-side resource protection initialized')
        
--         while true do
--             Citizen.Wait(Config.ResourceProtection.checkInterval)
            
--             -- Get all resources the client knows about
--             local resources = {}
--             for i = 0, GetNumResources() - 1 do
--                 resources[i+1] = GetResourceByFindIndex(i)
--             end
            
--             -- Send resource list to server for verification
--             Citizen.Wait(100) -- Small wait to avoid overwhelming the server with checks
--             TriggerServerEvent("sb_resource:check", resources)
--         end
--     end)
-- end 