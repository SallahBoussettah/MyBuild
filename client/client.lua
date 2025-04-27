-- Add this variable at the top of the file with other global variables
local isMenuActive = false

-- Add this function to handle player control when menu is active
function ControlPlayerInMenu()
    local playerPed = PlayerPedId()
    
    -- Disable player movement while in menu
    if isMenuActive then
        DisableControlAction(0, 0x8FD015D8, true) -- Disable movement (W key)
        DisableControlAction(0, 0xD27782E3, true) -- Disable movement (S key)
        DisableControlAction(0, 0x7065027D, true) -- Disable movement (A key)
        DisableControlAction(0, 0xB4E465B4, true) -- Disable movement (D key)
        DisableControlAction(0, 0xD9D0E1C0, true) -- Disable jump
        DisableControlAction(0, 0xE8342FF2, true) -- Disable crouch
        
        -- Make the player stay in idle animation
        ClearPedTasks(playerPed)
        if not IsEntityPlayingAnim(playerPed, "script_rc@mrlk@ig@ig_1_meetjohn", "idle", 3) then
            RequestAnimDict("script_rc@mrlk@ig@ig_1_meetjohn")
            while not HasAnimDictLoaded("script_rc@mrlk@ig@ig_1_meetjohn") do
                Wait(100)
            end
            TaskPlayAnim(playerPed, "script_rc@mrlk@ig@ig_1_meetjohn", "idle", 8.0, -8.0, -1, 1, 0, false, false, false)
        end
    end
end

-- Modify OpenStoreMainMenu function to set the flag
function OpenStoreMainMenu(storeId, buyItems, sellItems, storeCfg)
    MenuData.CloseAll()
    isMenuActive = true -- Set flag when opening menu
    
    -- ... rest of the existing function code ...
end

-- Modify CloseStoreMenu function to release player control
function CloseStoreMenu()
    -- Use pcall to safely close all menus
    pcall(function() MenuData.CloseAll() end)
    isInMenu = false
    isMenuActive = false -- Reset flag when closing menu
    ClearPedTasks(PlayerPedId()) -- Clear any animations
    Config.UI(false)
end

-- Add this thread to continuously check and control the player while in menu
CreateThread(function()
    while true do
        if isMenuActive then
            ControlPlayerInMenu()
            Wait(0) -- Need to check every frame when active
        else
            Wait(1000) -- Check less frequently when not in menu
        end
    end
end) 