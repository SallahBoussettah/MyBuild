local VORPcore = {}
local dynamitePlaced = false
local dynamiteObj = nil
local countdownActive = false
local wallBroken = false
local cooldownActive = false
local dynamiteCoords = nil
local wallObject = nil
local wallObjectHash = 0

-- Initialize VORP Core
Citizen.CreateThread(function()
    TriggerEvent("getCore", function(core)
        VORPcore = core
    end)
end)

-- Debug function
local function Debug(msg)
    if Config.Debug then
        print("[VORP_WALLBREAK] " .. msg)
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

-- Check if player has the required item
local function HasDynamite()
    -- In debug mode, we'll assume the player has dynamite for testing
    if Config.Debug then
        return true
    end
    
    -- Get all inventory items and check if we have dynamite
    local items = exports.vorp_inventory:getInventoryItems()
    if items then
        for _, item in pairs(items) do
            if item.name == Config.Dynamite.itemName and item.count > 0 then
                return true
            end
        end
    end
    
    return false
end

-- Create a prompt for placing dynamite
local placeDynamitePrompt = nil
local promptGroup = GetRandomIntInRange(0, 0xffffff)

Citizen.CreateThread(function()
    local str = "Place Dynamite"
    placeDynamitePrompt = PromptRegisterBegin()
    PromptSetControlAction(placeDynamitePrompt, 0x760A9C6F) -- G key
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(placeDynamitePrompt, str)
    PromptSetEnabled(placeDynamitePrompt, true)
    PromptSetVisible(placeDynamitePrompt, true)
    PromptSetHoldMode(placeDynamitePrompt, true)
    PromptSetGroup(placeDynamitePrompt, promptGroup)
    PromptRegisterEnd(placeDynamitePrompt)
end)

-- Find wall object in area (For automatic detection)
local function FindWallObjectInArea()
    local pos = Config.BreakableWall.position
    local radius = Config.BreakableWall.radius
    local objects = GetGamePool('CObject')
    local closestDistance = radius
    local closestObj = nil
    
    for i = 1, #objects do
        local object = objects[i]
        if DoesEntityExist(object) then
            local objCoords = GetEntityCoords(object)
            local distance = #(pos - objCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestObj = object
            end
        end
    end
    
    return closestObj
end

-- Main loop variables
local placementLock = false -- Add a placement lock to prevent spamming
local lastPlacementTime = 0 -- Track when the last placement was attempted
local placementCooldown = 1000 -- 1 second cooldown between placement attempts

-- Main loop for checking proximity to wall and displaying prompt
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist = #(coords - Config.BreakableWall.position)
        
        -- Debug marker at the configured wall position
        if Config.DebugMarker and dist < 50.0 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, Config.BreakableWall.position.x, Config.BreakableWall.position.y, Config.BreakableWall.position.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 255, 0, 0, 155, 0, 0, 2, 0, 0, 0, 0)
        end
        
        -- Look for wall object if not found yet
        if wallObject == nil and dist < Config.BreakableWall.radius * 2 then
            wallObject = FindWallObjectInArea()
            if wallObject ~= nil and DoesEntityExist(wallObject) then
                wallObjectHash = GetEntityModel(wallObject)
                Debug("Found wall object: " .. wallObject .. " with hash: " .. wallObjectHash)
                Config.BreakableWall.objectHash = wallObjectHash
                
                -- Display the object hash for easier configuration
                if Config.Debug then
                    local hexHash = string.format("0x%08X", wallObjectHash)
                    Notify("Wall Object Found! Hash: " .. hexHash)
                end
            end
        end
        
        if dist < Config.BreakableWall.radius and not dynamitePlaced and not countdownActive and not wallBroken and not cooldownActive then
            -- Display info about the wall in debug mode
            if Config.Debug and wallObject ~= nil and DoesEntityExist(wallObject) then
                local objCoords = GetEntityCoords(wallObject)
                DrawText3D(objCoords.x, objCoords.y, objCoords.z, "Wall Object: " .. wallObject)
                local hexHash = string.format("0x%08X", wallObjectHash)
                DrawText3D(objCoords.x, objCoords.y, objCoords.z + 0.1, "Hash: " .. hexHash)
            end
            
            local promptText = CreateVarString(10, 'LITERAL_STRING', "Jail Wall")
            PromptSetActiveGroupThisFrame(promptGroup, promptText)
            
            -- Check for key press with placement lock to prevent spamming
            if PromptHasHoldModeCompleted(placeDynamitePrompt) and not placementLock then
                local currentTime = GetGameTimer()
                
                -- Only allow placement if cooldown has passed
                if currentTime - lastPlacementTime > placementCooldown then
                    lastPlacementTime = currentTime
                    placementLock = true -- Lock placement until the current attempt is resolved
                    
                    if HasDynamite() then
                        TriggerServerEvent("vorp_wallbreak:checkCooldown")
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
    local wallCoords = Config.BreakableWall.position
    local forward = GetEntityForwardVector(playerPed)
    local placementCoords = vector3(
        wallCoords.x,
        wallCoords.y,
        wallCoords.z - 0.5
    )
    
    dynamiteCoords = placementCoords
    
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
    TriggerServerEvent("vorp_wallbreak:removeDynamite")
    
    dynamitePlaced = true
    Notify(Config.Dynamite.notifications.placed)
    
    -- Start the countdown
    StartCountdown()
end

-- Countdown function
function StartCountdown()
    countdownActive = true
    local timeLeft = Config.Dynamite.countdownTime
    
    Citizen.CreateThread(function()
        while timeLeft > 0 do
            Citizen.Wait(1000)
            timeLeft = timeLeft - 1
            
            -- Display countdown text above dynamite
            Citizen.CreateThread(function()
                local endTime = GetGameTimer() + 1000
                while GetGameTimer() < endTime do
                    Citizen.Wait(0)
                    local coords = GetEntityCoords(dynamiteObj)
                    DrawText3D(coords.x, coords.y, coords.z + 0.5, string.format(Config.Dynamite.notifications.countdown, timeLeft))
                end
            end)
        end
        
        -- Trigger explosion when countdown reaches zero
        TriggerServerEvent("vorp_wallbreak:explode", dynamiteCoords)
    end)
end

-- Handle cooldown check response
RegisterNetEvent("vorp_wallbreak:cooldownCheck")
AddEventHandler("vorp_wallbreak:cooldownCheck", function(isOnCooldown)
    if isOnCooldown then
        Notify(Config.Dynamite.notifications.cooldown)
        -- Release the placement lock if on cooldown
        placementLock = false
    else
        PlaceDynamite()
        -- PlaceDynamite will set dynamitePlaced to true, 
        -- so we don't need to reset placementLock here
    end
end)

-- Handle explosion event from server
RegisterNetEvent("vorp_wallbreak:explosionEffect")
AddEventHandler("vorp_wallbreak:explosionEffect", function(coords)
    -- Play explosion audio
    PlaySoundFrontend("CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", true, 1)
    
    -- Create explosion particles and effects
    AddExplosion(coords.x, coords.y, coords.z, 23, 5.0, true, false, true)
    
    -- Delete the dynamite object
    if DoesEntityExist(dynamiteObj) then
        DeleteObject(dynamiteObj)
        dynamiteObj = nil
    end
    
    dynamitePlaced = false
    countdownActive = false
    placementLock = false -- Reset the placement lock after explosion
    
    -- Break the wall
    BreakWall()
end)

-- Break the wall function
function BreakWall()
    wallBroken = true
    
    -- Delete the wall object completely instead of just making it invisible
    if wallObject ~= nil and DoesEntityExist(wallObject) then
        -- First, set as no longer needed
        SetEntityAsNoLongerNeeded(wallObject)
        -- Then delete it
        DeleteObject(wallObject)
        
        if Config.Debug then
            Debug("Wall object deleted: " .. wallObject)
            Notify("Wall deleted. Object ID: " .. wallObject)
        end
    end
    
    -- Create the broken wall effect
    local wallCoords = Config.BreakableWall.position
    
    -- For each broken piece in the config, create it at the appropriate position
    for _, piece in ipairs(Config.BreakableWall.brokenPieces) do
        local model = GetHashKey(piece.model)
        RequestModel(model)
        
        -- Try alternative models if these don't exist
        if not HasModelLoaded(model) then
            Citizen.Wait(100)
            if not HasModelLoaded(model) then
                -- Try some common debris models
                local alternativeModels = {
                    "p_debrisboard01x",
                    "p_debrisboard02x", 
                    "p_debriswood01x",
                    "p_debriswood02x",
                    "p_debris01x"
                }
                
                for _, altModel in ipairs(alternativeModels) do
                    local altHash = GetHashKey(altModel)
                    RequestModel(altHash)
                    if HasModelLoaded(altHash) then
                        model = altHash
                        Debug("Using alternative debris model: " .. altModel)
                        break
                    end
                    Citizen.Wait(50)
                end
            end
        end
        
        local pieceCoords = vector3(
            wallCoords.x + piece.offset.x,
            wallCoords.y + piece.offset.y,
            wallCoords.z + piece.offset.z
        )
        
        local obj = CreateObject(model, pieceCoords.x, pieceCoords.y, pieceCoords.z, true, true, true)
        SetEntityRotation(obj, piece.rotation.x, piece.rotation.y, piece.rotation.z, 2, true)
        SetEntityVelocity(obj, math.random(-2, 2) * 0.5, math.random(-2, 2) * 0.5, math.random(0, 2) * 0.5)
    end
    
    -- Start the cooldown and repair timer
    TriggerServerEvent("vorp_wallbreak:startCooldown")
end

-- Handle cooldown
RegisterNetEvent("vorp_wallbreak:setCooldown")
AddEventHandler("vorp_wallbreak:setCooldown", function(status)
    cooldownActive = status
    
    if status then
        Citizen.CreateThread(function()
            Citizen.Wait(Config.WallRepairTime * 1000)
            wallBroken = false
            
            -- Recreate the wall object when repair time is up
            if wallBroken == false and (wallObject == nil or not DoesEntityExist(wallObject)) then
                -- Request the wall model
                local model = Config.BreakableWall.objectHash
                RequestModel(model)
                while not HasModelLoaded(model) do
                    Citizen.Wait(10)
                end
                
                -- Create new wall at original position
                local wallCoords = Config.BreakableWall.position
                wallObject = CreateObject(model, wallCoords.x, wallCoords.y, wallCoords.z, false, true, false)
                
                if Config.Debug then
                    Debug("Wall object recreated: " .. wallObject)
                    Notify("Wall repaired with new object ID: " .. wallObject)
                end
            end
        end)
    end
end)

-- Create alert for nearby law enforcement
RegisterNetEvent("vorp_wallbreak:alertLaw")
AddEventHandler("vorp_wallbreak:alertLaw", function(coords)
    -- Create a blip at the jail break location
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords.x, coords.y, coords.z)
    Citizen.InvokeNative(0x74F74D3207ED525C, blip, Config.Alerts.blip.sprite, 1)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip, Config.Alerts.blip.color)
    
    local blipName = CreateVarString(10, 'LITERAL_STRING', Config.Alerts.blip.name)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipName)
    
    -- Remove the blip after a set duration
    Citizen.SetTimeout(Config.Alerts.lawBlipDuration * 1000, function()
        RemoveBlip(blip)
    end)
    
    -- Play a sound and show notification
    PlaySoundFrontend("Witness", "Wanted_Sounds", true, 0)
    Notify(Config.Alerts.lawNotification)
end)

-- Register a command to get information about the wall object
RegisterCommand('wallinfo', function()
    if Config.Debug then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist = #(coords - Config.BreakableWall.position)
        
        if dist < Config.BreakableWall.radius * 2 then
            local wallObj = FindWallObjectInArea()
            if wallObj ~= nil and DoesEntityExist(wallObj) then
                local objHash = GetEntityModel(wallObj)
                local hexHash = string.format("0x%08X", objHash)
                local objCoords = GetEntityCoords(wallObj)
                
                local message = "Wall Object: " .. wallObj .. "\nHash: " .. hexHash .. "\nPosition: " .. tostring(objCoords)
                VORPcore.NotifyLeft("Wall Information", message, "generic_textures", "tick", 8000)
                
                -- Update configuration variables
                wallObject = wallObj
                wallObjectHash = objHash
                Config.BreakableWall.objectHash = objHash
                Config.BreakableWall.position = objCoords
                
                Debug(message)
            else
                Notify("No wall object found nearby")
            end
        else
            Notify("Get closer to the wall position")
        end
    else
        Notify("Debug mode is disabled")
    end
end, false)

-- Admin command to reset wall
RegisterCommand('resetwall', function()
    -- Check if player is admin (you can adjust this to fit your server's admin system)
    TriggerServerEvent("vorp_wallbreak:checkAdmin")
end, false)

-- Event handler for admin verification and wall reset
RegisterNetEvent("vorp_wallbreak:resetWall")
AddEventHandler("vorp_wallbreak:resetWall", function()
    -- Clean up any existing wall object
    if wallObject ~= nil and DoesEntityExist(wallObject) then
        SetEntityAsNoLongerNeeded(wallObject)
        DeleteObject(wallObject)
        wallObject = nil
    end
    
    -- Clear any debris objects in the area
    local wallCoords = Config.BreakableWall.position
    local radius = 10.0 -- Search within a 10 unit radius
    local objects = GetGamePool('CObject')
    
    for i = 1, #objects do
        local object = objects[i]
        if DoesEntityExist(object) then
            local objCoords = GetEntityCoords(object)
            local distance = #(wallCoords - objCoords)
            
            -- If within radius and not the player or other important objects
            if distance < radius and not IsPedAPlayer(object) then
                -- Check if it's one of our debris models
                local objModel = GetEntityModel(object)
                local modelName = GetEntityArchetypeName(object)
                
                if string.find(modelName, "debris") or string.find(modelName, "p_debris") then
                    SetEntityAsNoLongerNeeded(object)
                    DeleteObject(object)
                end
            end
        end
    end
    
    -- Create a new wall
    local model = Config.BreakableWall.objectHash
    if model ~= 0 then
        RequestModel(model)
        local timeout = 0
        while not HasModelLoaded(model) and timeout < 100 do
            Citizen.Wait(10)
            timeout = timeout + 1
        end
        
        if HasModelLoaded(model) then
            wallObject = CreateObject(model, wallCoords.x, wallCoords.y, wallCoords.z, false, true, false)
            wallObjectHash = model
            
            -- Reset all states
            wallBroken = false
            dynamitePlaced = false
            countdownActive = false
            
            -- Notify the server to reset cooldown
            TriggerServerEvent("vorp_wallbreak:resetCooldown")
            
            Notify("Wall has been reset by admin")
            Debug("Wall reset by admin command")
        else
            Notify("Failed to load wall model. Hash: " .. model)
        end
    else
        Notify("No wall model hash found. Use /wallinfo first to detect the wall.")
    end
end)