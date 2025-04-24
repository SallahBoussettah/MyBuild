local VORPcore = {}
local VORPinv = nil
local teleportActive = false
local dynamiteCooldownActive = false -- Renamed for clarity
local teleportLock = false -- To prevent spamming the teleport
local dynamitePlaced = false
local dynamiteObj = nil
local cooldownActive = false
local teleportEnabled = false -- Controls when teleport is available

-- Initialize VORP Core
Citizen.CreateThread(function()
    TriggerEvent("getCore", function(core)
        VORPcore = core
    end)
    
    -- Initialize VORP inventory properly
    TriggerEvent("vorp_inventory:client:LoadInventory", function(inv)
        VORPinv = inv
    end)
end)

-- Debug function
local function Debug(msg)
    if Config.Debug then
        print("[SL_TELEPORT] " .. msg)
    end
end

-- Draw 3D text in the world
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextCentre(true)
    DisplayText(str, _x, _y)
end

-- Notification function
local function Notify(text)
    VORPcore.NotifyRightTip(text, 4000)
end

-- Check if player is inside the cell
local function IsPlayerInsideCell()
    -- If cell check is disabled, always return true
    if not Config.Teleport.insideCellCheck then
        return true
    end
    
    -- If there has been an explosion and teleport is enabled, skip the strict cell check
    -- This is more permissive and ensures players can teleport even if not exactly in the cell
    if teleportEnabled then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist = #(coords - Config.TeleportPoint.position)
        
        -- If player is within a generous radius of the teleport point after explosion, allow teleport
        if dist < 5.0 then -- Increased radius to be more permissive
            if Config.Debug then
                Debug("Teleport enabled - allowing teleport regardless of exact cell position")
            end
            return true
        end
    end
    
    -- Standard cell check for when teleport is not enabled
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local cellCenter = Config.Teleport.cellArea.center
    local halfWidth = Config.Teleport.cellArea.width / 2
    local halfLength = Config.Teleport.cellArea.length / 2
    local halfHeight = Config.Teleport.cellArea.height / 2
    local rotation = Config.Teleport.cellArea.rotation or 0.0 -- Default to 0 if not defined
    
    -- Debug output of player position and cell boundaries
    if Config.Debug then
        Debug("Player position: x=" .. coords.x .. ", y=" .. coords.y .. ", z=" .. coords.z)
        Debug("Cell center: x=" .. cellCenter.x .. ", y=" .. cellCenter.y .. ", z=" .. cellCenter.z)
        Debug("Cell dimensions: width=" .. Config.Teleport.cellArea.width .. 
              ", length=" .. Config.Teleport.cellArea.length .. 
              ", height=" .. Config.Teleport.cellArea.height ..
              ", rotation=" .. rotation)
    end
    
    -- Calculate rotated position relative to cell center
    local relX = coords.x - cellCenter.x
    local relY = coords.y - cellCenter.y
    
    -- Convert rotation to radians
    local rotRad = math.rad(rotation)
    local cosRot = math.cos(rotRad)
    local sinRot = math.sin(rotRad)
    
    -- Rotate the relative coordinates
    local rotatedX = relX * cosRot - relY * sinRot
    local rotatedY = relX * sinRot + relY * cosRot
    
    -- Check if rotated position is within cell boundaries
    if rotatedX >= -halfWidth and rotatedX <= halfWidth and
       rotatedY >= -halfLength and rotatedY <= halfLength and
       coords.z >= (cellCenter.z - halfHeight) and coords.z <= (cellCenter.z + halfHeight) then
        if Config.Debug then
            Debug("Player IS inside cell boundaries (with rotation)")
        end
        return true
    end
    
    if Config.Debug then
        Debug("Player is NOT in cell boundaries")
        Debug("Rotated position: x=" .. rotatedX .. ", y=" .. rotatedY)
        Debug("Cell bounds x: " .. -halfWidth .. " to " .. halfWidth)
        Debug("Cell bounds y: " .. -halfLength .. " to " .. halfLength)
    end
    
    return false
end

-- Check if player has the required item
local function HasDynamite()
    -- In debug mode, we'll assume the player has dynamite for testing
    if Config.Debug then
        return true
    end
    
    -- Fixed inventory item check
    local count = 0
    TriggerEvent("vorp_inventory:client:GetItemCount", Config.Dynamite.itemName, function(itemCount)
        count = itemCount
    end)
    
    Citizen.Wait(200) -- Small wait to ensure the callback completes
    
    if Config.Debug then
        Debug("Dynamite count: " .. count)
    end
    
    return count > 0
end

-- Create a prompt for placing dynamite
local placeDynamitePrompt = nil
local dynamitePromptGroup = GetRandomIntInRange(0, 0xffffff)

Citizen.CreateThread(function()
    local str = "Place Dynamite"
    placeDynamitePrompt = PromptRegisterBegin()
    PromptSetControlAction(placeDynamitePrompt, 0x760A9C6F) -- G key
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(placeDynamitePrompt, str)
    PromptSetEnabled(placeDynamitePrompt, true)
    PromptSetVisible(placeDynamitePrompt, true)
    PromptSetHoldMode(placeDynamitePrompt, true)
    PromptSetGroup(placeDynamitePrompt, dynamitePromptGroup)
    PromptRegisterEnd(placeDynamitePrompt)
end)

-- Create a prompt for teleporting
local teleportPrompt = nil
local teleportPromptGroup = GetRandomIntInRange(0, 0xffffff)

Citizen.CreateThread(function()
    local str = "Teleport Out"
    teleportPrompt = PromptRegisterBegin()
    PromptSetControlAction(teleportPrompt, 0xCEFD9220) -- E key instead of G
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(teleportPrompt, str)
    PromptSetEnabled(teleportPrompt, true)
    PromptSetVisible(teleportPrompt, true)
    PromptSetHoldMode(teleportPrompt, true)
    PromptSetGroup(teleportPrompt, teleportPromptGroup)
    PromptRegisterEnd(teleportPrompt)
end)

-- Main loop variables
local placementLock = false -- Add a placement lock to prevent spamming
local lastPlacementTime = 0 -- Track when the last placement was attempted
local placementCooldown = 1000 -- 1 second cooldown between placement attempts
local lastTeleportAttemptTime = 0 -- Track when the last teleport was attempted
local teleportCooldown = 1000 -- 1 second cooldown between teleport attempts (just for UI/input handling)

-- Main loop for checking proximity to interaction point and displaying prompts
Citizen.CreateThread(function()
    
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local teleportDist = #(coords - Config.TeleportPoint.position)
        local dynamiteDist = #(coords - Config.Dynamite.placementPosition)
        
        -- Only draw the green teleport marker if teleport is enabled
        if teleportEnabled and teleportDist < 50.0 then
            -- Green teleport marker - keep this one
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, Config.TeleportPoint.position.x, Config.TeleportPoint.position.y, Config.TeleportPoint.position.z - 0.5, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 255, 0, 155, 0, 0, 2, 0, 0, 0, 0)
        end
        
        -- First check: If teleport is not enabled, show dynamite placement prompt
        if dynamiteDist < Config.Dynamite.placementRadius and not dynamitePlaced and not cooldownActive and not dynamiteCooldownActive and not teleportEnabled then
            -- Check if player is outside the cell (if required by config)
            local canPlace = true
            if Config.Dynamite.outsideCellOnly then
                -- Use the IsPlayerInsideCell function to check if player is inside
                if IsPlayerInsideCell() then
                    canPlace = false
                end
            end
            
            -- Only show prompt and allow placement if player is outside the cell (when required)
            if canPlace then
            local promptText = CreateVarString(10, 'LITERAL_STRING', "Jail Wall")
            PromptSetActiveGroupThisFrame(dynamitePromptGroup, promptText)
            
            -- Check for key press with placement lock to prevent spamming
            if PromptHasHoldModeCompleted(placeDynamitePrompt) and not placementLock then
                local currentTime = GetGameTimer()
                
                -- Only allow placement if cooldown has passed
                if currentTime - lastPlacementTime > placementCooldown then
                    lastPlacementTime = currentTime
                    placementLock = true -- Lock placement until the current attempt is resolved
                    
                    if HasDynamite() then
                        TriggerServerEvent("sl_teleport:checkCooldown", "dynamite")
                    else
                        Notify(Config.Dynamite.notifications.noItem)
                        -- Release the lock after a short delay if no dynamite
                        Citizen.SetTimeout(500, function()
                            placementLock = false
                        end)
                    end
                end
            end
            
            -- Reset placement lock if player is no longer holding the prompt
            if not PromptIsHoldModeRunning(placeDynamitePrompt) and placementLock then
                Citizen.SetTimeout(500, function()
                    placementLock = false
                end)
                end
            end
        end
        
        -- Second check: If teleport is enabled, show teleport prompt (only for players inside cell)
        if teleportDist < Config.TeleportPoint.radius and teleportEnabled and not teleportActive then
            -- Only show the teleport option if the player is inside the cell
            if IsPlayerInsideCell() then
                -- Create visual indicator for where to teleport
                if Config.Debug or true then -- Always draw marker for teleport point
                    Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, Config.TeleportPoint.position.x, Config.TeleportPoint.position.y, Config.TeleportPoint.position.z - 0.5, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 255, 0, 155, 0, 0, 2, 0, 0, 0, 0)
                end
                
                local promptText = CreateVarString(10, 'LITERAL_STRING', "Teleport Out")
                PromptSetActiveGroupThisFrame(teleportPromptGroup, promptText)
                
                -- Check for key press with teleport lock to prevent spamming
                if PromptHasHoldModeCompleted(teleportPrompt) and not teleportLock then
                    local currentTime = GetGameTimer()
                    
                    -- Only allow teleport if UI cooldown has passed (to prevent input spam)
                    if currentTime - lastTeleportAttemptTime > teleportCooldown then
                        lastTeleportAttemptTime = currentTime
                        teleportLock = true -- Lock teleport until the current attempt is resolved
                        
                        if Config.Debug then
                            Debug("Teleport initiated with E key")
                        end
                        
                        -- Skip cell check in debug mode to test teleport functionality
                        if Config.Debug then
                            DoTeleport()
                        else
                            TriggerServerEvent("sl_teleport:checkCooldown", "teleport")
                        end
                    end
                end
                
                -- Reset teleport lock if player is no longer holding the prompt
                if not PromptIsHoldModeRunning(teleportPrompt) and teleportLock then
                    Citizen.SetTimeout(500, function()
                        teleportLock = false
                    end)
                end
            else
                -- Let player know they need to be inside the cell
                if teleportDist < 1.0 then
                    DrawText3D(coords.x, coords.y, coords.z + 0.3, Config.Teleport.notifications.notInCell)
                    if Config.Debug then
                        Debug("Player is trying to teleport but is not in cell area")
                    end
                end
            end
        end
    end
end)

-- Place dynamite on the wall
function PlaceDynamite()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Animation for placing dynamite
    TaskStartScenarioInPlace(playerPed, GetHashKey("WORLD_HUMAN_CROUCH_INSPECT"), Config.Dynamite.placementDuration, true, false, false, false)
    
    Notify(Config.Dynamite.notifications.placing)
    Citizen.Wait(Config.Dynamite.placementDuration)
    ClearPedTasks(playerPed)
    
    -- Create the dynamite object
    local wallCoords = Config.Dynamite.placementPosition
    local placementCoords = vector3(
        wallCoords.x,
        wallCoords.y,
        wallCoords.z - 0.5
    )
    
    -- Load the dynamite model
    local model = GetHashKey(Config.Dynamite.modelObject)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(1)
    end
    
    -- Create the dynamite object
    dynamiteObj = CreateObject(model, placementCoords.x, placementCoords.y, placementCoords.z, true, true, true)
    PlaceObjectOnGroundProperly(dynamiteObj)
    
    -- Remove the dynamite item from inventory
    TriggerServerEvent("sl_teleport:removeDynamite")
    
    dynamitePlaced = true
    Notify(Config.Dynamite.notifications.placed)
    
    -- Start the countdown
    StartCountdown()
end

-- Countdown function
function StartCountdown()
    cooldownActive = true
    local timeLeft = Config.Dynamite.countdownTime
    
    Citizen.CreateThread(function()
        while timeLeft > 0 do
            Citizen.Wait(1000)
            timeLeft = timeLeft - 1
        end
        
        -- Trigger explosion when countdown reaches zero
        local dynamiteCoords = GetEntityCoords(dynamiteObj)
        TriggerServerEvent("sl_teleport:explode", dynamiteCoords)
    end)
end

-- Perform teleport
function DoTeleport()
    local playerPed = PlayerPedId()
    
    if Config.Debug then
        Debug("Starting teleport process")
        local beforeCoords = GetEntityCoords(playerPed)
        Debug("Position before teleport: x=" .. beforeCoords.x .. ", y=" .. beforeCoords.y .. ", z=" .. beforeCoords.z)
    end
    
    -- Set teleport active flag immediately to prevent multiple attempts
    teleportActive = true
    
    -- Clear any tasks to ensure player is in neutral state
    ClearPedTasksImmediately(playerPed)
    
    -- Simple notification
    Notify(Config.Teleport.notifications.teleporting)
    
    -- Short delay to let notification appear
    Citizen.Wait(500)
    
    -- Simple screen fade for visual effect
    DoScreenFadeOut(500)
    Citizen.Wait(600)
    
    -- Get destination coordinates
    local destCoords = Config.TeleportPoint.destination
    
    -- Very important: Freeze entity position during teleport
    FreezeEntityPosition(playerPed, true)
    
    -- Perform the actual teleport - using the most basic and reliable method
    SetEntityCoords(playerPed, destCoords.x, destCoords.y, destCoords.z, false, false, false, false)
    
    -- Additional teleport safety - try a second method immediately
    Citizen.Wait(50)
    SetEntityCoordsNoOffset(playerPed, destCoords.x, destCoords.y, destCoords.z, true, true, true)
    
    -- Set heading to face away from the cell
    SetEntityHeading(playerPed, 234.7113) -- Precise heading from screenshot
    
    -- Small wait for the entity to settle
    Citizen.Wait(100)
    
    -- Unfreeze the player
    FreezeEntityPosition(playerPed, false)
    
    -- Make sure player is on the ground
    Citizen.SetTimeout(100, function()
        PlaceObjectOnGroundProperly(playerPed)
    end)
    
    -- Fade back in
    Citizen.Wait(200)
    DoScreenFadeIn(500)
    
    -- Final check - if still not teleported, try one more approach
    Citizen.Wait(500)
    local finalCoords = GetEntityCoords(playerPed)
    local dist = #(finalCoords - destCoords)
    
    if Config.Debug then
        Debug("Position after teleport: x=" .. finalCoords.x .. ", y=" .. finalCoords.y .. ", z=" .. finalCoords.z)
        Debug("Target destination: x=" .. destCoords.x .. ", y=" .. destCoords.y .. ", z=" .. destCoords.z)
        Debug("Distance to target: " .. dist)
    end
    
    if dist > 5.0 then
        -- Last resort: try teleporting once more with a third method
        Debug("First teleport attempts failed! Trying emergency method...")
        FreezeEntityPosition(playerPed, true)
        
        -- Try with a higher Z coordinate to avoid ground issues
        SetEntityCoords(playerPed, destCoords.x, destCoords.y, destCoords.z + 1.0, true, false, false, false)
        
        -- Final safety check
        Citizen.Wait(200)
        FreezeEntityPosition(playerPed, false)
        
        -- Try to place on ground again
        PlaceObjectOnGroundProperly(playerPed)
        
        -- Ensure player isn't stuck
        ClearPedTasksImmediately(playerPed)
    end
    
    -- Reset teleport flags
    Citizen.SetTimeout(1000, function()
    teleportActive = false
    teleportLock = false
    
        -- Final notification
    Notify(Config.Teleport.notifications.teleported)
    
    -- Alert law enforcement if enabled
    if Config.Alerts.enabled then
        TriggerServerEvent("sl_teleport:alertLaw", GetEntityCoords(playerPed))
    end
    end)
    
    -- Activate cooldown
    cooldownActive = true
    Citizen.CreateThread(function()
        Citizen.Wait(Config.Cooldown * 1000)
        cooldownActive = false
        Debug("Cooldown reset")
    end)
end

-- Utility function to convert vector3 to string for debugging
function vec3ToString(vec)
    if vec == nil then return "nil" end
    return string.format("%.2f, %.2f, %.2f", vec.x, vec.y, vec.z)
end

-- Handle cooldown check response
RegisterNetEvent("sl_teleport:cooldownCheck")
AddEventHandler("sl_teleport:cooldownCheck", function(isOnCooldown, type, reason)
    if isOnCooldown then
        -- Only show cooldown message if the reason is actually a cooldown
        if reason == "cooldown" then
            if type == "dynamite" then
                Notify(Config.Dynamite.notifications.cooldown)
            else
                Notify(Config.Teleport.notifications.cooldown)
            end
        end
        
        -- Release the appropriate lock based on type
        if type == "dynamite" then
            placementLock = false
        else
            teleportLock = false
        end
    else
        if type == "dynamite" then
            PlaceDynamite()
        else
            DoTeleport()
        end
    end
end)

-- Handle explosion event from server
RegisterNetEvent("sl_teleport:explosionEffect")
AddEventHandler("sl_teleport:explosionEffect", function(coords)
    -- Play explosion audio
    PlaySoundFrontend("CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true, 1)
    
    -- Instead of a damaging explosion, create a safer version
    local insideCell = IsPlayerInsideCell()
    
    if insideCell then
        -- For players inside the cell, create a non-damaging explosion (visual only)
        -- Last parameter set to false to prevent damage
        AddExplosion(coords.x, coords.y, coords.z, 23, 5.0, true, false, false)
        
        -- Debug notification if needed
        if Config.Debug then
            Debug("Player is inside the cell - protected from explosion damage")
        end
    else
        -- Regular explosion for players outside the cell
    AddExplosion(coords.x, coords.y, coords.z, 23, 5.0, true, false, true)
    end
    
    -- Delete the dynamite object
    if DoesEntityExist(dynamiteObj) then
        DeleteObject(dynamiteObj)
        dynamiteObj = nil
    end
    
    dynamitePlaced = false
    cooldownActive = false
    placementLock = false -- Reset the placement lock after explosion
    
    -- Enable teleport option
    teleportEnabled = true
    
    -- Save teleport state to server
    TriggerServerEvent("sl_teleport:saveTeleportState", true)
    
    -- Start the timer to disable teleport after the configured time
    Citizen.CreateThread(function()
        Citizen.Wait(Config.TeleportActiveTime * 1000)
        teleportEnabled = false
        
        -- Save teleport state to server
        TriggerServerEvent("sl_teleport:saveTeleportState", false)
    end)
end)

-- Handle teleport state
RegisterNetEvent("sl_teleport:setTeleportState")
AddEventHandler("sl_teleport:setTeleportState", function(status)
    teleportEnabled = status
    
    -- If resetting the state (status = false), also reset other related flags
    if status == false then
        dynamitePlaced = false
        teleportActive = false
        teleportLock = false
        cooldownActive = false
        
        -- If there was a dynamite object, clean it up
        if DoesEntityExist(dynamiteObj) then
            DeleteObject(dynamiteObj)
            dynamiteObj = nil
        end
        
        if Config.Debug then
            Debug("All client-side teleport states have been reset")
        end
    end
end)

-- Handle cooldown
RegisterNetEvent("sl_teleport:setCooldown")
AddEventHandler("sl_teleport:setCooldown", function(status)
    dynamiteCooldownActive = status
    
    -- If resetting cooldown, also ensure placement lock is released
    if status == false then
        placementLock = false
        if Config.Debug then
            Debug("Dynamite cooldown and locks have been reset")
        end
    end
end)

-- Create alert for nearby law enforcement
RegisterNetEvent("sl_teleport:alertLaw")
AddEventHandler("sl_teleport:alertLaw", function(coords)
    -- This event handler is no longer needed as we're using VORP police alert system
    -- Keeping this empty handler for backward compatibility with other resources
end)

-- Register a command to get information about the teleport position
RegisterCommand('teleportinfo', function()
    if Config.Debug then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        local message = "Current Position: " .. tostring(coords)
        VORPcore.NotifyLeft("Teleport Information", message, "generic_textures", "tick", 8000)
        
        Debug(message)
    else
        Notify("Debug mode is disabled")
    end
end, false)

-- Admin command to reset cooldown and teleport state
RegisterCommand('resetjail', function()
    -- Check if player is admin (you can adjust this to fit your server's admin system)
    TriggerServerEvent("sl_teleport:checkAdmin")
end, false)

-- Debug command to force teleport - Enhance to be more robust
RegisterCommand('forceteleport', function()
    if Config.Debug then
        -- Enable teleport option
        teleportEnabled = true
        teleportLock = false
        
        -- Show position before teleport
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        Debug("Before force teleport - Position: x=" .. coords.x .. ", y=" .. coords.y .. ", z=" .. coords.z)
        
        -- Force teleport
        Notify("Debug: Forcing teleport...")
        DoTeleport()
        
        -- Check position after teleport
        Citizen.SetTimeout(1000, function()
            local newCoords = GetEntityCoords(playerPed)
            Debug("After force teleport - Position: x=" .. newCoords.x .. ", y=" .. newCoords.y .. ", z=" .. newCoords.z)
            
            -- Compare with destination
            local destCoords = Config.TeleportPoint.destination
            local dist = #(newCoords - destCoords)
            Debug("Distance to destination: " .. dist)
            
            if dist > 3.0 then
                Notify("Warning: Teleport may not have worked correctly!")
            else
                Notify("Teleport completed successfully!")
            end
        end)
    else
        Notify("Debug mode is disabled")
    end
end, false)

-- New command to get immediate position info
RegisterCommand('getpos', function()
    if Config.Debug then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local message = "Position: x=" .. coords.x .. ", y=" .. coords.y .. ", z=" .. coords.z
        VORPcore.NotifyLeft("Position", message, "generic_textures", "tick", 8000)
        
        -- Check if player is in cell
        local inCell = IsPlayerInsideCell()
        VORPcore.NotifyLeft("Cell Status", "In cell: " .. tostring(inCell), "generic_textures", "tick", 8000)
        
        Debug(message)
    else
        Notify("Debug mode is disabled")
    end
end, false)

-- Check dynamite and initiate teleport logic
RegisterNetEvent("sl_teleport:checkDynamite")
AddEventHandler("sl_teleport:checkDynamite", function()
    if HasDynamite() then
        TriggerServerEvent("sl_teleport:removeItem", Config.Dynamite.itemName)
        TriggerEvent("vorp:TipBottom", Config.Texts.PlacingDynamite, 3000)
        local player = PlayerPedId()
        
        -- Additional animation and effects could be added here
        
        Citizen.Wait(Config.Dynamite.fuse * 1000)
        TriggerEvent("vorp:TipBottom", Config.Texts.DynamiteExploded, 3000)
        
        -- Apply wanted level if configured
        if Config.Dynamite.addWantedLevel then
            TriggerServerEvent("sl_teleport:addBounty")
        end
        
        DoTeleport()
    else
        TriggerEvent("vorp:TipBottom", Config.Texts.NoDynamite, 3000)
    end
end)

-- Force teleport command for admins
RegisterNetEvent("sl_teleport:forceTP")
AddEventHandler("sl_teleport:forceTP", function()
    local beforeCoords = GetEntityCoords(PlayerPedId())
    Debug("Force teleport triggered from " .. vec3ToString(beforeCoords))
    DoTeleport()
    Citizen.Wait(1000)
    local afterCoords = GetEntityCoords(PlayerPedId())
    Debug("Force teleport complete. New position: " .. vec3ToString(afterCoords))
    local distanceMoved = #(beforeCoords - afterCoords)
    Debug("Total distance moved: " .. distanceMoved)
end)

-- Display notification for non-admin attempts
RegisterNetEvent("sl_teleport:notAdmin")
AddEventHandler("sl_teleport:notAdmin", function()
    TriggerEvent("vorp:TipBottom", Config.Texts.NoPermission, 3000)
end) 

-- Add an emergency teleport for debug purposes (LEFT ALT + F)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Config.Debug and teleportEnabled then
            if IsControlPressed(0, 0x8AAA0AD4) and IsControlJustPressed(0, 0x3B99E482) then -- LEFT ALT + F
                local playerPed = PlayerPedId()
                
                -- Debug notification
                Debug("!! EMERGENCY TELEPORT ACTIVATED !!")
                Notify("Emergency teleport activated!")
                
                -- Direct teleport with no frills
                local destCoords = Config.TeleportPoint.destination
                
                -- Simply move the player directly
                SetEntityCoords(playerPed, destCoords.x, destCoords.y, destCoords.z, false, false, false, false)
                
                -- Log outcome
                Citizen.SetTimeout(500, function()
                    local afterCoords = GetEntityCoords(playerPed)
                    local dist = #(afterCoords - destCoords)
                    Debug("Emergency teleport complete. Distance to target: " .. dist)
                end)
            end
        end
    end
end)

-- Register command for immediate teleport (for admins and debugging)
RegisterCommand('emergencytp', function()
    if Config.Debug then
        local playerPed = PlayerPedId()
        local destCoords = Config.TeleportPoint.destination
        
        Debug("Emergency teleport command used")
        Notify("Emergency teleport activated via command!")
        
        -- Direct teleport with minimal processing
        SetEntityCoords(playerPed, destCoords.x, destCoords.y, destCoords.z, false, false, false, false)
        
        -- Log the result
        Citizen.Wait(250)
        local finalCoords = GetEntityCoords(playerPed)
        Debug("Emergency teleport position: " .. vec3ToString(finalCoords))
    end
end, false) 