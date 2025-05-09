# sb_resource - RedM Resource Injection Protection

A standalone resource for RedM that detects and prevents resource injection attacks commonly used by cheaters.

## Features

- Detects injected resources by comparing client and server resource lists
- Protects against common cheat menu injection techniques
- Automatic kick for players detected using injected resources
- Discord webhook integration for logging detections

## Installation

1. Extract the `sb_resource` folder to your server's `resources/[anticheat]` directory
2. Add `ensure sb_resource` to your server.cfg (load it early in your startup order)
3. Configure the settings in `config.lua` to your liking

## Configuration

```lua
Config = {}

-- Resource Injection Detection Configuration
Config.ResourceProtection = {
    active = true,                  -- Enable/disable the entire system
    checkInterval = 500,            -- Milliseconds between checks for client resources
    
    -- Language settings
    lang = {
        kickReason = "Cheat Menu Detected"
    }
}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,                 -- Enable/disable Discord notifications
    webhookAvatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookName = "Resource Injection Protection",
    webhook = "",                   -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}
```

## How it Works

The resource injection protection works through resource list verification:

1. The server maintains a list of all valid resources
2. The client periodically reports its resource list to the server
3. The server verifies each client resource against the server's list
4. If a client has a resource that doesn't exist on the server, it's considered an injection

Additionally, the system has anti-tampering checks to prevent bypass attempts.

## Security Considerations

While this system is effective against many cheat detection methods, determined cheaters may attempt to bypass it. Additional protection layers are recommended for a comprehensive anti-cheat solution:

- Combine with other anti-cheat modules
- Use server-side validation for all important game mechanics
- Regularly update your protection systems

## License

MIT License - See LICENSE file for details

## Support

For support, bug reports, or suggestions, please create an issue on the GitHub repository. 