Config = {}

-- Network Connection Check Configuration
-- Ensures players maintain stable connection to the server
Config.Network = {
    active = true,
    allowedOffenses = 2,        -- Number of failed checks before kicking
    checkInterval = 5000,       -- Milliseconds between heartbeat checks
    kickDelay = 20000,          -- Milliseconds before kick after failed checks
    
    -- Language settings
    lang = {
        kickReason = "You must be connected to the internet."
    }
}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookAvatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookName = "Network Connection Protection",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
} 