# SB Prison Break

A comprehensive prison escape system for RedM servers, allowing players to break out of jail cells using dynamite and providing law enforcement alerts for immersive roleplay.

## Table of Contents
- [Core Features](#core-features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Technical Details](#technical-details)
- [License](#license)
- [Credits](#credits)

## Core Features

### Jail Cell Escape System
- **Dynamic Escape Mechanism**: Use dynamite to blow a hole in jail cell walls
- **Realistic Process**: Multi-step process requiring proper positioning and timing
- **Persistent State**: Cell damage remains for a configurable duration
- **Flexible Configuration**: Highly customizable cell boundaries and explosion parameters
- **Visual Effects**: Explosion effects and damaged cell appearance

### Law Enforcement Integration
- **Officer Alerts**: Automatically notify on-duty law enforcement officers
- **Priority Alerts**: Closest officers are notified first for realistic response
- **Custom Notifications**: Detailed notifications with explosion and escape information
- **Map Blips**: Adds map markers to help officers locate the prison break
- **Immersive Roleplay**: Creates realistic crime and response scenarios

### Item Management
- **Resource Requirements**: Requires dynamite items from player inventory
- **Automatic Deduction**: Removes items when used in the escape attempt
- **Inventory Integration**: Full VORP inventory compatibility
- **Usage Verification**: Checks for valid item possession before allowing actions

### Anti-Exploit Measures
- **Cooldown System**: Prevents spam usage with configurable cooldown timers
- **Cell Verification**: Ensures players can only escape from inside valid cells
- **Positioning Requirements**: Dynamic placement requires proper positioning
- **Admin Controls**: Commands for administrators to override or reset the system
- **State Persistence**: Saves state between server restarts for continuity

### Debug Tools
- **Position Commands**: Helper commands for configuration and testing
- **Visual Markers**: Optional debug markers to visualize interaction points
- **Detailed Logging**: Comprehensive server-side logging for troubleshooting
- **Admin Override**: Special commands for administrators to test functionality

## Installation

1. Download the resource
2. Place in your `resources/[scripts]` folder
3. Ensure the folder is named `sb_prisonbreak`
4. Add `ensure sb_prisonbreak` to your server.cfg after VORP resources
5. Configure the jail cells and teleport points in the config file
6. Restart your server

## Configuration

The resource includes a detailed configuration file:

### Teleport Settings (`config.lua`)
```lua
Config.TeleportPoint = {
    position = vector3(-1812.50, -355.99, 161.85), -- Position inside the cell
    radius = 1.0,
    destination = vector3(-1814.50, -359.3, 161.85), -- Destination outside
}
```

### Dynamite Settings (`config.lua`)
```lua
Config.Dynamite = {
    itemName = "dynamite", -- The inventory item name
    countdownTime = 10, -- Time before explosion
    explosionRange = 3.0, -- Explosion effect range
    placementDuration = 3000, -- Animation duration
    cooldownTime = 3600, -- Cooldown before another attempt (1 hour)
    modelObject = "p_dynamite01x", -- Dynamite model
    placementPosition = vector3(-1814.50, -355.99, 161.85), -- Placement position
    placementRadius = 1.0, -- Placement interaction radius
    outsideCellOnly = true, -- Prevents placing from inside
}
```

### Cell Area Definition (`config.lua`)
```lua
Config.Teleport = {
    insideCellCheck = true, -- Enable cell boundary checking
    cellArea = {
        center = vector3(-1812.80, -354.90, 161.42), -- Cell center
        width = 2.8, -- Cell width
        length = 4, -- Cell length
        height = 3.0, -- Cell height
        rotation = 65.0, -- Cell rotation
    },
}
```

### Law Enforcement Alert Settings (`config.lua`)
```lua
Config.Alerts = {
    enabled = true, -- Enable law enforcement alerts
    range = 100.0, -- Alert detection range
    lawNotification = "Prison break in progress at Strawberry Jail!",
    lawBlipDuration = 300, -- Map blip duration (5 minutes)
    blip = {
        sprite = 486, -- Blip sprite ID
        color = 1, -- Red color
        name = "Prison Break in Progress", -- Blip name
    }
}
```

### System Timers (`config.lua`)
```lua
-- After explosion, how long the teleport remains available
Config.TeleportActiveTime = 86400 -- 24 hours
-- Global cooldown between teleports
Config.Cooldown = 300 -- 5 minutes
```

## Technical Details

### Requirements
- VORP Core
- VORP Inventory
- VORP Police (for law enforcement alerts)

### State Management
- Uses JSON file storage to maintain teleport state between server restarts
- Automatically loads and saves the following states:
  - Whether teleport is currently enabled
  - Last teleport time
  - Last explosion time

### Server Events
```lua
-- Remove dynamite from player inventory
"sb_prisonbreak:removeDynamite"

-- Check if action is on cooldown
"sb_prisonbreak:checkCooldown"

-- Handle explosion event
"sb_prisonbreak:explode"

-- Alert law enforcement about prison break
"sb_prisonbreak:alertLaw"

-- Admin command to reset system
"sb_prisonbreak:checkAdmin"
```

### Client Events
```lua
-- Explosion effect event
"sb_prisonbreak:explosionEffect"

-- Cooldown check response
"sb_prisonbreak:cooldownCheck"

-- Place dynamite event
"sb_prisonbreak:placeDynamite"

-- Client-side teleport response
"sb_prisonbreak:teleportResponse"
```

### Commands

#### Player Commands
- `/getpos` - Get current position coordinates (for configuration)

#### Admin Commands
- `/resetjail` - Reset all jail system states
- `/forceteleport` - Force teleport regardless of conditions (admin only)

### Implementation Notes
- Uses VORP Core and Inventory for player and item management
- Implements a cell boundary check system for accurate teleport permission
- Integrates with VORP Police for law enforcement notifications
- Uses native RedM prompts for interaction
- Implements proper animation sequences for placing dynamite and teleporting
- Persists state between server restarts via JSON storage

## License

This script is released under a Modified MIT License that restricts usage to personal, non-commercial purposes for the individual purchaser only. Redistribution, reselling, or sharing of this script is prohibited without explicit permission from the copyright holder.

See the [LICENSE](./LICENSE) file for full details.

## Credits

Created by Salah 