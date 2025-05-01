-- Object blacklist protection system
-- Detects and removes blacklisted objects from the game world

-- Debug utility function
local function DebugLog(message)
    if Config.Objects.debug then
        print("^3[DEBUG:sb_objects]^7 " .. message)
    end
end

-- Function to properly delete an object entity
local function DeleteObject(object)
    if DoesEntityExist(object) then
        -- Request control of the entity
        NetworkRequestControlOfEntity(object)
        
        -- Wait for control (important for networked objects)
        local timeout = 0
        while not NetworkHasControlOfEntity(object) and timeout < 50 do
            Wait(1)
            timeout = timeout + 1
        end
        
        -- Detach and prep for deletion
        DetachEntity(object, 0, false)
        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        
        -- Delete the entity
        DeleteEntity(object)
        
        -- Notify server for logging (if object deletion was successful)
        if not DoesEntityExist(object) then
            local model = GetEntityModel(object) or "unknown"
            TriggerServerEvent("sb_objects:objectRemoved", model)
            
            -- Show notification if enabled
            if Config.Objects.notification.enabled then
                TriggerEvent("vorp:TipBottom", Config.Objects.notification.message, 3000)
            end
            
            DebugLog("Successfully deleted blacklisted object: " .. model)
            return true
        end
    end
    
    return false
end

-- Main object detection thread
Citizen.CreateThread(function()
    -- Wait for game to load fully
    Citizen.Wait(5000)
    
    -- Show startup message in debug mode
    DebugLog("Object protection system active")
    
    while true do
        -- Only run if feature is active
        if Config.Objects.active then
            -- Find all objects in the world
            local handle, object = FindFirstObject()
            local finished = false
            
            repeat
                Wait(1)
                
                -- Check if this object is in the blacklist
                local model = GetEntityModel(object)
                if Config.Objects.blacklist[model] then
                    DebugLog("Found blacklisted object: " .. model)
                    DeleteObject(object)
                end
                
                -- Get next object
                finished, object = FindNextObject(handle)
            until not finished
            
            -- Close the finder
            EndFindObject(handle)
        end
        
        -- Small delay to avoid excessive CPU usage
        Wait(1000)
    end
end)

-- Event handler for developer debug mode - add object under crosshair to console
if Config.Objects.debug then
    RegisterCommand("checkobject", function()
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local forward = GetEntityForwardVector(playerPed)
        local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, 
                                           coords.x + forward.x * 10.0, 
                                           coords.y + forward.y * 10.0, 
                                           coords.z + forward.z * 10.0, 
                                           16, playerPed, 0)
        local _, hit, endCoords, _, entity = GetShapeTestResult(rayHandle)
        
        if hit == 1 and DoesEntityExist(entity) and IsEntityAnObject(entity) then
            local model = GetEntityModel(entity)
            local modelName = "Unknown"
            
            print("^2[sb_objects]^7 Object detected:")
            print("^2[sb_objects]^7 Hash: " .. model)
            print("^2[sb_objects]^7 Add to config with: [" .. model .. "] = true,")
        else
            print("^2[sb_objects]^7 No object detected in front of player")
        end
    end, false)
end 