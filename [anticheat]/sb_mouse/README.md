# sb_mouse - RedM Mouse Spam Protection

A standalone resource for RedM that detects and prevents excessive mouse clicking which could be used for cheating or exploits.

## Features

- Detects rapid mouse clicks that could indicate macro usage or spam exploits
- Configurable tolerance for detection sensitivity
- Warning notification to players before taking action
- Automatic kick for persistent offenders
- Discord integration for logging incidents

## Installation

1. Extract the `sb_mouse` folder to your server's `resources/[anticheat]` directory
2. Add `ensure sb_mouse` to your server.cfg (after sb_discord if you're using Discord integration)
3. Configure the settings in `config.lua` to your liking

## Configuration

```lua
Config = {}

-- Mouse Spam Protection Configuration
Config.MouseSpam = {
    active = true,                  -- Enable/disable the entire system
    
    -- Click tracking settings
    infractions = 0,                -- Initial infraction count
    maxInfractions = 5,             -- Maximum allowed infractions before kick
    sensitivity = 250,              -- Milliseconds between clicks considered spam (lower = more sensitive)
    
    -- Warning settings
    warningMessage = true,          -- Display warning message to player before kicking
    warningDuration = 5000,         -- How long to show warning message (milliseconds)
    
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
```

## How it Works

The mouse spam protection works through monitoring click frequency:

1. The client tracks timestamps of mouse button presses
2. If clicks occur too rapidly (faster than the configured sensitivity), an infraction is counted
3. After a certain number of infractions, a warning is displayed to the player
4. If the player continues spamming clicks, they are kicked from the server
5. Infractions are reset after a period of normal behavior

This system prevents:
- Rapid-fire weapon exploits
- Click-based duplication glitches
- Automated clicking scripts and macros
- Server resource overload from excessive input events

## Fine-Tuning

Adjusting the detection system:

- Reduce `sensitivity` to make the system more strict (e.g., 150ms)
- Increase `maxInfractions` to be more lenient before kicking (e.g., 8-10)
- Adjust `resetTime` based on your server's gameplay style

These settings should be balanced to avoid false positives while still catching genuine abuse attempts.

## Discord Integration

This module can integrate with sb_discord to send notifications about mouse spam incidents:

1. Ensure you have sb_discord installed and configured
2. Set `Config.Discord.active = true` in config.lua
3. Make sure the webhook type is properly configured in sb_discord

## License

MIT License - See LICENSE file for details

## Support

For support, bug reports, or suggestions, please create an issue on the GitHub repository. 