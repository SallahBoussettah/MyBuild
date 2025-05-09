# sb_network - RedM Network Connection Check

A standalone resource for RedM that monitors player network connectivity and kicks players with unstable connections.

## Features

- Reliable detection of network connection issues using a heartbeat system
- Configurable tolerance for connection issues before kicking
- Configurable kick delay to prevent false positives
- Discord webhook integration for logging kicked players

## Installation

1. Extract the `sb_network` folder to your server's `resources/[anticheat]` directory
2. Add `ensure sb_network` to your server.cfg
3. Configure the settings in `config.lua` to your liking

## Configuration

```lua
Config = {}

-- Network Connection Check Configuration
Config.Network = {
    active = true,                  -- Enable/disable the entire system
    allowedOffenses = 2,            -- Number of failed checks before kicking
    checkInterval = 5000,           -- Milliseconds between heartbeat checks
    kickDelay = 20000,              -- Milliseconds before kick after failed checks
    
    -- Language settings
    lang = {
        kickReason = "You must be connected to the internet."
    }
}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,                 -- Enable/disable Discord notifications
    webhookAvatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookName = "Network Connection Protection",
    webhook = "",                   -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}
```

## How it Works

The network check system operates through a simple heartbeat mechanism:

1. The server sends a heartbeat event to each connected player at regular intervals
2. Players with active network connections respond with a confirmation event
3. If a player fails to respond multiple times, they are considered to have connection issues
4. After a configurable delay, the player is kicked from the server

This is more reliable than simply checking ping, as it verifies the actual bidirectional communication capability.

## License

MIT License - See LICENSE file for details

## Support

For support, bug reports, or suggestions, please create an issue on the GitHub repository. 