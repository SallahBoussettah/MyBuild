# SB ColorMap

A comprehensive map coloring resource for RedM servers, allowing custom coloring of map regions, custom territory creation, and territory notifications to enhance player experience.

## Table of Contents
- [Core Features](#core-features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Technical Details](#technical-details)
- [License](#license)
- [Credits](#credits)

## Core Features

### Region Coloring System
- **Map Region Management**: Apply custom colors to predefined regions throughout the map
- **Visual Distinction**: Make different states, districts, and territories easily distinguishable
- **Consistent Application**: Seamless application and cleanup of regional colors
- **Automatic Handling**: Colors are properly applied on resource start and removed on resource stop

### Family Territory System
- **Custom Territories**: Create family or gang territories using region hashes
- **Visual Representation**: Apply distinct colors to territories for easy recognition
- **Territory Labeling**: Assign custom labels to each territory for identification
- **Clean Integration**: Territories blend naturally with the existing map

### Custom Area System
- **Map Overlay Zones**: Create custom circular area overlays that blend with the map
- **Standard Area Blips**: Add more visible circular blips with custom colors and transparency
- **High Detail Rendering**: Option for smoother, more detailed area circles
- **Flexible Positioning**: Place territories anywhere on the map with custom radiuses

### Family Territory Icons
- **Custom Blip Icons**: Add special blip icons (like revolvers) for territory centers
- **Territory Branding**: Customize icons to represent specific families or groups
- **Visual Waypoints**: Easy navigation to territory centers

### Territory Notifications
- **Entry/Exit Alerts**: Notifications when entering or leaving territories
- **Customizable Messages**: Configure the messages displayed for territory transitions
- **Color Coding**: Family-specific colors for notification messages
- **Notification Styling**: Options for different notification styles (top or right)
- **Cooldown System**: Prevents notification spam with configurable cooldown timer

### Utility Commands
- **Region Identification**: `/getregionhash` command to identify region hashes
- **Coordinate Tools**: `/getcoords` command for easy recording of map positions
- **Territory Listing**: `/listterritories` and `/listareas` commands for viewing configured territories
- **Territory Checking**: `/checkterritory` command to check current territory

## Installation

1. Download the resource
2. Place in your `resources/[scripts]` folder
3. Ensure the folder is named `sb_colormap`
4. Add `ensure sb_colormap` to your server.cfg
5. Configure the regions and territories in the config files
6. Restart your server

## Configuration

The resource includes a detailed configuration file:

### Region Configuration (`config.lua`)
```lua
Config.ColorMap = {
    STATE_NEW_HANOVER = { 
        hash = 0x41332496,
        color = "BLIP_STYLE_DEBUG_GREEN",
    },
    -- More regions...
}
```

### Family Territory Configuration (`config.lua`)
```lua
Config.FamilyTerritories = {
    EXAMPLE_FAMILY_VALENTINE = {
        hash = 0x724E7654, -- DISTRICT_HEARTLAND hash (Valentine area)
        color = "BLIP_STYLE_ADVERSARY",
        label = "Valentine Outlaws"
    },
    -- More territories...
}
```

### Custom Area Configuration (`config.lua`)
```lua
Config.CustomAreaBlips = {
    {
        name = "Valentine Gang Territory",
        x = -284.28,
        y = 804.92,
        radius = 100.0,
        color = 6,
        alpha = 128,
        highDetail = true,
        visible = true
    },
    -- More custom areas...
}
```

### Map Overlay Configuration (`config.lua`)
```lua
Config.CustomMapOverlays = {
    {
        name = "Valentine Family Zone",
        x = -284.28,
        y = 804.92,
        radius = 100.0,
        style = "BLIP_STYLE_AREA_BOUNDS_OVERLAY",
        visible = true
    },
    -- More overlays...
}
```

### Territory Notification Configuration (`config.lua`)
```lua
Config.TerritoryNotify = {
    Enabled = true,
    NotificationDuration = 4000,
    ShowOnlyOnce = true,
    CooldownTimer = 30000,
    EnterMessage = "Entering",
    ExitMessage = "Leaving",
    ShowExitNotification = true,
    NotificationStyle = "top",
    
    Colors = {
        Default = "~COLOR_WHITE~",
        Pincertens = "~COLOR_RED~",
    }
}
```

## Technical Details

### Requirements
- RedM server
- No specific framework dependencies (works with any framework)

### Available Color Styles
- Standard Colors: `BLIP_STYLE_DEBUG_RED`, `BLIP_STYLE_DEBUG_GREEN`, `BLIP_STYLE_DEBUG_BLUE`, `BLIP_STYLE_DEBUG_YELLOW`
- Special Styles: `BLIP_STYLE_ADVERSARY`, `BLIP_STYLE_AREA_BOUNDS`, `BLIP_STYLE_AREA_BOUNDS_OVERLAY`, `BLIP_STYLE_COP_PERSISTENT`, `BLIP_STYLE_FM_EVENT`, etc.

### Commands

#### Player Commands
- `/getregionhash` - Get information about the region you're currently in
- `/getcoords` - Get your current coordinates for creating custom areas
- `/listterritories` - List all configured family territories in the console
- `/listareas` - List all custom areas in the console
- `/checkterritory` - Check if you're currently in a family territory

### Client Functions

```lua
-- Main functionality in client/main.lua:
-- Sets up region coloring, custom territories, and map overlays
-- Provides cleanup when resource stops

-- Territory notification system in client/territory_notify.lua:
-- IsPlayerInTerritory() - Checks if player is in a territory
-- ShowTerritoryNotification() - Displays territory notifications
```

### Implementation Notes

- Region coloring uses native RedM functions to apply colors to predefined map regions
- Custom areas use circular blips with transparency settings
- Map overlays use a special styling technique to blend better with the map
- Territory notifications include cooldown mechanisms to prevent spam
- All visual elements are properly cleaned up when the resource stops

## License

This script is protected by the cfx.re Escrow and Keymaster system and is licensed exclusively to the individual purchaser. The license is tied to the purchaser's cfx.re account.

### Key License Terms:
- Script is bound to the purchaser's cfx.re account license key
- Only the config.lua file(s) may be modified
- No redistribution, reselling, or transfer allowed
- No decompilation or reverse engineering permitted
- For use only on servers owned/operated by the purchaser

For complete license terms, please see the [LICENSE](./LICENSE) file included with this script.

**IMPORTANT**: Attempting to circumvent the protection system or violate license terms will result in immediate termination of your license without refund.

## Credits

Created by Salah