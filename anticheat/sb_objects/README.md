# sb_objects

A standalone object protection system for RedM servers to detect and automatically remove blacklisted objects that might be spawned by modders or hackers.

## Features

- Automatically detects and removes blacklisted objects from the game world
- Customizable object blacklist
- Discord webhook notifications for admin alerts
- Debug mode for easy identification of new objects to blacklist
- Admin command to reload configuration without server restart
- Optional player notifications when objects are removed

## Requirements

- VORP Framework (Core)
- RedM Server

## Installation

1. Extract the `sb_objects` folder to your server's `/resources/[anticheat]/` directory
2. Add `ensure [anticheat]/sb_objects` to your server.cfg
3. Configure the settings in `config.lua` to your liking
4. Start/restart your server

## Configuration

Edit the `config.lua` file to customize the behavior of the object protection system:

```lua
Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "Object Protection",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        message = "Player tried to spawn blacklisted object: "
    }
}

-- Objects Blacklist Configuration
Config.Objects = { 
    active = true,
    
    -- Enable debug mode to log information about detected objects (useful for setup)
    debug = false,
    
    -- Blacklisted objects that will be automatically deleted when detected
    blacklist = {
        -- Example objects that are often used by modders/hackers
        [GetHashKey("prop_asteroid_01")] = true,
        [GetHashKey("p_benchnbx02x")] = true,
        -- Add more objects as needed
    },
    
    -- Notification settings
    notification = {
        enabled = true,
        message = "Blacklisted object detected and removed"
    }
}
```

## How It Works

The system continuously scans for objects in the game world and compares them against the blacklist. When a blacklisted object is detected, it:

1. Automatically removes the object from the game world
2. Notifies the player (if notifications are enabled)
3. Logs the event to the server console
4. Sends a Discord webhook notification (if enabled)

## Using Debug Mode

To help identify objects that should be blacklisted:

1. Set `Config.Objects.debug = true` in the config file
2. In-game, use the `/checkobject` command while looking at an object
3. The object's hash will be printed to the server console
4. Add the hash to your blacklist in the format: `[12345678] = true,`

## Admin Commands

- `/objects_reload` - Reloads the object protection configuration (admin only)

## Discord Integration

To enable Discord notifications:

1. Create a webhook in your Discord server
2. Set `Config.Discord.active` to `true`
3. Paste your webhook URL in the `Config.Discord.webhook` field

## Customizing the Object Blacklist

To add or remove objects from the blacklist, edit the `blacklist` table in the `Config.Objects` section of the config.lua file. Use the format:

```lua
[GetHashKey("object_name")] = true,
```

Or if you know the hash directly:

```lua
[12345678] = true, -- object description
```

You can find object hashes using the `/checkobject` command in debug mode, or look them up at https://redlookup.com/objects

## Credits

This resource was adapted from the object protection component of the sb_anticheat system.

## License

[MIT License](LICENSE) 