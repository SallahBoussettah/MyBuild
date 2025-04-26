Config = {}

-- Enable debug mode (shows blips and debug messages)
Config.Debug = true

-- Time in ms to check if player is in a mining zone (don't set too low to avoid performance issues)
Config.CheckInterval = 1000

-- Default message when trying to mine outside a designated area
Config.RestrictedMiningMessage = "You can only mine in designated mining areas. Find the mining zones on your map!"

-- Show blips on the map for mining zones?
Config.ShowMiningZoneBlips = true

-- Blip configuration
Config.Blip = {
    sprite = 1258184551, -- Mining blip sprite
    color = 46,          -- Blip color
    name = "Mining Zone", -- Blip name on map
    scale = 0.8          -- Blip size
}

-- Mining zones definitions
-- Format: { x, y, z, radius, name, description, allow_mining }
Config.MiningZones = {
    {
        coords = {x = -1424.001, y = 1176.164, z = 226.345}, -- Grizzlies Mining Area (example)
        radius = 20.0,
        name = "Grizzlies Mining Area 1",
        description = "A prime mining location rich with various ores.",
        allow_mining = true,
        blip = true -- Show blip for this zone
    },
    {
        coords = {x = -1432.4906, y = 1175.9758, z = 226.5609}, -- Grizzlies Mining Area (example)
        radius = 20.0,
        name = "Grizzlies Mining Area 2",
        description = "A prime mining location rich with various ores.",
        allow_mining = true,
        blip = true -- Show blip for this zone
    },
    {
        coords = {x = -1423.1715, y = 1171.1313, z = 226.3418}, -- Grizzlies Mining Area (example)
        radius = 20.0,
        name = "Grizzlies Mining Area 3",
        description = "A prime mining location rich with various ores.",
        allow_mining = true,
        blip = true -- Show blip for this zone
    },
    {
        coords = {x = 2276.6150, y = 1060.7690, z = 78.6585}, -- Annesburg Mine (example)
        radius = 150.0,
        name = "Annesburg Mining Area 1",
        description = "The official Annesburg mining operation.",
        allow_mining = true,
        blip = true
    },
    {
        coords = {x = 2312.1311, y = 1071.8284, z = 87.6673}, -- Annesburg Mine (example)
        radius = 100.0,
        name = "Annesburg Mining Area 2",
        description = "The official Annesburg mining operation.",
        allow_mining = true,
        blip = true
    },
    {
        coords = {x = 2284.0823, y = 1082.8972, z = 83.5878}, -- Annesburg Mine (example)
        radius = 100.0,
        name = "Annesburg Mining Area 3",
        description = "The official Annesburg mining operation.",
        allow_mining = true,
        blip = true
    },
    {
        coords = {x = -5977.8154, y = -3164.4519, z = -3.8800}, -- Mount Hagen (example)
        radius = 80.0,
        name = "Mount Hagen Mining Site",
        description = "High altitude mining site with premium ore deposits.",
        allow_mining = true,
        blip = true
    }
}

-- Do you want to COMPLETELY restrict mining outside of zones?
Config.StrictRestriction = true

-- Instead of completely restricting mining, you can reduce success chance outside zones
Config.ReducedSuccessOutsideZones = false -- Only works if StrictRestriction is false
Config.OutsideZoneSuccessModifier = 0.3 -- 30% of normal success chance 