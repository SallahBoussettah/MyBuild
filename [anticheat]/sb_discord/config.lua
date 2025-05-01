Config = {}

-- Discord Integration Configuration
-- Centralized webhook management for all anticheat modules
Config.Discord = {
    active = false,          -- Master switch to enable/disable Discord notifications globally
    
    -- Webhook settings
    webhooks = {
        -- Main anticheat webhook
        anticheat = {
            url = "",        -- Discord webhook URL
            name = "RedM Anticheat",
            avatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
            color = 16711680, -- Red color for messages (decimal format)
        },
        
        -- Optional separate webhooks for different types of alerts
        -- Uncomment and set these if you want different channels for different alert types
        
        -- network = {
        --     url = "",
        --     name = "Network Protection",
        --     avatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
        --     color = 16711680,
        -- },
        -- resources = {
        --     url = "",
        --     name = "Resource Protection",
        --     avatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
        --     color = 16711680,
        -- },
    },
    
    -- Default text components
    lang = {
        kick = "Kicked for: ",
        warning = "Warning: ",
        
        -- Standard fields in notifications
        fields = {
            playerName = "Player Name",
            playerId = "Player ID",
            steam = "Steam",
            license = "License",
            discord = "Discord ID",
            ip = "IP Address",
            reason = "Reason"
        }
    },
    
    -- Log Level (1-4)
    -- 1: Kicks only
    -- 2: Kicks and important warnings
    -- 3: All warnings and notable events
    -- 4: Debug information (verbose)
    logLevel = 2,
    
    -- Identifier settings
    identifiers = {
        includeSteam = true,
        includeLicense = true,
        includeDiscord = true, 
        includeIP = false      -- Be cautious with IP addresses due to privacy concerns
    }
} 