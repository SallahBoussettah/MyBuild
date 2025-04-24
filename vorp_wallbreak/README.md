# VORP Wall Break System

A script for RedM that allows players to break walls with dynamite, creating exciting prison break opportunities.

## Features

- Place dynamite on designated walls (configurable locations)
- 10-second countdown timer with visual and audio cues
- Realistic explosion effects
- Wall breaking animation with debris
- Cooldown system to prevent abuse
- Auto-repair system to restore walls after a configurable time
- Law enforcement alerts when a break is attempted
- Configurable options for all features

## Installation

1. Download or clone this repository into your server's resources folder.
2. Add `ensure vorp_wallbreak` to your server.cfg file.
3. Configure the options in the `config.lua` file to suit your server's needs.
4. Restart your server or start the resource.

## Requirements

- VORP Core
- VORP Inventory

## Configuration

You can configure the script by editing the `config.lua` file:

### Wall Settings

```lua
Config.BreakableWall = {
    position = vector3(-1797.11, -358.63, 163.75), -- Change this to your wall location
    radius = 1.5, -- How close players need to be to interact
    objectModel = "p_wallnbd01x", -- The model of the wall object
    replacementModel = "p_wallnbd01x_broken", -- The model to replace the wall when broken
    
    -- Define the broken wall pieces
    brokenPieces = {
        {model = "p_walldebrisa01x", offset = vector3(0.0, 0.0, 0.0), rotation = vector3(0.0, 0.0, 0.0)},
        {model = "p_walldebrisa02x", offset = vector3(0.5, 0.2, 0.0), rotation = vector3(10.0, 5.0, 15.0)},
        {model = "p_walldebrisa03x", offset = vector3(-0.6, 0.3, 0.0), rotation = vector3(-5.0, 8.0, -10.0)},
    }
}
```

### Dynamite Settings

```lua
Config.Dynamite = {
    itemName = "dynamite", -- Item name in your inventory system
    countdownTime = 10, -- Time in seconds before explosion
    explosionRange = 3.0, -- Range of the explosion effect
    placementDuration = 3000, -- Time to place the dynamite (animation time)
    cooldownTime = 3600, -- Cooldown before another attempt (in seconds)
    modelObject = "p_dynamite01x", -- Dynamite object model
}
```

### Alert Settings

```lua
Config.Alerts = {
    range = 100.0, -- How far the explosion can be heard
    lawNotification = "Prison break in progress at Strawberry Jail!",
    lawBlipDuration = 300, -- How long the alert blip stays on the map
    
    blip = {
        sprite = 486,
        color = 1,
        name = "Prison Break in Progress",
    }
}
```

### Wall Repair Time

```lua
Config.WallRepairTime = 86400 -- Time in seconds until the wall is "repaired" (24 hours)
```

## Usage

### For Players

1. Obtain dynamite from wherever it's available on your server.
2. Approach the designated wall (typically a jail wall).
3. When close enough, you'll see a prompt to "Place Dynamite".
4. Press and hold the indicated button to place the dynamite.
5. After placing, a 10-second countdown will begin.
6. Get away from the wall before it explodes!
7. Once the wall is broken, prisoners can escape through the opening.

### For Administrators

1. Change the wall location in the config to match your jail's structure.
2. Adjust the cooldown and repair times to suit your server's roleplay pacing.
3. Configure alerts to ensure law enforcement gets properly notified.

## Known Issues

- Some wall models may not work properly with the breakable system.
- You may need to adjust the object models and coordinates to match your specific jail building.

## Customizing Wall Locations

If you want to add multiple breakable walls, you'll need to modify the code to support an array of wall locations instead of just one. The basic structure would look like:

```lua
Config.BreakableWalls = {
    {
        position = vector3(-1797.11, -358.63, 163.75),
        radius = 1.5,
        -- other settings
    },
    {
        position = vector3(1234.56, 789.10, 123.45),
        radius = 1.5,
        -- other settings
    }
}
```

## Credits

Created by [Your Name] for your RedM server.