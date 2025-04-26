Config = {}

-- Enable debug mode (shows blips and debug messages)
Config.Debug = true

-- Time in ms to check if player is in a mining zone (don't set too low to avoid performance issues)
Config.CheckInterval = 1000

-- Default message when trying to mine outside a designated area
Config.RestrictedMiningMessage = "You can only mine in designated mining areas. Find the mining zones on your map!"

-- Show blips on the map for mining zones?
Config.ShowMiningZoneBlips = true

-- if you have UI you want to hide use it in this function
-- remove what you dont use
Config.UI = function(state)
    if state then
        --ExecuteCommand("hideneeds hidden")
        --ExecuteCommand("hideui")
        TriggerEvent('vorpmetabolism:setHud', false)
    else
        --ExecuteCommand("hideneeds visible")
        --ExecuteCommand("showui")
        TriggerEvent('vorpmetabolism:setHud', true)
    end
end

-- Blip configuration
Config.Blip = {
    sprite = 1258184551, -- Mining blip sprite
    color = 46,          -- Blip color
    name = "Mining Zone", -- Blip name on map
    scale = 0.8          -- Blip size
}

-- Mining Store configuration
Config.MiningStores = {
    GrizzliesStore = {
        isDeactivated = false,
        useRandomLocation = false,
        possibleLocations = {
            OpenMenu = {},
            Npcs = {}
        },
        Blip = {
            Allowed = true,
            Name = "Grizzlies Mining Store",
            sprite = 1475879922,
            Pos = vector3(-1392.6552, 1155.5912, 224.4771),
        },
        Npc = {
            Pos = vector4(-1392.6552, 1155.5912, 224.4771, 137.3867),
            distanceRemoveNpc = 20.0,
            Allowed = true,
            Model = "U_M_M_BHT_MINEFOREMAN",
        },
        storeName = "Grizzlies Mining Store",
        PromptName = "mining store",
        distanceOpenStore = 3.0,
        AllowedJobs = {},
        JobGrade = 0,
        category = {
            { label = "Tools", Type = "tools", desc = "Mining equipment", img = "butcher_table_production" },
            { label = "Ore", Type = "ore", desc = "Mining ores and materials", img = "provision_gold_nugget" },
        },
        storeType = {
            { label = "Buy", Type = "buy", desc = "Buy mining equipment", img = "consumable_bread_roll" },
            { label = "Sell", Type = "sell", desc = "Sell mining materials", img = "butcher_table_production" },
        },
        StoreHoursAllowed = true,
        RandomPrices = true,
        StoreOpen = 6, -- 6 AM
        StoreClose = 22, -- 10 PM
        DynamicStore = true,
    }
}

-- Mining zones definitions
-- Format: { x, y, z, radius, name, description, allow_mining }
Config.MiningZones = {
    {
        coords = {x = -1421.2853, y = 1171.9752, z = 226.3315}, -- Grizzlies Mining Area (example)
        radius = 20.0,
        name = "Grizzlies Mining Area1",
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