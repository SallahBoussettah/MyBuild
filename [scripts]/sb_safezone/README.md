# SB SafeZone

A comprehensive safe zone system for RedM servers, allowing server administrators to create designated non-combat areas with custom notifications and visual indicators.

## Table of Contents
- [Core Features](#core-features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Technical Details](#technical-details)
- [License](#license)
- [Credits](#credits)

## Core Features

### Safe Zone Management
- **Multiple Zones**: Define unlimited safe zones throughout the map
- **Custom Sizing**: Configure exact boundaries with radius-based detection
- **Flexible Placement**: Place safe zones at any location on the map
- **Visual Debugging**: Debug mode to visualize zone boundaries for setup

### Combat Prevention
- **Weapon Restrictions**: Disables all weapon controls within safe zones
- **Fight Prevention**: Automatically cancels melee attacks and grappling
- **Combat Protection**: Prevents all forms of player-vs-player violence
- **Optional Invincibility**: Configurable god mode for players in safe zones

### Notification System
- **Custom UI Integration**: Beautiful themed notifications when entering/exiting zones
- **Zone Identification**: Clear display of the zone name and rules
- **Responsive Design**: Smooth fade animations for UI elements
- **Framework Options**: Support for both custom UI and native VORP notifications

### Performance Optimization
- **Efficient Zone Checking**: Smart detection system with variable check intervals
- **Low Resource Usage**: Minimal impact on server performance
- **Clean Implementation**: Well-structured codebase with proper event handling
- **Smooth Player Experience**: No stuttering or lag when entering/exiting zones

## Installation

1. Download the resource
2. Place in your `resources/[scripts]` folder
3. Ensure the folder is named `sb_safezone`
4. Add `ensure sb_safezone` to your server.cfg after VORP resources
5. Configure the safe zones in the config.lua file
6. Restart your server

## Configuration

The resource includes a detailed configuration file:

### General Settings (`config.lua`)
```lua
Config.Debug = false                  -- Enable visual debug mode
Config.GodModeInSafeZone = false      -- Makes players invincible in safe zones
Config.NotificationTime = 3000        -- Notification duration in ms
```

### UI Settings (`config.lua`)
```lua
Config.UseCustomUI = true             -- Use custom UI instead of VORP notifications
Config.UIPosition = "top-center"      -- Position of the custom UI
```

### Language Settings (`config.lua`)
```lua
Config.Language = {
    EnteringSafeZone = "You have entered a Safe Zone",
    NoFighting = "NO FIGHTING IN THIS ZONE",
    ZonePrefix = "Safe Zone: "        -- Text shown before zone name
}
```

### Safe Zone Definition (`config.lua`)
```lua
Config.SafeZones = {
    ['Town Center'] = {
        {x = -328.82, y = 773.82, z = 117.49, radius = 15.0}, 
    },
    ['Stable'] = {
        {x = -367.73, y = 787.72, z = 116.26, radius = 8.0},
    },
    -- Add more zones as needed
}
```

## Technical Details

### Requirements
- VORP Core

### UI Components
- Custom HTML/CSS/JS interface for notifications
- Toast-style notification design
- Smooth fade animations

### Client Functions
```lua
-- Main functions in client.lua:
-- HandleSafeZone() - Manages player state within safe zones
-- DisableCombatControls() - Disables all combat-related actions
-- ShowUiZone() - Displays the custom UI notification
-- HideUiZone() - Hides the custom UI notification
```

### NUI System
- Uses browser-based UI through NUI messaging
- jQuery for DOM manipulation
- Custom CSS styling with Western-themed design
- Responsive to in-game events

### Implementation Notes
- Uses native RedM functions to disable combat actions
- Implements efficient distance checking to detect zone boundaries
- Uses event-driven architecture for UI notifications
- Provides debug visualization options for zone setup
- Supports multiple overlapping safe zones if needed

## License

This script is released under a Modified MIT License that restricts usage to personal, non-commercial purposes for the individual purchaser only. Redistribution, reselling, or sharing of this script is prohibited without explicit permission from the copyright holder.

See the [LICENSE](./LICENSE) file for full details.

## Credits

Created by Salah 