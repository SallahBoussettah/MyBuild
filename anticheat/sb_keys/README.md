# sb_keys

A standalone key blacklist system for RedM servers to detect and prevent use of cheat menu key combinations.

## Features

- Detects blacklisted key combinations commonly used to access cheat menus
- Supports single keys or combinations of up to 4 keys
- Automatically kicks players who press blacklisted key combinations
- Customizable key blacklist
- Discord webhook notifications (optional)

## Requirements

- VORP Framework (Core)
- RedM Server

## Installation

1. Extract the `sb_keys` folder to your server's `/resources/[anticheat]/` directory
2. Add `ensure [anticheat]/sb_keys` to your server.cfg
3. Configure the settings in `config.lua` to your liking
4. Start/restart your server

## Configuration

Edit the `config.lua` file to customize the behavior of the key blacklist system:

```lua
Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "Key Blacklist",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}

-- Keys Blacklist Configuration
-- Blacklist certain keys from being pressed. This can be used to detect and prevent cheat menu keys
Config.Keys = { 
    active = true,
    list = {
        {{47, 21}, "Shift + G Keys"},
        {{0x4AF4D473}, "Cheat Menu"} -- Delete key
        -- You can add more blacklisted key combinations here
        -- Format: {{key1, key2, key3, key4}, "Description"}
        -- Up to 4 keys can be combined
        -- Single keys use format: {{keyCode}, "Description"}
    },
    lang = {
        kickreason = "Cheat Menu detected"
    }
}
```

## How It Works

The system monitors key presses and combinations that are commonly used to access cheat menus in RedM. When a blacklisted key or key combination is detected, the player is automatically kicked from the server and a notification is sent to the server console. If Discord webhook integration is enabled, a notification is also sent to the specified Discord channel.

## Customizing the Key Blacklist

To add or remove keys from the blacklist, edit the `list` array in the `Config.Keys` section of the config.lua file. The system supports:

- Single keys: `{{keyCode}, "Description"}`
- Two key combinations: `{{key1, key2}, "Description"}`
- Three key combinations: `{{key1, key2, key3}, "Description"}`
- Four key combinations: `{{key1, key2, key3, key4}, "Description"}`

You can find key codes for RedM in various community resources or by using key code detection scripts.

## Discord Integration

To enable Discord notifications:

1. Create a webhook in your Discord server
2. Set `Config.Discord.active` to `true`
3. Paste your webhook URL in the `Config.Discord.webhook` field

## Credits

This resource was adapted from the key blacklist component of the sb_anticheat system. Original key detection code credit to Badger.

## License

[MIT License](LICENSE) 