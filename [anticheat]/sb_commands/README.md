# sb_commands

A standalone command blacklist system for RedM servers to detect and prevent use of cheat menu commands.

## Features

- Automatically monitors registered game commands
- Detects blacklisted cheat menu commands
- Kicks players who attempt to use blacklisted commands
- Customizable command blacklist
- Discord webhook notifications (optional)

## Requirements

- VORP Framework (Core) 
- RedM Server

## Installation

1. Extract the `sb_commands` folder to your server's `/resources/anticheat/` directory
2. Add `ensure anticheat/sb_commands` to your server.cfg
3. Configure the settings in `config.lua` to your liking
4. Start/restart your server

## Configuration

Edit the `config.lua` file to customize the behavior of the command blacklist system:

```lua
Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "Command Blacklist",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}

-- Commands Blacklist Configuration
-- Blacklisted commands. This can be used to detect and prevent cheat menu commands
Config.Commands = { 
    active = true,
    list = {
        "lynx",
        "test:exp",
        "get:playerid",
        "test",
        "bomb",
        "test:aimbot",
        "kms"
    },
    lang = {
        kickreason = "Cheat command detected"
    }
}
```

## How It Works

The system monitors the registered commands available in the game and checks them against a blacklist of known cheat menu commands. The system can detect commands with various prefixes including +, -, _, and / to catch most variations of cheat menu commands.

When a blacklisted command is detected, the player is automatically kicked from the server and a notification is sent to the server console. If Discord webhook integration is enabled, a notification is also sent to the specified Discord channel.

## Customizing the Command Blacklist

To add or remove commands from the blacklist, edit the `list` array in the `Config.Commands` section of the config.lua file. Add any command strings that you want to detect as potential cheat menu commands.

## Discord Integration

To enable Discord notifications:

1. Create a webhook in your Discord server
2. Set `Config.Discord.active` to `true`
3. Paste your webhook URL in the `Config.Discord.webhook` field

## Credits

This resource was adapted from the command blacklist component of the sb_anticheat system. Original command detection code credit to Badger.

## License

[MIT License](LICENSE) 