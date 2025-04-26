local MinePrompt
local active = false
local tool, hastool, UsePrompt, PropPrompt
local swing = 0
local MinedRocks = {}
local nearby_rocks
local rockGroup = GetRandomIntInRange(0, 0xffffff)
local T = Translation.Langs[Lang]
local Core = exports.vorp_core:GetCore()

-- Mining zones integration
local sbMiningZonesAvailable = false
local successRateModifier = 1.0

-- Local configuration for mining zones integration
local MiningZoneConfig = {
    StrictRestriction = true,
    RestrictedMiningMessage = "You can only mine in designated mining areas!",
    ReducedSuccessOutsideZones = false,
    OutsideZoneSuccessModifier = 0.3
}

-- Check if sb_miningzone resource is available
CreateThread(function()
    -- Wait longer initially to give other resources time to load exports
    Wait(5000) 
    local resourceState = GetResourceState('sb_miningzone')
    print("Mining Init Debug: sb_miningzone state: ", resourceState) -- DEBUG
    if resourceState == "started" or resourceState == "starting" then
        sbMiningZonesAvailable = true
        print("VORP Mining: Detected sb_miningzone resource, mining restrictions will be applied.")
        
        -- Try to get configuration from sb_miningzone
        Wait(2000) -- Extra wait before reading exports
        local exportedStrict = exports.sb_miningzone:GetConfigValue("StrictRestriction")
        print("Mining Init Debug: Exported StrictRestriction value: ", exportedStrict) -- DEBUG
        MiningZoneConfig.StrictRestriction = exportedStrict or MiningZoneConfig.StrictRestriction
        
        local exportedMessage = exports.sb_miningzone:GetConfigValue("RestrictedMiningMessage")
        MiningZoneConfig.RestrictedMiningMessage = exportedMessage or MiningZoneConfig.RestrictedMiningMessage
        
        local exportedReduced = exports.sb_miningzone:GetConfigValue("ReducedSuccessOutsideZones")
        MiningZoneConfig.ReducedSuccessOutsideZones = exportedReduced or MiningZoneConfig.ReducedSuccessOutsideZones
        
        local exportedModifier = exports.sb_miningzone:GetConfigValue("OutsideZoneSuccessModifier")
        MiningZoneConfig.OutsideZoneSuccessModifier = exportedModifier or MiningZoneConfig.OutsideZoneSuccessModifier
        
        print("Mining Init Debug: Final MiningZoneConfig.StrictRestriction: ", MiningZoneConfig.StrictRestriction) -- DEBUG
    else
        sbMiningZonesAvailable = false -- Explicitly set false if resource not found
        print("Mining Init Debug: sb_miningzone NOT detected or not started.") -- DEBUG
    end
    print("Mining Init Debug: sbMiningZonesAvailable flag set to: ", sbMiningZonesAvailable) -- DEBUG
end)

-- Function to check if player can mine here (integrates with sb_miningzone)
local function CanMineHere()
    if not sbMiningZonesAvailable then
        return true -- If mining zones resource not available, allow mining everywhere
    end
    
    -- Check if player is in a mining zone by using the export directly
    local isAllowed = false
    
    if exports.sb_miningzone:IsPlayerInMiningZone().inZone then
        isAllowed = true
    else
        if MiningZoneConfig.StrictRestriction then
            Core.NotifyRightTip(MiningZoneConfig.RestrictedMiningMessage, 4000)
            isAllowed = false
        else
            -- Allow mining but with reduced success rate
            TriggerEvent("vorp_mining:setSuccessModifier", MiningZoneConfig.OutsideZoneSuccessModifier)
            isAllowed = true
        end
    end
    
    return isAllowed
end

-- Event for sb_miningzone to set success modifier
RegisterNetEvent("vorp_mining:setSuccessModifier")
AddEventHandler("vorp_mining:setSuccessModifier", function(modifier)
    successRateModifier = modifier
end)

-- Event for sb_miningzone to cancel mining
RegisterNetEvent("vorp_mining:cancelMining")
AddEventHandler("vorp_mining:cancelMining", function()
    if active then
        active = false
        removeToolFromPlayer()
        releasePlayer()
    end
end)

-- Add an event to indicate mining has finished
RegisterNetEvent("vorp_mining:finishedMining")
AddEventHandler("vorp_mining:finishedMining", function()
    -- This is just an event for sb_miningzone to catch
end)

CreateThread(function()
    repeat Wait(1000) until LocalPlayer.state.IsInSession
    local str = T.PromptLabels.mineLabel
    MinePrompt = Citizen.InvokeNative(0x04F97DE45A519419)
    PromptSetControlAction(MinePrompt, Config.MinePromptKey)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(MinePrompt, str)
    PromptSetEnabled(MinePrompt, true)
    PromptSetVisible(MinePrompt, true)
    PromptSetHoldMode(MinePrompt, true)
    PromptSetGroup(MinePrompt, rockGroup)
    PromptRegisterEnd(MinePrompt)
end)


local function GetRockNearby(coords, radius, hash_filter)
    local itemSet = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, radius, itemSet, 3, Citizen.ResultAsInteger())
    local found_entity

    if size > 0 then
        for index = 0, size - 1 do
            local entity = GetIndexedItemInItemset(index, itemSet)
            local model_hash = GetEntityModel(entity)

            if hash_filter[model_hash] then
                local rock_coords = GetEntityCoords(entity)
                local rock_x, rock_y, rock_z = table.unpack(rock_coords)

                found_entity = {
                    model_name = hash_filter[model_hash],
                    entity = entity,
                    model_hash = model_hash,
                    vector_coords = rock_coords,
                    x = rock_x,
                    y = rock_y,
                    z = rock_z,
                }

                break
            end
        end
    end

    if IsItemsetValid(itemSet) then
        DestroyItemset(itemSet)
    end

    return found_entity
end

local function isPlayerReadyToMineRocks(player)
    if IsPedOnMount(player) then
        return false
    end

    if IsPedInAnyVehicle(player, false) then
        return false
    end

    if IsPedDeadOrDying(player, false) then
        return false
    end

    if IsEntityInWater(player) then
        return false
    end

    if IsPedClimbing(player) then
        return false
    end

    if not IsPedOnFoot(player) then
        return false
    end

    return true
end

local function coordsToString(coords)
    return Round(coords[1], 1) .. '-' .. Round(coords[2], 1) .. '-' .. Round(coords[3], 1)
end

local function isRockAlreadyMined(coords)
    local coords_string = coordsToString(coords)
    local result = MinedRocks[coords_string] == true
    return result
end

local function rememberRockAsMined(coords)
    local coords_string = coordsToString(coords)
    MinedRocks[coords_string] = true
end

local function forgetRockAsMined(coords)
    local coords_string = coordsToString(coords)
    MinedRocks[coords_string] = nil
end

local function GetTown(x, y, z)
    return Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 1)
end

local function isInRestrictedTown(restricted_towns, player_coords)
    player_coords = player_coords or GetEntityCoords(PlayerPedId())

    local x, y, z = table.unpack(player_coords)
    local town_hash = GetTown(x, y, z)

    if town_hash == false then
        return false
    end

    if restricted_towns[town_hash] then
        return true
    end

    return false
end

local function getUnMinedNearbyRock(allowed_model_hashes, player, player_coords)
    player = player or PlayerPedId()

    if not isPlayerReadyToMineRocks(player) then
        return nil
    end

    player_coords = player_coords or GetEntityCoords(player)

    local found_nearby_rocks = GetRockNearby(player_coords, 1.3, allowed_model_hashes)

    if not found_nearby_rocks then
        return nil
    end

    if isRockAlreadyMined(found_nearby_rocks.vector_coords) then
        return nil
    end

    return found_nearby_rocks
end

local function showStartMineBtn()
    local MiningGroupName = CreateVarString(10, 'LITERAL_STRING', T.PromptLabels.mineDesc)
    PromptSetActiveGroupThisFrame(rockGroup, MiningGroupName)
end

local function checkStartMineBtnPressed(rock)
    if PromptHasHoldModeCompleted(MinePrompt) then
        active = true
        local player = PlayerPedId()
        SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true, 0, false, false)
        Wait(500)
        TriggerServerEvent("vorp_mining:pickaxecheck", rock.vector_coords)
    end
end

local function convertConfigRocksToHashRegister()
    local model_hashes = {}

    for _, model_name in pairs(Config.Rocks) do
        local model_hash = GetHashKey(model_name)
        model_hashes[model_hash] = model_name
    end

    return model_hashes
end

local function waitForStartKey(rock)
    showStartMineBtn()
    checkStartMineBtnPressed(rock)
    Wait(0)
end

local function convertConfigTownRestrictionsToHashRegister()
    local restricted_towns = {}

    for _, town_restriction in pairs(Config.TownRestrictions) do
        if not town_restriction.mine_allowed then
            local town_hash = GetHashKey(town_restriction.name)
            restricted_towns[town_hash] = town_restriction.name
        end
    end

    return restricted_towns
end

local function manageStartMinePrompt(restricted_towns, player_coords)
    -- Always enable and make visible the prompt if this function is called,
    -- because the main loop already verified we are in a valid sb_miningzone
    -- and found a rock.
    PromptSetEnabled(MinePrompt, true)
    PromptSetVisible(MinePrompt, true) -- Ensure prompt is visible
end

CreateThread(function()
    repeat Wait(1000) until LocalPlayer.state.IsInSession

    local allowed_rock_model_hashes = convertConfigRocksToHashRegister()
    local restricted_towns = convertConfigTownRestrictionsToHashRegister()

    while true do
        if active == false then
            local player = PlayerPedId()
            local player_coords = GetEntityCoords(player)
            local can_search_for_rocks = true -- Default: allow searching
            local is_in_zone = false -- Default: assume outside zone unless checked

            -- Check if zone restriction applies from sb_miningzone
            if sbMiningZonesAvailable and MiningZoneConfig.StrictRestriction then
                -- If strict mode is ON, default to FALSE, only set true if IN the zone
                can_search_for_rocks = false 
                is_in_zone = exports.sb_miningzone:IsPlayerInMiningZone().inZone
                
                if is_in_zone then
                    can_search_for_rocks = true -- Allow searching only when confirmed inside
                end
                -- DEBUG PRINT
                print("Mining Debug: In Zone? ", is_in_zone)
            else
                -- If zone script isn't running or strict mode is OFF, allow searching everywhere (original VORP behavior)
                can_search_for_rocks = true
            end

            -- DEBUG PRINT
            print("Mining Debug: Can Search For Rocks? ", can_search_for_rocks)

            -- Proceed based on the zone check
            if can_search_for_rocks then
                -- Player is allowed to be here (either in a zone, or sb_miningzone is not active/strict)
                -- Find nearby unmined rocks
                local found_rock = getUnMinedNearbyRock(allowed_rock_model_hashes, player, player_coords)
                
                -- DEBUG PRINT
                if found_rock then print("Mining Debug: Found Rock Model Hash: ", found_rock.model_hash) else print("Mining Debug: No Rock Found Nearby") end

                if found_rock and not isRockAlreadyMined(found_rock.vector_coords) then
                    -- A valid rock is nearby
                    nearby_rocks = found_rock -- Set the target rock for the other thread
                    -- Manage the prompt based on town restrictions (original logic)
                    -- This will enable the prompt if not town-restricted
                    manageStartMinePrompt(restricted_towns, player_coords)
                else
                    -- No valid rock found nearby, or it was already mined
                    nearby_rocks = nil -- Clear target
                    -- Don't explicitly hide the prompt here, let the absence of nearby_rocks handle it in the second thread
                end
            else
                -- Player is outside a required sb_miningzone mining zone
                nearby_rocks = nil -- Ensure no rock target
                -- Explicitly hide the mining prompt
                if MinePrompt then
                     PromptSetEnabled(MinePrompt, false)
                     PromptSetVisible(MinePrompt, false)
                end
            end
        else
            -- Player is currently active (mining), ensure prompt is hidden just in case
            if MinePrompt then
                 PromptSetEnabled(MinePrompt, false)
                 PromptSetVisible(MinePrompt, false)
            end
        end
        Wait(500) -- Wait before next check
    end
end)

CreateThread(function()
    repeat Wait(1000) until LocalPlayer.state.IsInSession
    while true do
        if active == false and nearby_rocks then
            waitForStartKey(nearby_rocks)
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent("vorp_mining:pickaxechecked", function(rock)
    GoMine(rock)
end)

RegisterNetEvent("vorp_mining:nopickaxe", function()
    active = false
end)

local function releasePlayer()
    if PropPrompt then
        PromptSetEnabled(PropPrompt, false)
        PromptSetVisible(PropPrompt, false)
    end

    if UsePrompt then
        PromptSetEnabled(UsePrompt, false)
        PromptSetVisible(UsePrompt, false)
    end

    FreezeEntityPosition(PlayerPedId(), false)
end

local function removeMiningPrompt()
    if MinePrompt then
        PromptSetEnabled(MinePrompt, false)
        PromptSetVisible(MinePrompt, false)
    end
end

local function removeToolFromPlayer()
    hastool = false

    if not tool then
        return
    end
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xED00D72F81CF7278, tool, 1, 1)
    DeleteObject(tool)
    Citizen.InvokeNative(0x58F7DB5BD8FA2288, ped) -- Cancel Walk Style
    ClearPedDesiredLocoForModel(ped)
    ClearPedDesiredLocoMotionType(ped)

    tool = nil
end

local function rockFinished(rock)
    swing = 0

    rememberRockAsMined(rock)
    Wait(2300)
    removeToolFromPlayer()

    active = false

    SetTimeout(1800000, function()
        forgetRockAsMined(rock)
    end)
end


function GoMine(rock)
    EquipTool('p_pickaxe01x', 'Swing')
    local swingcount = math.random(Config.MinSwing, Config.MaxSwing)
    
    -- Create thread to check if player leaves mining zone while mining
    local keepCheckingMiningZone = true
    if sbMiningZonesAvailable and MiningZoneConfig.StrictRestriction then
        CreateThread(function()
            while keepCheckingMiningZone and active do
                if not exports.sb_miningzone:IsPlayerInMiningZone().inZone then
                    Core.NotifyRightTip("You left the mining zone!", 4000)
                    if active then
                        active = false
                        removeToolFromPlayer()
                        releasePlayer()
                        keepCheckingMiningZone = false
                    end
                end
                Wait(1000)
            end
        end)
    end
    
    while hastool == true do
        FreezeEntityPosition(PlayerPedId(), true)
        if IsControlJustReleased(0, Config.StopMiningKey) or IsPedDeadOrDying(PlayerPedId(), false) then
            rockFinished(rock)
        elseif IsControlJustPressed(0, Config.MineRockKey) then
            PromptSetEnabled(UsePrompt, false)
            local randomizer = math.random(Config.maxDifficulty, Config.minDifficulty)
            swing = swing + 1
            Anim(ped, 'amb_work@world_human_pickaxe_new@working@male_a@trans', 'pre_swing_trans_after_swing', -1, 0)
            local testplayer = exports["syn_minigame"]:taskBar(randomizer, 7)
            
            -- Apply success rate modifier
            local success = false
            if testplayer == 100 then
                -- Apply success rate modifier (from mining zones)
                local chance = math.random(1, 100)
                if chance <= (100 * successRateModifier) then
                    success = true
                end
            end
            
            if success then
                TriggerServerEvent('vorp_mining:addItem')
            else
                local minning_fail_txt_index = math.random(1, #T)
                local minning_fail_txt = T[minning_fail_txt_index]
                TriggerEvent("vorp:TipRight", minning_fail_txt, 3000)
            end
            
            Wait(500)
            PromptSetEnabled(UsePrompt, true)
        end

        if swing == swingcount then
            PromptSetEnabled(UsePrompt, false)
            rockFinished(rock)
        end
        Wait(0)
    end
    
    keepCheckingMiningZone = false
    releasePlayer()
    active = false
    -- Notify sb_miningzone that mining has finished
    TriggerEvent("vorp_mining:finishedMining")
end

function EquipTool(toolhash, prompttext, holdtowork)
    hastool = false
    Citizen.InvokeNative(0x6A2F820452017EA2) -- Clear Prompts from Screen
    if tool then
        DeleteEntity(tool)
    end
    Wait(500)
    FPrompt()
    LMPrompt(prompttext, Config.MineRockKey, holdtowork)
    ped = PlayerPedId()
    tool = CreateObject(toolhash, GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 0.0), true, true, true)
    AttachEntityToEntity(tool, ped, GetPedBoneIndex(ped, 7966), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1, 0, 0);
    Citizen.InvokeNative(0x923583741DC87BCE, ped, 'arthur_healthy')
    Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, "carry_pitchfork")
    Citizen.InvokeNative(0x2208438012482A1A, ped, true, true)
    ForceEntityAiAndAnimationUpdate(tool, true)
    Citizen.InvokeNative(0x3A50753042B6891B, ped, "PITCH_FORKS")
    Wait(500)
    PromptSetEnabled(PropPrompt, true)
    PromptSetVisible(PropPrompt, true)
    PromptSetEnabled(UsePrompt, true)
    PromptSetVisible(UsePrompt, true)

    hastool = true
end

function FPrompt(text, button, hold)
    CreateThread(function()
        PropPrompt = nil
        local str = T.PromptLabels.keepPickaxe
        local buttonhash = button or Config.StopMiningKey
        local holdbutton = hold or false
        PropPrompt = PromptRegisterBegin()
        PromptSetControlAction(PropPrompt, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(PropPrompt, str)
        PromptSetEnabled(PropPrompt, false)
        PromptSetVisible(PropPrompt, false)
        PromptSetHoldMode(PropPrompt, holdbutton)
        PromptRegisterEnd(PropPrompt)
    end)
end

function LMPrompt(text, button, hold)
    CreateThread(function()
        UsePrompt = nil
        local str = T.PromptLabels.usePickaxe
        local buttonhash = button or Config.MineRockKey
        UsePrompt = PromptRegisterBegin()
        PromptSetControlAction(UsePrompt, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(UsePrompt, str)
        PromptSetEnabled(UsePrompt, false)
        PromptSetVisible(UsePrompt, false)
        if hold then
            PromptSetHoldIndefinitelyMode(UsePrompt)
        end
        PromptRegisterEnd(UsePrompt)
    end)
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        local timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout > 0) do
            timeout = timeout - 1
            if timeout == 0 then
                print("Animation Failed to Load")
            end
            Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag, 1, false, 0, false, "", true)
        Wait(dur)
        RemoveAnimDict(dict)
    end)
end

function Round(num, decimals)
    if type(num) ~= "number" then
        return num
    end

    local multiplier = 10 ^ (decimals or 0)
    return math.floor(num * multiplier + 0.5) / multiplier
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    removeToolFromPlayer()
    releasePlayer()
    removeMiningPrompt()
end)

RegisterNetEvent("vorp_mining:usePickaxe", function(playerCoords)
    -- Check if player is near a rock
    local player = PlayerPedId()
    local allowed_rock_model_hashes = convertConfigRocksToHashRegister()
    local restricted_towns = convertConfigTownRestrictionsToHashRegister()
    
    -- First check if we can mine in this location (mining zone check)
    if not CanMineHere() then
        return -- The notification is already handled in CanMineHere
    end
    
    -- Only allow mining if not in a restricted town (this is VORP Mining's original town restriction)
    if isInRestrictedTown(restricted_towns, GetEntityCoords(player)) then
        Core.NotifyRightTip(T.NotifyLabels.cantMineHere, 3000)
        return
    end
    
    local rock = getUnMinedNearbyRock(allowed_rock_model_hashes, player)
    
    if rock then
        -- If rock found, proceed with mining
        if not active then
            active = true
            TriggerServerEvent("vorp_mining:pickaxecheck", rock.vector_coords)
        end
    else
        -- No suitable rock found nearby
        Core.NotifyRightTip(T.NotifyLabels.noRocksNearby, 3000)
    end
end)
