# SL_SAFEZONE

A safe zone system for the VORP framework that prevents fighting and weapons use in designated areas.

## Features

- Create multiple safe zones across the map
- Disable weapons and combat in safe zones
- Visual notifications when entering/exiting safe zones
- Optional player invincibility in safe zones
- Debug mode to visualize zone boundaries
- Customizable UI notifications
- Compatible with VORP framework

## Installation

1. Extract the contents to your server's resources directory
2. Add `ensure sb_safezone` to your server.cfg file
3. Configure the safe zones in the config.lua file
4. Restart your server

## Configuration

### General Settings
```lua
Config.Debug = false                 -- Enable visual debugging of zones
Config.GodModeInSafeZone = false     -- Make players invincible in safe zones
Config.NotificationTime = 3000       -- Duration of notifications (ms)
```

### Safe Zone Setup
```lua
Config.SafeZones = {
    ['Town Center'] = {
        {x = -328.82, y = 773.82, z = 117.49, radius = 15.0}, 
    },
    -- Add more zones as needed
}
```

## Adding New Safe Zones

1. Find the coordinates and desired radius
2. Add to the Config.SafeZones table in config.lua
3. Restart the resource

## Notes for Toast Background

The UI notification uses a toast.png background image. If it's missing:
1. Create an image file named 'toast.png' 
2. Place it in the html folder
3. Or change the CSS to not use the background image

## Credits

- Author: Salah 