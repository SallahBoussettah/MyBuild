# sb_discord - RedM Discord Webhook System

A standalone resource for RedM that provides a centralized Discord webhook system for all anticheat modules.

## Features

- Centralized Discord notification management
- Support for multiple webhook channels for different types of alerts
- Configurable log levels to control notification volume
- Customizable message formatting and player identifier inclusion
- Export function for easy integration with other resources

## Installation

1. Extract the `sb_discord` folder to your server's `resources/[anticheat]` directory
2. Add `ensure sb_discord` to your server.cfg (load it early, before other anticheat modules)
3. Configure the settings in `config.lua` to your liking, including adding your Discord webhook URLs

## Configuration

```lua
Config = {}

-- Discord Integration Configuration
Config.Discord = {
    active = false,                 -- Master switch to enable/disable Discord notifications globally
    
    -- Webhook settings
    webhooks = {
        -- Main anticheat webhook
        anticheat = {
            url = "",               -- Discord webhook URL
            name = "RedM Anticheat",
            avatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
            color = 16711680,       -- Red color for messages (decimal format)
        },
        
        -- Optional separate webhooks for different types of alerts
        -- Uncomment and set these if you want different channels for different alert types
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
        includeIP = false       -- Be cautious with IP addresses due to privacy concerns
    }
}
```

## Usage for Developers

If you're developing another resource that needs to send Discord notifications, you can use the export function:

```lua
-- Call the export function with the required parameters
exports['sb_discord']:sendToDiscord(
    webhookType, -- String: The type of webhook to use (e.g., "anticheat", "network", etc.)
    playerId,    -- Number: The player's server ID (or nil if not player-related)
    title,       -- String: Title of the notification
    description, -- String: Main body text of the notification
    extraFields, -- Table: Additional fields to include in the embed (optional)
    logLevel     -- Number: The log level of this message (1-4, optional)
)

-- Example usage
exports['sb_discord']:sendToDiscord(
    "anticheat", 
    source, 
    "Speed Hack Detected", 
    "Player was detected using speed hacks",
    {
        {
            ["name"] = "Detection Method",
            ["value"] = "Heartbeat timing verification",
            ["inline"] = false
        }
    },
    1 -- Log level 1 (highest priority)
)
```

## Discord Webhook Setup

To set up a Discord webhook:

1. Open your Discord server settings
2. Go to "Integrations" > "Webhooks"
3. Click "New Webhook"
4. Name your webhook and select the channel
5. Copy the webhook URL
6. Paste the URL in the config.lua file

## License

MIT License - See LICENSE file for details

## Support

For support, bug reports, or suggestions, please create an issue on the GitHub repository. 