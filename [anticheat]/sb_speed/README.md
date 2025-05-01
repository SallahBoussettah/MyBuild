# sb_speed - RedM Speed Hack Detection

A standalone resource for RedM that detects and prevents players from using time manipulation hacks to gain unfair advantages.

## Features

- Detects time manipulation hacks by tracking heartbeat intervals
- Configurable tolerance for detection sensitivity
- Automatic kick for players detected using speed hacks
- Discord webhook integration for logging detections

## Installation

1. Extract the `sb_speed` folder to your server's `resources/[anticheat]` directory
2. Add `ensure sb_speed` to your server.cfg
3. Configure the settings in `config.lua` to your liking

## Configuration

```lua
Config = {}

-- Speed Hack Detection Configuration
Config.Speed = {
    active = true,                  -- Enable/disable the entire system
    heartbeatInterval = 30000,      -- Milliseconds between heartbeats (client to server)
    timeTolerance = 15,             -- Seconds - Maximum time difference allowed before detection
    
    -- Language settings
    lang = {
        kickReason = "Speed hacking detected"
    }
}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,                 -- Enable/disable Discord notifications
    webhookAvatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookName = "Speed Hack Protection",
    webhook = "",                   -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}
```

## How it Works

The speed hack detection works through a timing mechanism:

1. The client sends a heartbeat to the server at a fixed interval (set in configuration)
2. The server tracks the time between heartbeats from each client
3. If a heartbeat arrives too quickly (faster than the configured tolerance), it indicates:
   - Either the client is using a time manipulation hack to speed up their game
   - Or they're using a packet manipulation tool to send events faster than normal
4. When detected, the player is kicked and the incident is logged

## Fine-Tuning

Adjusting the detection system:

- Increase `heartbeatInterval` to reduce server load (but less accurate detection)
- Decrease `timeTolerance` for more sensitive detection (may cause false positives)
- A well-balanced configuration is essential for accurate detection without false positives

## License

MIT License - See LICENSE file for details

## Support

For support, bug reports, or suggestions, please create an issue on the GitHub repository. 