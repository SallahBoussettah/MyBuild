Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "Object Protection",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        message = "Player tried to spawn blacklisted object: "
    }
}

-- Objects Blacklist Configuration
-- Prevents specified objects from being spawned in the game world
Config.Objects = { 
    active = true,
    
    -- Enable debug mode to log information about detected objects (useful for setup)
    debug = false,
    
    -- Blacklisted objects that will be automatically deleted when detected
    blacklist = {
        -- Example objects that are often used by modders/hackers
        [GetHashKey("prop_asteroid_01")] = true,
        [GetHashKey("p_benchnbx02x")] = true,
        [GetHashKey("p_cs_campfire02x")] = true,
        [GetHashKey("p_campfire05x")] = true,
        [GetHashKey("p_bench09x")] = true,
        [GetHashKey("prop_bench_01a")] = true,
        [GetHashKey("prop_bench_01b")] = true,
        [GetHashKey("prop_bench_01c")] = true,
        [GetHashKey("p_telegraph_pole01x")] = true,
        [GetHashKey("prop_traffic_01a")] = true,
        
        -- Common RedM objects used in trolling
        -- Add more objects as needed
        
        -- Format: [GetHashKey("object_name")] = true,
        -- You can view objects at https://redlookup.com/objects
    },
    
    -- Notification settings
    notification = {
        enabled = true,
        message = "Blacklisted object detected and removed"
    }
} 