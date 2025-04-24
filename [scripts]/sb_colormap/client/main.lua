--[[
    sb_colormap - Main Client Script
    Applies custom colors to map regions in RedM
    Original by Darky_13, Integrated by Salah
]]--

-- Initialize the colored regions when the resource starts
Citizen.CreateThread(function()
    -- Apply colors to all regions defined in the config
    for k, v in pairs(Config.ColorMap) do
        local regionHash = v.hash
        local mapColor = v.color
        
        -- Native function to set the color of a region on the map
        Citizen.InvokeNative(0x563FCB6620523917, regionHash, GetHashKey(mapColor))
        
        -- Debug output (disabled by default)
        -- print("Applied color " .. mapColor .. " to region " .. k)
    end
    
    -- Debug notification (disabled by default)
    -- TriggerEvent("vorp:Tip", "Map regions colored successfully!", 4000)
end)

-- Clean up when the resource stops
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Remove colors from all regions when the resource stops
        for k, v in pairs(Config.ColorMap) do
            local regionHash = v.hash
            
            -- Native function to reset the color of a region on the map
            Citizen.InvokeNative(0x6786D7AFAC3162B3, regionHash)
        end
    end
end) 