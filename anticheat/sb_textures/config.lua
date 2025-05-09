Config = {}

-- Texture Detection Configuration
-- Identifies and prevents usage of specific texture dictionaries often associated with cheat menus
Config.Textures = {
    active = true,
    checkInterval = 1000,    -- Milliseconds between checks
    
    -- List of blacklisted texture dictionaries 
    -- Add names of texture dictionaries that are associated with mod menus
    list = {
        -- "example_texture_dict",
        -- Add texture dictionaries to blacklist here
    },
    
    -- Language settings
    lang = {
        kickReason = "Prohibited texture detected"
    }
}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookAvatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookName = "Texture Detection Protection",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
} 