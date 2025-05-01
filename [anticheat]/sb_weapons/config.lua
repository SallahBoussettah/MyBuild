Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "Weapons & Health Protection",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}

-- Infinite Ammo Protection
-- Prevents players from using infinite ammo hacks
Config.InfiniteAmmo = { 
    active = true,
    checkInterval = 1000, -- milliseconds between checks
}

-- Weapon Blacklist Protection
-- Prevents specified weapons from being used in the game
Config.Weapons = { 
    active = true,
    checkInterval = 1000, -- milliseconds between checks
    
    -- Blacklisted weapons that will be automatically removed when detected
    blacklist = {
        -- Example weapons that might be blocked
        -- Uncomment or add more as needed
        
        -- [GetHashKey("weapon_bow")] = true,
        -- [GetHashKey("weapon_bow_improved")] = true,
        -- [GetHashKey("weapon_pistol_volcanic")] = true,
        -- [GetHashKey("weapon_repeater_henry")] = true,
        -- [GetHashKey("weapon_rifle_elephant")] = true,
        -- [GetHashKey("weapon_sniperrifle_rollingblock")] = true,
        
        -- You can find weapon hashes here:
        -- https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua
    },
    
    -- Notification settings
    notification = {
        enabled = true,
        message = "Blacklisted weapon removed"
    }
}

-- Player Health Protection
-- Prevents players from using health hacks to set their health higher than allowed
Config.PlayerStatus = { 
    active = true,
    checkInterval = 1000, -- milliseconds between checks
    health = 600, -- Maximum allowed health value (regular max health is around 600)
                  -- Golden core health is around 2088, use higher value if you allow golden cores
    lang = {
        kickreason = "Health hack detected"
    }
} 