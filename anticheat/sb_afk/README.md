# sb_afk

A standalone AFK (Away From Keyboard) detection and management system for RedM servers.

## Features

- Automatically detects when players are AFK (not moving)
- Provides customizable warning time before kick
- Kicks players after configurable AFK duration
- Admin commands to whitelist players from AFK checks
- Database integration for persistent whitelisting
- Discord webhook notifications (optional)

## Requirements

- VORP Framework (Core)
- oxmysql

## Installation

1. Extract the `sb_afk` folder to your server's `/resources/anticheat/` directory
2. Add `ensure anticheat/sb_afk` to your server.cfg
3. Configure the settings in `config.lua` to your liking
4. Start/restart your server

## Configuration

Edit the `config.lua` file to customize the behavior of the AFK system:

```lua
Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "AFK System",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}

-- AFK System Configuration
Config.AFK = {
    active = true,
    kicktime = 1800, -- Seconds until kick (default: 30 minutes)
    warntime = 1700, -- Seconds until warning (default: about 28 minutes)
    lang = {
        kick = "You will be kicked in ",
        kick2 = " for AFK",
        hours = " hours",
        minutes = " minutes",
        seconds = " seconds",
        kickreason = "AFK",
        whitelist = {
            id = "You must include a user id",
            wladded = "User Added to AFK Whitelist",
            wlremoved = "User Removed from AFK Whitelist",
            err = "An Error has Occurred"
        }
    }
}
```

## Commands

- `/afk-addWhitelist [playerID]` - Add a player to the AFK whitelist (admin only)
- `/afk-removeWhitelist [playerID]` - Remove a player from the AFK whitelist (admin only)

## How It Works

The system monitors player movement and activity. If a player remains stationary for the configured warning time, they'll receive a notification. If they continue to be inactive until the kick time is reached, they will be automatically kicked from the server.

Players who are whitelisted by admins will not be subject to AFK kicks, which is useful for staff members or specific roles.

## Database

The script automatically creates an `sb_afk_whitelist` table in your database to store whitelist information. This table includes:

- `id`: Auto-incremented ID
- `identifier`: Steam identifier
- `charidentifier`: Character identifier
- `afk`: Status flag (0 = not whitelisted, 1 = whitelisted)

## Credits

This resource was adapted from the AFK component of the sb_anticheat system.

## License

[MIT License](LICENSE) 