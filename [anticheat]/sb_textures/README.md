# sb_textures - RedM Texture Detection System

A standalone resource for RedM that detects and prevents usage of specific texture dictionaries that are often associated with cheat menus.

## Features

- Monitors for known cheat menu texture dictionaries
- Instantly kicks players using blacklisted textures
- Configurable texture blacklist
- Discord webhook integration for logging detections

## Installation

1. Extract the `sb_textures` folder to your server's `resources/[anticheat]` directory
2. Add `ensure sb_textures` to your server.cfg
3. Configure the settings in `config.lua` to your liking, including adding texture dictionaries to the blacklist

## Configuration

```lua
Config = {}

-- Texture Detection Configuration
Config.Textures = {
    active = true,                  -- Enable/disable the entire system
    checkInterval = 1000,           -- Milliseconds between checks
    
    -- List of blacklisted texture dictionaries 
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
    active = false,                 -- Enable/disable Discord notifications
    webhookAvatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookName = "Texture Detection Protection",
    webhook = "",                   -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}
```

## How it Works

The texture detection system:

1. Periodically checks if any blacklisted texture dictionaries are loaded in the client
2. When a blacklisted texture is detected, the server is notified
3. The server kicks the player and logs the detection to Discord if configured

## How to Find Textures to Blacklist

To find texture dictionaries used by mod menus:

1. Obtain knowledge of common mod menu texture dictionaries (through research)
2. Add these to the blacklist in the configuration
3. Test regularly to ensure you're not blocking legitimate textures

## License

MIT License - See LICENSE file for details

## Support

For support, bug reports, or suggestions, please create an issue on the GitHub repository. 