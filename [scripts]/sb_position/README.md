# SB Position

A comprehensive coordinate display system for RedM servers, providing developers and administrators with precise location information in customizable formats.

## Table of Contents
- [Core Features](#core-features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Technical Details](#technical-details)
- [License](#license)
- [Credits](#credits)

## Core Features

### Coordinate Display System
- **Real-time Tracking**: Live updating of player coordinates as they move
- **Custom Positioning**: Configurable screen position for coordinate display
- **Multiple Formats**: Three different display formats for different needs
- **Heading Information**: Optional heading display with toggle functionality
- **Background Enhancement**: Semi-transparent background for better readability

### Developer Tools
- **Copy Functionality**: Easily copy coordinates to chat for quick reference
- **Format Cycling**: Quickly switch between coordinate formats without menu navigation
- **Precise Control**: Configure decimal precision for detailed or rounded values
- **Visual Customization**: Fully configurable colors, scale, and font options
- **Keyboard Shortcuts**: Quick toggle with F3 key for rapid accessibility

### Command System
- **Toggle Command**: `/pos` to show/hide the coordinate display
- **Heading Toggle**: `/heading` to include or exclude heading information
- **Format Selection**: `/posformat` to cycle through available display formats
- **Position Copy**: `/copypos` to copy current position in vector3 format to chat

### User Experience
- **Minimal Interference**: Unobtrusive display that doesn't block gameplay
- **Performance Optimized**: Low resource usage even with constant updates
- **Intuitive Controls**: Simple keyboard shortcuts and commands
- **Visual Feedback**: Notifications when changing display options

## Installation

1. Download the resource
2. Place in your `resources/[scripts]` folder
3. Ensure the folder is named `sb_position`
4. Add `ensure sb_position` to your server.cfg
5. Restart your server or start the resource

## Configuration

The resource includes a detailed configuration file:

### Display Settings (`config.lua`)
```lua
Config.Display = {
    -- Position on screen (0.0-1.0)
    x = 0.175,  -- Left side of screen
    y = 0.03,   -- Near the top
    
    -- Visual settings
    scale = 0.4,
    font = 1,
    
    -- Text color (RGBA)
    color = {
        r = 255, 
        g = 255, 
        b = 255, 
        a = 255
    },
    
    -- Background color (RGBA)
    bgColor = {
        r = 0, 
        g = 0, 
        b = 0, 
        a = 120  -- Semi-transparent
    }
}
```

### Format Settings (`config.lua`)
```lua
Config.Display = {
    -- Whether to include the heading in the display
    showHeading = true,
    
    -- Format to use (1: Vector3, 2: Individual, 3: Compact)
    -- 1: vector3(x, y, z)
    -- 2: X: 123.45, Y: 123.45, Z: 123.45
    -- 3: 123.45, 123.45, 123.45
    format = 2,
    
    -- Number of decimal places to display
    precision = 4
}
```

### Control Settings (`config.lua`)
```lua
-- Key to toggle the position display (default: F3)
Config.ToggleKey = 0x3B99E482  -- F3 key (Not working currently)

-- Commands
Config.Commands = {
    toggle = "pos",     -- Toggle position display
    heading = "heading", -- Toggle heading display
    format = "posformat" -- Cycle through different formats
}
```

## Technical Details

### Requirements
- RedM server
- VORP Core (for notifications)

### Available Format Styles
- **Vector3**: `vector3(123.4567, 123.4567, 123.4567)`
- **Detailed**: `X: 123.4567, Y: 123.4567, Z: 123.4567`
- **Compact**: `123.4567, 123.4567, 123.4567`

### Commands

#### Player Commands
- `/pos` - Toggle coordinate display on/off
- `/heading` - Toggle inclusion of heading information
- `/posformat` - Cycle through the three coordinate formats
- `/copypos` - Copy current position to chat in vector3 format

### Implementation Notes
- Implements efficient screen drawing with proper scaling and positioning
- Uses native RedM functions for coordinate retrieval and display
- Includes background drawing for improved text readability
- Adjusts display size based on format and content
- Implements keybinding for quick access during gameplay

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