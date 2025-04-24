Config = {}

-- Enable debug mode to help testing
Config.Debug = true

-- The teleport interaction point inside the cell
Config.TeleportPoint = {
    -- Strawberry jail cell teleport point
    position = vector3(-1812.50, -355.99, 161.85), -- Position inside the cell for teleporting out
    radius = 1.0, -- Reduced radius to ensure teleport option only appears inside the cell area
    
    -- Destination outside the cell where players will be teleported to
    destination = vector3(-1814.50, -359.3, 161.85), -- Updated to exact coordinates from screenshot
}

-- Dynamite settings
Config.Dynamite = {
    itemName = "dynamite", -- The name of the dynamite item in your inventory system
    countdownTime = 10, -- Time in seconds before explosion
    explosionRange = 3.0, -- Range of the explosion effect
    placementDuration = 3000, -- Time in ms that it takes to place the dynamite (animation time)
    cooldownTime = 3600, -- Cooldown in seconds before another dynamite can be placed (1 hour)
    modelObject = "p_dynamite01x", -- The model of the dynamite object that appears on the wall
    placementPosition = vector3(-1814.50, -355.99, 161.85), -- Position outside the cell where dynamite can be placed
    placementRadius = 1.0, -- Even smaller radius for placing dynamite to prevent cell interior placement
    outsideCellOnly = true, -- New setting to prevent players inside the cell from placing dynamite
    
    -- Notification texts
    notifications = {
        noItem = "You don't have any dynamite to place",
        placing = "Placing dynamite...",
        placed = "Dynamite has been placed. Get away quickly!",
        countdown = "Dynamite will explode in %s seconds!",
        cooldown = "The jail was recently damaged. You must wait before attempting another break.",
        cannotPlace = "You can't place dynamite here.",
        insideCell = "You cannot place dynamite from inside the cell."
    }
}

-- Teleport settings
Config.Teleport = {
    -- Check if player is inside a cell (limited area) before showing teleport option
    insideCellCheck = true,
    
    -- Area that defines "inside the cell" - only players in this area will see the teleport option
    cellArea = {
        center = vector3(-1812.80, -354.90, 161.42), -- Adjusted to be more centered in the actual cell
        width = 2.8, -- Reduced width of the cell area
        length = 4, -- Reduced length of the cell area
        height = 3.0, -- Reduced height of the cell area
        rotation = 65.0, -- Rotation angle in degrees (0 = aligned with world coordinates)
    },
    
    animationDict = "amb_misc@world_human_pray@male_a@idle_b", -- Animation dictionary
    animationName = "idle_d", -- Animation to play when teleporting
    animationDuration = 3000, -- Time in ms that it takes to teleport (animation time)
    
    -- Notification texts
    notifications = {
        teleporting = "Preparing to teleport...",
        teleported = "You've teleported outside the cell!",
        cooldown = "Someone recently teleported. You must wait before attempting another teleport.",
        cannotTeleport = "You can't teleport here.",
        notInCell = "You must be inside the cell to teleport out."
    }
}

-- Alert settings for law enforcement
Config.Alerts = {
    enabled = true, -- Set to true to alert law enforcement when someone teleports
    range = 100.0, -- How far the teleport can be noticed
    lawNotification = "Prison break in progress at Strawberry Jail!", -- Notification for law enforcement
    lawBlipDuration = 300, -- Duration in seconds for the law enforcement blip (5 minutes)
    
    -- Blip settings for the map
    blip = {
        sprite = 486, -- Blip sprite ID
        color = 1, -- Red color
        name = "Prison Break in Progress", -- Blip name
    }
}

-- After an explosion, how long until the teleport option disappears (in seconds)
Config.TeleportActiveTime = 86400 -- 24 hours

-- Global cooldown between teleports (in seconds)
Config.Cooldown = 300 -- 5 minutes

-- Debug helper function to identify the cell area
Config.DebugMarker = true -- Set to true to see markers at the configured positions 