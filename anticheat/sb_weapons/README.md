# sb_weapons

A standalone weapons and health protection system for RedM servers to detect and prevent common weapon hacks and health cheats.

## Features

- Blacklist specific weapons from being used in your server
- Prevents infinite ammo cheats
- Monitors player health to prevent health hacking
- Discord webhook notifications for admin alerts
- Admin commands for testing and configuration
- Easy-to-configure settings

## Requirements

- VORP Framework (Core)
- RedM Server

## Installation

1. Extract the `sb_weapons` folder to your server's `/resources/[anticheat]/` directory
2. Add `ensure [anticheat]/sb_weapons` to your server.cfg
3. Configure the settings in `config.lua` to your liking
4. Start/restart your server

## Configuration

Edit the `config.lua` file to customize the behavior of the protection system:

```lua
Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "Weapons & Health Protection",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}

-- Infinite Ammo Protection
Config.InfiniteAmmo = { 
    active = true,
    checkInterval = 1000, -- milliseconds between checks
}

-- Weapon Blacklist Protection
Config.Weapons = { 
    active = true,
    checkInterval = 1000, -- milliseconds between checks
    blacklist = {
        -- Example: [GetHashKey("weapon_bow")] = true,
    },
    notification = {
        enabled = true,
        message = "Blacklisted weapon removed"
    }
}

-- Player Health Protection
Config.PlayerStatus = { 
    active = true,
    checkInterval = 1000, -- milliseconds between checks
    health = 600, -- Maximum allowed health value
    lang = {
        kickreason = "Health hack detected"
    }
}
```

## How It Works

### Weapon Blacklist Protection
The system continually checks for blacklisted weapons in the player's inventory and automatically removes them. If a player attempts to bypass the removal, they will be logged and a notification sent to admins.

### Infinite Ammo Prevention
The system consistently ensures that infinite ammo cheats are disabled by calling the appropriate native function to prevent this type of hack.

### Health Hack Detection
The system monitors player health values and automatically kicks players if their health exceeds the configured maximum value, which helps prevent health-related cheating.

## Admin Commands

- `/checkhealth` - Shows your current health value (useful for testing)
- `/setmaxhealth [value]` - Sets the maximum allowed health value (admin only)

## Discord Integration

To enable Discord notifications:

1. Create a webhook in your Discord server
2. Set `Config.Discord.active` to `true`
3. Paste your webhook URL in the `Config.Discord.webhook` field

## Customizing the Weapon Blacklist

To add weapons to the blacklist, edit the `blacklist` table in the `Config.Weapons` section of the config.lua file. Use the format:

```lua
[GetHashKey("weapon_name")] = true,
```

You can find weapon names and hashes in the [RedM Weapons Documentation](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua)

## Health Configuration

The default maximum health value is set to 600, which is approximately the normal maximum health for a player in RedM. If you use systems that allow for golden core health boosts, you may want to increase this value to around 2088 to accommodate those legitimate health boosts.

## Credits

This resource was adapted from the weapon and health protection components of the sb_anticheat system.

## License

[MIT License](LICENSE) 