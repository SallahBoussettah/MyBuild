# sb_xss - RedM XSS Protection System

A standalone resource for RedM that prevents cross-site scripting (XSS) attacks through player usernames and validates playernames for security.

## Features

- Detects potential XSS payloads in player usernames
- Blocks players with suspicious or malicious usernames
- Configurable patterns for detecting common XSS techniques
- Integration with sb_discord for notification logging

## Installation

1. Extract the `sb_xss` folder to your server's `resources/[anticheat]` directory
2. Add `ensure sb_xss` to your server.cfg (after sb_discord if you're using Discord integration)
3. Configure the settings in `config.lua` to your liking

## Configuration

```lua
Config = {}

-- XSS Protection Configuration
Config.XSS = {
    active = true,                  -- Enable/disable the entire system
    
    -- Block players with potentially malicious usernames
    blockInjectionAttempts = true,
    
    -- Validate and update Steam usernames on connection
    validateSteamNames = true,
    
    -- Maximum allowed username length
    maxUsernameLength = 32,
    
    -- Regular expressions for username validation
    -- These patterns detect common XSS payload attempts
    patterns = {
        '<[^>]*>',              -- HTML tags
        'javascript:',          -- JavaScript protocol
        'onerror=',             -- JavaScript event handlers
        'onload=',              -- JavaScript event handlers
        -- ...more patterns...
    },
    
    -- Language settings
    lang = {
        reason = "XSS Injection Attempt Detected",
        update = "Validating Steam Username",
        kick = "You cannot join due to your username"
    }
}

-- Discord webhook settings (using sb_discord if available)
Config.Discord = {
    active = false,      -- Set to true to enable webhook notifications using sb_discord
    webhookType = "xss", -- Webhook type to use (must be defined in sb_discord config)
    logLevel = 1,        -- Log level for Discord notifications
    
    lang = {
        kickTitle = "XSS Protection - Player Blocked",
        kickReason = "Blocked for potential XSS attack in username"
    }
}
```

## How it Works

The XSS protection system works by:

1. Intercepting player connection attempts
2. Validating the player's username against a set of patterns that could indicate malicious content
3. Blocking the connection if suspicious patterns are detected
4. Logging the incident to console and optionally to Discord

This helps protect against attacks where malicious users attempt to use their usernames to inject harmful code into your server's web interfaces or Discord embeds.

## Why XSS Protection is Important

XSS attacks can be used to:
- Steal cookies and session tokens
- Redirect users to malicious websites
- Execute arbitrary code in the browser context
- Deface websites or alter their content

In the context of a game server, XSS can particularly affect:
- Server dashboard interfaces
- Discord bot interactions
- Community websites displaying player information

## Discord Integration

This module can integrate with sb_discord to send notifications about blocked XSS attempts:

1. Ensure you have sb_discord installed and configured
2. Set `Config.Discord.active = true` in config.lua
3. Make sure the webhook type is properly configured in sb_discord

## License

MIT License - See LICENSE file for details

## Support

For support, bug reports, or suggestions, please create an issue on the GitHub repository. 