--[[ 
    SL Position - A simple position display script
    Author: Salah
    Version: 1.0.0
    
    This script shows the current player position coordinates on screen.
    Use F3 or /pos to toggle the display, /heading to toggle heading display,
    and /posformat to cycle through different coordinate formats.
]]

local displayActive = false
local showHeading = Config.Display.showHeading
local currentFormat = Config.Display.format
local VORPcore = {}

-- Initialize VORP Core for notifications (if needed)
Citizen.CreateThread(function()
    TriggerEvent("getCore", function(core)
        VORPcore = core
    end)
end)

-- Debug function
local function Debug(msg)
    if Config.Debug then
        print("[SL_POSITION] " .. msg)
    end
end

-- Function to display position
local function DisplayPosition()
    Citizen.CreateThread(function()
        Debug("Position display activated")
        
        while displayActive do
            Wait(0)
            
            -- Get player position
            local playerPed = PlayerPedId()
            local pos = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            
            -- Format the coordinates based on user preference
            local formatString = ""
            local precision = Config.Display.precision
            local x = string.format("%." .. precision .. "f", pos.x)
            local y = string.format("%." .. precision .. "f", pos.y)
            local z = string.format("%." .. precision .. "f", pos.z)
            local h = string.format("%." .. precision .. "f", heading)
            
            if currentFormat == 1 then
                -- Vector3 format
                formatString = "vector3(" .. x .. ", " .. y .. ", " .. z .. ")"
                if showHeading then
                    formatString = formatString .. "\nHeading: " .. h
                end
            elseif currentFormat == 2 then
                -- Individual format
                formatString = "X: " .. x .. ", Y: " .. y .. ", Z: " .. z
                if showHeading then
                    formatString = formatString .. "\nHeading: " .. h
                end
            else
                -- Compact format
                formatString = x .. ", " .. y .. ", " .. z
                if showHeading then
                    formatString = formatString .. ", " .. h
                end
            end
            
            -- Display the text with background
            local screenX = Config.Display.x
            local screenY = Config.Display.y
            
            -- Calculate background size based on text length and format
            local bgWidth = (string.len(formatString) * 0.0065) * Config.Display.scale
            local bgHeight = 0.023 * Config.Display.scale
            if showHeading and currentFormat < 3 then
                bgHeight = bgHeight * 1.6  -- Taller background for multiline text
            end
            
            -- Draw background
            DrawRect(
                screenX + (bgWidth / 2), 
                screenY + (bgHeight / 2), 
                bgWidth, 
                bgHeight, 
                Config.Display.bgColor.r, 
                Config.Display.bgColor.g, 
                Config.Display.bgColor.b, 
                Config.Display.bgColor.a
            )
            
            -- Draw text
            SetTextScale(Config.Display.scale, Config.Display.scale)
            SetTextColor(
                Config.Display.color.r, 
                Config.Display.color.g, 
                Config.Display.color.b, 
                Config.Display.color.a
            )
            SetTextFontForCurrentCommand(Config.Display.font)
            SetTextCentre(false)
            DisplayText(CreateVarString(10, "LITERAL_STRING", formatString), screenX, screenY)
            
            -- Draw additional info: script name and controls
            SetTextScale(Config.Display.scale * 0.6, Config.Display.scale * 0.6)
            SetTextColor(200, 200, 200, 180)
            DisplayText(CreateVarString(10, "LITERAL_STRING", "SL Position - F3 to toggle"), screenX, screenY + bgHeight + 0.005)
        end
    end)
end

-- Toggle position display
local function TogglePositionDisplay()
    displayActive = not displayActive
    
    if displayActive then
        -- Start displaying position
        DisplayPosition()
        Debug("Position display enabled")
    else
        Debug("Position display disabled")
    end
end

-- Toggle heading display
local function ToggleHeadingDisplay()
    showHeading = not showHeading
    Debug("Heading display: " .. tostring(showHeading))
    
    -- Show notification
    local message = showHeading and "Heading display enabled" or "Heading display disabled"
    TriggerEvent("vorp:TipBottom", message, 3000)
end

-- Cycle through format options
local function CycleFormat()
    currentFormat = currentFormat + 1
    if currentFormat > 3 then
        currentFormat = 1
    end
    
    local formatNames = {
        [1] = "Vector3",
        [2] = "Detailed",
        [3] = "Compact"
    }
    
    Debug("Format changed to: " .. formatNames[currentFormat])
    TriggerEvent("vorp:TipBottom", "Position format: " .. formatNames[currentFormat], 3000)
end

-- Register key mapping for toggle
Citizen.CreateThread(function()
    -- Wait for game to initialize
    Citizen.Wait(1000)
    
    -- Main loop to check for key press
    while true do
        Citizen.Wait(0)
        
        -- Check for toggle key press (F3)
        if IsControlJustPressed(0, Config.ToggleKey) then
            TogglePositionDisplay()
        end
    end
end)

-- Register commands
RegisterCommand(Config.Commands.toggle, function()
    TogglePositionDisplay()
end, false)

RegisterCommand(Config.Commands.heading, function()
    ToggleHeadingDisplay()
end, false)

RegisterCommand(Config.Commands.format, function()
    CycleFormat()
end, false)

-- Add a command to copy coordinates to clipboard
RegisterCommand('copypos', function()
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Format for easy copy/paste
    local posString = string.format("vector3(%.4f, %.4f, %.4f)", pos.x, pos.y, pos.z)
    
    -- Display notification
    TriggerEvent("vorp:TipBottom", "Position copied: " .. posString, 5000)
    Debug("Position copied: " .. posString .. ", Heading: " .. string.format("%.2f", heading))
end, false)

-- Display help text on first load
Citizen.CreateThread(function()
    Citizen.Wait(5000) -- Wait for game to fully load
    TriggerEvent("vorp:TipBottom", "SL Position loaded. Press F3 or type /pos to toggle position display", 8000)
    Debug("SL Position script initialized")
end) 