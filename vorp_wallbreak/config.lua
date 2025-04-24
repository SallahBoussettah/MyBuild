Config = {}

-- Enable debug mode to help identify the correct wall
Config.Debug = true

-- The wall that can be broken
Config.BreakableWall = {
    -- Strawberry jail wall with precise coordinates from wallinfo command
    position = vector3(-1814.496, -355.9884, 161.8523), -- Exact position from wallinfo
    radius = 2.5, -- Increased radius for easier testing
    objectHash = 0x6548D9DB, -- Wall hash identified with wallinfo
    
    -- We'll use generic debris objects for now
    brokenPieces = {
        {model = "p_debris01x", offset = vector3(0.0, 0.0, 0.0), rotation = vector3(0.0, 0.0, 0.0)},
        {model = "p_debris02x", offset = vector3(0.5, 0.2, 0.0), rotation = vector3(10.0, 5.0, 15.0)},
        {model = "p_debris03x", offset = vector3(-0.6, 0.3, 0.0), rotation = vector3(-5.0, 8.0, -10.0)},
    }
}

-- Dynamite settings
Config.Dynamite = {
    itemName = "dynamite", -- The name of the dynamite item in your inventory system
    countdownTime = 10, -- Time in seconds before explosion
    explosionRange = 3.0, -- Range of the explosion effect
    placementDuration = 3000, -- Time in ms that it takes to place the dynamite (animation time)
    cooldownTime = 3600, -- Cooldown in seconds before another wall break can be attempted (1 hour)
    modelObject = "p_dynamite01x", -- The model of the dynamite object that appears on the wall
    
    -- Notification texts
    notifications = {
        noItem = "You don't have any dynamite to place",
        placing = "Placing dynamite...",
        placed = "Dynamite has been placed. Get away quickly!",
        countdown = "Dynamite will explode in %s seconds!",
        cooldown = "The jail walls were recently damaged. You must wait before attempting another break.",
        cannotPlace = "You can't place dynamite here.",
    }
}

-- Alert settings
Config.Alerts = {
    range = 100.0, -- How far the explosion can be heard
    lawNotification = "Prison break attempt in progress at Strawberry Jail!", -- Notification for law enforcement
    lawBlipDuration = 300, -- Duration in seconds for the law enforcement blip (5 minutes)
    
    -- Blip settings for the map
    blip = {
        sprite = 486, -- Blip sprite ID
        color = 1, -- Red color
        name = "Prison Break in Progress", -- Blip name
    }
}

-- After breaking the wall, how long until it gets "repaired" (in seconds)
Config.WallRepairTime = 86400 -- 24 hours

-- Debug helper function to identify the wall object
Config.DebugMarker = true -- Set to true to see a marker at the configured position