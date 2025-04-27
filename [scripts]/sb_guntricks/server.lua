--[[
    sb_guntricks - server.lua
    Server-side component for the Gun Tricks script
    
    This file handles license checking for gun tricks.
]]

-- Get VORP inventory API
local VORPInv = exports.vorp_inventory

-- Register server event to check for bounty hunter license
RegisterServerEvent('sb_guntricks:checkLicense')
AddEventHandler('sb_guntricks:checkLicense', function()
    local _source = source
    
    -- Get the player's inventory count for the bounty hunter license
    VORPInv:getItemCount(_source, function(count)
        local hasLicense = count > 0
        
        -- Send result back to client
        TriggerClientEvent('sb_guntricks:licenseResult', _source, hasLicense)
    end, 'bountylicns')
end)

-- Force check with callback support
RegisterServerEvent('sb_guntricks:forceCheck')
AddEventHandler('sb_guntricks:forceCheck', function(callbackId)
    local _source = source
    
    -- Get the player's inventory count for the bounty hunter license
    VORPInv:getItemCount(_source, function(count)
        local hasLicense = count > 0
        
        -- Send result back to client directly
        TriggerClientEvent('sb_guntricks:licenseResult', _source, hasLicense)
        
        -- If we have a callback ID, send response with that ID
        if callbackId then
            TriggerClientEvent('sb_guntricks:licenseResponse', _source, callbackId, hasLicense)
        end
    end, 'bountylicns')
end)

-- Monitor all inventory item changes (VORP events)
AddEventHandler('vorp:Server:OnAddToInventory', function(player, itemData, amount)
    if itemData.item == 'bountylicns' then
        -- Trigger a license check for that player
        if player and player > 0 then
            -- Small delay to ensure inventory is updated
            Citizen.Wait(100)
            
            -- Get the player's inventory count for the bounty hunter license
            VORPInv:getItemCount(player, function(count)
                local hasLicense = count > 0
                
                -- Send result back to client
                TriggerClientEvent('sb_guntricks:licenseResult', player, hasLicense)
            end, 'bountylicns')
        end
    end
end)

-- Monitor inventory item removals
AddEventHandler('vorp:Server:OnRemoveFromInventory', function(player, itemData, amount)
    if itemData.item == 'bountylicns' then
        -- Trigger a license check for that player
        if player and player > 0 then
            -- Small delay to ensure inventory is updated
            Citizen.Wait(100)
            
            -- Get the player's inventory count for the bounty hunter license
            VORPInv:getItemCount(player, function(count)
                local hasLicense = count > 0
                
                -- Send result back to client
                TriggerClientEvent('sb_guntricks:licenseResult', player, hasLicense)
            end, 'bountylicns')
        end
    end
end)

-- Register the license as a usable item to inform player about what it does
Citizen.CreateThread(function()
    -- Wait for VORP inventory to be fully loaded
    Citizen.Wait(1000)
    
    -- Register the bounty license as a usable item
    VORPInv:registerUsableItem("bountylicns", function(data)
        -- Send message to the player about what the license allows
        TriggerClientEvent("vorp:TipRight", data.source, "This license allows you to perform gun tricks. Use /guntrick or /gt to start.", 5000)
        
        -- Trigger immediate license check
        TriggerClientEvent('sb_guntricks:licenseResult', data.source, true)
    end)
end) 