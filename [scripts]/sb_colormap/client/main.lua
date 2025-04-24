--[[
    sb_colormap - Main Client Script
    Applies custom colors to map regions in RedM
    Original by Darky_13, Integrated by Salah
]]--

-- Store blips for cleanup
local areaBlips = {}
local mapOverlays = {}
local customBlips = {}

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
    
    -- Apply colors to family territories
    if Config.FamilyTerritories then
        for k, v in pairs(Config.FamilyTerritories) do
            local regionHash = v.hash
            local mapColor = v.color
            
            -- Native function to set the color of a region on the map
            Citizen.InvokeNative(0x563FCB6620523917, regionHash, GetHashKey(mapColor))
            
            -- Debug output (disabled by default)
            -- print("Applied color " .. mapColor .. " to family territory " .. k .. " (" .. v.label .. ")")
        end
    end
    
    -- Create custom area blips (regular blips)
    if Config.CustomAreaBlips then
        for i, area in ipairs(Config.CustomAreaBlips) do
            if area.visible then
                -- Create radius blip (circular area)
                local blip = Citizen.InvokeNative(0x45F13B7E0A15C880, -1282792512, area.x, area.y, 0, area.radius)
                
                -- Set blip color
                Citizen.InvokeNative(0x662D364ABF16DE2F, blip, area.color)
                
                -- Set blip alpha (transparency)
                Citizen.InvokeNative(0x45FF974EEE1C8734, blip, area.alpha)
                
                -- Set high detail if requested
                if area.highDetail then
                    Citizen.InvokeNative(0xB059D7BD3D78C16F, blip, 1)
                end
                
                -- Add name to the blip
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, area.name)
                
                -- Store the blip handle for cleanup
                table.insert(areaBlips, blip)
                
                -- Debug output
                -- print("Created custom area blip for " .. area.name)
            end
        end
    end
    
    -- Create custom map overlay zones (similar to region coloring)
    if Config.CustomMapOverlays then
        for i, overlay in ipairs(Config.CustomMapOverlays) do
            if overlay.visible then
                -- Create area blip with a style that blends with the map better
                local blip = Citizen.InvokeNative(0x45F13B7E0A15C880, -1282792512, overlay.x, overlay.y, 0, overlay.radius)
                
                -- Apply map-like styling (this makes it look like the colored regions)
                Citizen.InvokeNative(0x662D364ABF16DE2F, blip, GetHashKey(overlay.style))
                
                -- Make it more transparent to blend with the map
                Citizen.InvokeNative(0x45FF974EEE1C8734, blip, 160) -- Default transparency
                
                -- Set high detail for smoother edges
                Citizen.InvokeNative(0xB059D7BD3D78C16F, blip, 1)
                
                -- Add name to the overlay (will show when cursor hovers over it)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, overlay.name)
                
                -- Store for cleanup
                table.insert(mapOverlays, blip)
                
                -- If this is the Pincertens family territory, add a revolver icon blip
                if overlay.name == "Pincertens Family Territory" then
                    -- Create a revolver blip at the center of their territory
                    local revolverBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, overlay.x, overlay.y, 0)
                    
                    -- Set blip sprite to revolver (weapon blip)
                    -- 669307703 is for revolver (or one of the weapon blip sprites)
                    Citizen.InvokeNative(0x74F74D3207ED525C, revolverBlip, 669307703, 1) 
                    
                    -- Set blip color to red
                    Citizen.InvokeNative(0x662D364ABF16DE2F, revolverBlip, 0xFF0000) -- Red color
                    
                    -- Add name to the blip
                    Citizen.InvokeNative(0x9CB1A1623062F402, revolverBlip, "Pincertens Family")
                    
                    -- Store for cleanup
                    table.insert(customBlips, revolverBlip)
                end
                
                -- Debug output
                -- print("Created map overlay for " .. overlay.name .. " with style " .. overlay.style)
            end
        end
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
        
        -- Remove colors from family territories
        if Config.FamilyTerritories then
            for k, v in pairs(Config.FamilyTerritories) do
                local regionHash = v.hash
                
                -- Native function to reset the color of a region on the map
                Citizen.InvokeNative(0x6786D7AFAC3162B3, regionHash)
            end
        end
        
        -- Remove all custom area blips
        for _, blip in ipairs(areaBlips) do
            RemoveBlip(blip)
        end
        
        -- Remove all map overlays
        for _, blip in ipairs(mapOverlays) do
            RemoveBlip(blip)
        end
        
        -- Remove all custom blips
        for _, blip in ipairs(customBlips) do
            RemoveBlip(blip)
        end
    end
end)

-- Command to get the current region hash
-- Usage: /getregionhash
RegisterCommand("getregionhash", function(source, args, rawCommand)
    -- Get player position
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Get region hash at player position (Note: This is an approximation, as we can't directly get the region hash)
    local closestHash = nil
    local closestName = "Unknown"
    
    -- Print message
    TriggerEvent("vorp:Tip", "Checking region at your current position...", 3000)
    
    -- Wait for notification to show
    Citizen.Wait(3000)
    
    -- Copy result to clipboard if possible
    -- On most systems, this will put the region hash in the player's clipboard for easy pasting into config
    local message = "You are in region: Check console for details (F8)"
    
    -- Use console logging as it's more reliable
    print("================ REGION HASH INFO ================")
    print("Check the config file RegionHashReference table for known region hashes.")
    print("To add this area as a family territory, add this to Config.FamilyTerritories:")
    print("    FAMILY_NAME_HERE = {")
    print("        hash = " .. "HASH_VALUE_HERE" .. ", -- use a hash from the RegionHashReference table")
    print("        color = \"BLIP_STYLE_ADVERSARY\",")
    print("        label = \"Your Family Name\"")
    print("    },")
    print("==================================================")
    
    -- Show notification with instructions
    TriggerEvent("vorp:Tip", message, 5000)
end, false)

-- Command to get current coordinates (for custom areas)
-- Usage: /getcoords
RegisterCommand("getcoords", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Format coordinates for easy copying
    local coordString = string.format("x = %.2f, y = %.2f", coords.x, coords.y)
    
    -- Copy to clipboard and show notification
    print("================ COORDINATES ================")
    print("Your current coordinates:")
    print(coordString)
    print("To add a map-style overlay at this location, add this to Config.CustomMapOverlays:")
    print("{")
    print("    name = \"My Territory\",")
    print("    " .. coordString .. ",")
    print("    radius = 100.0,     -- Adjust the size as needed")
    print("    style = \"BLIP_STYLE_DEBUG_GREEN\", -- Choose style from MapOverlayStyles")
    print("    visible = true")
    print("},")
    print("=============================================")
    
    -- Show notification
    TriggerEvent("vorp:Tip", "Coordinates saved to console (F8)", 3000)
end, false)

-- Command to list all available family territories
-- Usage: /listterritories
RegisterCommand("listterritories", function(source, args, rawCommand)
    if Config.FamilyTerritories then
        print("============= FAMILY TERRITORIES =============")
        for k, v in pairs(Config.FamilyTerritories) do
            print(v.label .. " (Hash: " .. v.hash .. ", Color: " .. v.color .. ")")
        end
        print("=============================================")
        TriggerEvent("vorp:Tip", "Family territories listed in the console (F8)", 3000)
    else
        TriggerEvent("vorp:Tip", "No family territories defined", 3000)
    end
end, false)

-- Command to list all custom areas
-- Usage: /listareas
RegisterCommand("listareas", function(source, args, rawCommand)
    local hasAreas = false
    
    if Config.CustomAreaBlips and #Config.CustomAreaBlips > 0 then
        print("============= CUSTOM AREA BLIPS =============")
        for i, area in ipairs(Config.CustomAreaBlips) do
            print(area.name .. " (Coords: " .. area.x .. ", " .. area.y .. ", Radius: " .. area.radius .. ")")
        end
        hasAreas = true
    end
    
    if Config.CustomMapOverlays and #Config.CustomMapOverlays > 0 then
        print("============= CUSTOM MAP OVERLAYS =============")
        for i, overlay in ipairs(Config.CustomMapOverlays) do
            print(overlay.name .. " (Coords: " .. overlay.x .. ", " .. overlay.y .. ", Radius: " .. overlay.radius .. ", Style: " .. overlay.style .. ")")
        end
        hasAreas = true
    end
    
    if hasAreas then
        print("=======================================")
        TriggerEvent("vorp:Tip", "Custom areas listed in the console (F8)", 3000)
    else
        TriggerEvent("vorp:Tip", "No custom areas defined", 3000)
    end
end, false) 