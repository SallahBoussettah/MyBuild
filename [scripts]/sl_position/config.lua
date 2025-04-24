Config = {}

-- Enable debug mode to show additional information
Config.Debug = false

-- Position display settings
Config.Display = {
    -- Position on screen (0.0-1.0)
    x = 0.175,  -- Left side of screen
    y = 0.03,   -- Near the top
    
    -- Visual settings
    scale = 0.4,
    font = 1,
    
    -- Text color (RGBA)
    color = {
        r = 255, 
        g = 255, 
        b = 255, 
        a = 255
    },
    
    -- Background color (RGBA)
    bgColor = {
        r = 0, 
        g = 0, 
        b = 0, 
        a = 120  -- Semi-transparent
    },
    
    -- Whether to include the heading in the display
    showHeading = true,
    
    -- Format to use (1: Vector3, 2: Individual, 3: Compact)
    -- 1: vector3(x, y, z)
    -- 2: X: 123.45, Y: 123.45, Z: 123.45
    -- 3: 123.45, 123.45, 123.45
    format = 2,
    
    -- Number of decimal places to display
    precision = 4
}

-- Key to toggle the position display (default: F3)
-- See: https://docs.fivem.net/docs/game-references/controls/
Config.ToggleKey = 0x3B99E482  -- F3 key

-- Commands
Config.Commands = {
    toggle = "pos",     -- Toggle position display
    heading = "heading", -- Toggle heading display
    format = "posformat" -- Cycle through different formats
} 