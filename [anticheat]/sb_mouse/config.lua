Config = {}

-- Mouse Spam Protection Configuration
-- Detects and blocks rapid mouse click spam that could be used for exploits
Config.MouseSpam = {
    active = true,
    
    -- Click tracking settings
    infractions = 0,                -- Initial infraction count
    maxInfractions = 15,             -- Maximum allowed infractions before kick
    sensitivity = 250,              -- Milliseconds between clicks considered spam (lower = more sensitive)
    
    -- Warning settings
    warningMessage = true,          -- Display warning message to player before kicking
    warningDuration = 3000,         -- How long to show warning message (milliseconds)
    
    -- Reset settings
    resetTime = 60000,              -- Time in milliseconds to reset infraction count if no new spam detected
    
    -- Language settings
    lang = {
        kickReason = "Spam Clicking Detected",
        warning = "You are spam clicking! This will lead to being kicked if you continue."
    }
}

-- Discord webhook settings (using sb_discord if available)
Config.Discord = {
    active = false,          -- Set to true to enable webhook notifications using sb_discord
    webhookType = "mouse",   -- Webhook type to use (must be defined in sb_discord config)
    logLevel = 1,            -- Log level for Discord notifications
    
    lang = {
        kickTitle = "Mouse Spam Detection",
        kickReason = "Kicked for excessive mouse spam clicking"
    }
} 