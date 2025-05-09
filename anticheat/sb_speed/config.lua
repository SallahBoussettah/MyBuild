Config = {}

-- Speed Hack Detection Configuration
-- Detects and handles players who might be using time manipulation hacks
Config.Speed = {
    active = true,
    heartbeatInterval = 30000,  -- Milliseconds between heartbeats (client to server)
    timeTolerance = 15,         -- Seconds - Maximum time difference allowed before detection
    
    -- Language settings
    lang = {
        kickReason = "Speed hacking detected"
    }
}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookAvatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookName = "Speed Hack Protection",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
} 