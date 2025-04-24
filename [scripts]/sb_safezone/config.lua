Config = {}

-- General Settings
Config.Debug = false                  -- Enable visual debug mode (shows zone boundaries)
Config.GodModeInSafeZone = false      -- Makes players invincible in safe zones
Config.NotificationTime = 3000        -- How long notifications should show (in ms)

-- UI Settings
Config.UseCustomUI = true             -- Set to false to use VORP notifications instead of custom UI
Config.UIPosition = "top-center"      -- Options: "top-center", "top-right", "top-left"

-- Language Settings
Config.Language = {
    EnteringSafeZone = "You have entered a Safe Zone",
    NoFighting = "NO FIGHTING IN THIS ZONE",
    ZonePrefix = "Safe Zone: "        -- Text shown before zone name
}

-- Safe Zones - Add or modify zones as needed
Config.SafeZones = {
    ['Town Center'] = {
        {x = -328.82, y = 773.82, z = 117.49, radius = 15.0}, 
    },
    ['Stable'] = {
        {x = -367.73, y = 787.72, z = 116.26, radius = 8.0},
    },
    -- Stable outside
    ['Stable'] = {
        {x = -392.9447, y = 781.4302, z = 115.7335, radius = 15.0},
    },
    ['Saloon'] = {
        {x = -325.29, y = 766.24, z = 117.48, radius = 10.0}
    },
    ['Sheriff Office'] = {
        {x = -276.5383, y = 808.6055, z = 119.3790, radius = 8.0}
    }
    -- Add more zones as needed
} 