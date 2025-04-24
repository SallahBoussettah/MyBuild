--[[
    sb_colormap - Territory Notification System
    Shows notifications when entering and exiting family territories
    Inspired by vorp_zonenotify
]]--

local currentTerritory = nil
local lastNotificationTime = 0
local insideAnyTerritory = false

-- Function to check if player is in a territory
function IsPlayerInTerritory()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local px, py, pz = table.unpack(playerCoords)
    local foundTerritory = nil
    
    -- Check custom map overlays (family territories)
    if Config.CustomMapOverlays then
        for i, territory in ipairs(Config.CustomMapOverlays) do
            -- Calculate distance between player and territory center
            local distance = Vdist(px, py, pz, territory.x, territory.y, pz)
            
            -- If player is within the territory radius
            if distance <= territory.radius then
                foundTerritory = territory
                break
            end
        end
    end
    
    return foundTerritory
end

-- Function to show territory notification
function ShowTerritoryNotification(territory, isEntering)
    if not Config.TerritoryNotify.Enabled then return end
    
    -- Check if we should show notification based on cooldown
    local currentTime = GetGameTimer()
    if (currentTime - lastNotificationTime) < Config.TerritoryNotify.CooldownTimer then
        return
    end
    
    -- Update last notification time
    lastNotificationTime = currentTime
    
    -- Get the action message
    local actionMessage = isEntering and Config.TerritoryNotify.EnterMessage or Config.TerritoryNotify.ExitMessage
    
    -- Get the territory name
    local territoryName = territory and territory.name or "Unknown Territory"
    
    -- Determine the color to use
    local color = Config.TerritoryNotify.Colors.Default
    
    -- Check if we have a specific color for this territory
    for familyName, familyColor in pairs(Config.TerritoryNotify.Colors) do
        if string.find(territoryName, familyName) then
            color = familyColor
            break
        end
    end
    
    -- Format the notification message
    local message = actionMessage .. " " .. color .. territoryName
    
    -- Show the notification based on the configured style
    if Config.TerritoryNotify.NotificationStyle == "top" then
        TriggerEvent("vorp:NotifyTop", message, Config.TerritoryNotify.NotificationDuration)
    else
        TriggerEvent("vorp:Tip", message, Config.TerritoryNotify.NotificationDuration)
    end
    
    -- Debug mode
    if Config.TerritoryNotify.Debug then
        print("[DEBUG] " .. message)
    end
end

-- Main loop to check player position and show notifications
Citizen.CreateThread(function()
    -- Wait for player to be fully loaded
    Citizen.Wait(5000)
    
    while true do
        -- Check if player is in a territory
        local territory = IsPlayerInTerritory()
        
        -- Player entered a new territory
        if territory and (currentTerritory == nil or territory.name ~= currentTerritory.name) then
            if currentTerritory and Config.TerritoryNotify.ShowExitNotification then
                -- Show notification for leaving previous territory
                ShowTerritoryNotification(currentTerritory, false)
            end
            
            -- Show notification for entering new territory
            ShowTerritoryNotification(territory, true)
            
            -- Update current territory
            currentTerritory = territory
            insideAnyTerritory = true
            
        -- Player left a territory
        elseif not territory and insideAnyTerritory then
            if Config.TerritoryNotify.ShowExitNotification then
                -- Show notification for leaving territory
                ShowTerritoryNotification(currentTerritory, false)
            end
            
            -- Reset territory tracking
            currentTerritory = nil
            insideAnyTerritory = false
        end
        
        -- Check interval - adjust for performance
        Citizen.Wait(1000)
    end
end)

-- Command to forcibly check and show current territory
RegisterCommand("checkterritory", function(source, args, rawCommand)
    local territory = IsPlayerInTerritory()
    if territory then
        ShowTerritoryNotification(territory, true)
    else
        TriggerEvent("vorp:Tip", "Not in any family territory", 3000)
    end
end, false)