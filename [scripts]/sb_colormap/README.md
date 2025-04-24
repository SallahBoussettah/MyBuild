# SB ColorMap

A RedM resource that applies custom colors to map regions, making different territories easily distinguishable. Perfect for marking family territories, gang areas, or administrative zones.

## Features

- Custom colors for all major regions in the RedM map
- Ability to create custom family or gang territories
- **NEW: Custom map overlays that blend with the map like region coloring**
- **NEW: Special family blip icons (like revolvers) for territory centers**
- **NEW: Territory notifications when entering/exiting family territories**
- Custom-sized circular area blips you can place anywhere on the map
- Easy configuration through the config.lua file
- Clean code with proper cleanup when the resource stops
- No dependencies - works with any framework
- Includes helpful commands for identifying region hashes and coordinates

## Installation

1. Copy the `sb_colormap` folder to your server's `resources/[scripts]` directory
2. Add `ensure sb_colormap` to your server.cfg
3. Restart your server or start the resource

## Configuration

You can customize the colors of each region by editing the `config.lua` file:

```lua
Config.ColorMap = {
    STATE_NEW_HANOVER = { 
		hash = 0x41332496,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
    -- more regions...
}
```

## Creating Custom Family Territories

### Method 1: Use the Reference Table
1. Find a suitable region hash in the `Config.RegionHashReference` table in the config file
2. Add a new entry to the `Config.FamilyTerritories` table with your desired color and label

```lua
Config.FamilyTerritories = {
    MY_FAMILY_NAME = {
        hash = 0x0A355D78, -- TOWN_VALENTINE hash from the reference table
        color = "BLIP_STYLE_ADVERSARY", -- Purple color
        label = "My Family Territory"
    },
    -- Add more as needed
}
```

### Method 2: Using Commands
1. In-game, go to the location you want to color
2. Use the command `/getregionhash` to get region information
3. Check your F8 console for instructions
4. Add the appropriate hash to your `Config.FamilyTerritories` section in the config
5. Restart the script with `/restart sb_colormap`

## Creating Custom Map Overlays (Recommended)

These custom map overlays appear like the region colors, blending with the map for a seamless look. **This is the recommended way to create custom territories that match the style in your screenshot.** 

1. Go to the location where you want to create your custom area
2. Use the command `/getcoords` to get your current coordinates
3. Add a new entry to the `Config.CustomMapOverlays` table:

```lua
Config.CustomMapOverlays = {
    {
        name = "My Family Territory",
        x = -284.28,        -- X coordinate (from /getcoords)
        y = 804.92,         -- Y coordinate (from /getcoords)
        radius = 100.0,     -- Size of the area in meters (adjust as needed)
        style = "BLIP_STYLE_DEBUG_GREEN", -- Matches the original region coloring style
        visible = true      -- Whether the area is visible on the map
    },
    -- Add more as needed
}
```

### Available Styles for Map Overlays
The following styles match the original region coloring and will blend with the map:

- `BLIP_STYLE_DEBUG_GREEN` - Green tint (like in your screenshot)
- `BLIP_STYLE_DEBUG_RED` - Red tint
- `BLIP_STYLE_DEBUG_BLUE` - Blue tint 
- `BLIP_STYLE_DEBUG_YELLOW` - Yellow tint
- `BLIP_STYLE_AREA_BOUNDS` - Light blue outline
- `BLIP_STYLE_AREA_BOUNDS_OVERLAY` - Light shadow overlay (most subtle)
- `BLIP_STYLE_FM_EVENT` - Light purple
- `BLIP_STYLE_COP_PERSISTENT` - Blue/grey

## Alternative: Creating Custom Area Blips

For more visible territory markers, you can also use the regular circular blips, though these don't blend as well with the map:

```lua
Config.CustomAreaBlips = {
    {
        name = "My Gang Territory",
        x = -284.28,      -- X coordinate (from /getcoords)
        y = 804.92,       -- Y coordinate (from /getcoords)
        radius = 100.0,   -- Size of the area in meters
        color = 7,        -- Color ID: 7=Red, 10=Green, etc.
        alpha = 128,      -- Transparency (0-255)
        highDetail = true, -- Higher quality circle
        visible = true    -- Whether the area is visible on the map
    },
    -- Add more as needed
}
```

## Adding Special Blip Icons for Families

The script now includes support for adding special blip icons (like a revolver) for family territories. This is currently implemented for the Pincertens family, and you can extend it for other families by modifying the client.lua file:

```lua
-- Look for this code in the client.lua file and adapt it for other families
if overlay.name == "Your Family Territory Name" then
    -- Create a custom blip at the center of their territory
    local customBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, overlay.x, overlay.y, 0)
    
    -- Set blip sprite to a specific icon
    -- Some useful sprite hashes:
    -- 669307703: Revolver
    -- 1322310532: Skull
    -- 1681904975: Star
    Citizen.InvokeNative(0x74F74D3207ED525C, customBlip, 669307703, 1) 
    
    -- Set blip color
    Citizen.InvokeNative(0x662D364ABF16DE2F, customBlip, 0xFF0000) -- Red color
    
    -- Add name to the blip
    Citizen.InvokeNative(0x9CB1A1623062F402, customBlip, "Your Family Name")
    
    -- Store for cleanup
    table.insert(customBlips, customBlip)
end
```

## Territory Notifications

The script now includes a notification system for family territories, similar to vorp_zonenotify. When players enter or exit a territory, they will receive a notification showing which family's territory they're entering/leaving.

### Configuration

You can customize the territory notification system in the config.lua file:

```lua
Config.TerritoryNotify = {
    Enabled = true,                   -- Enable/disable territory notifications
    NotificationDuration = 4000,      -- How long notifications show for (in ms)
    ShowOnlyOnce = true,              -- Only notify when entering a new territory
    CooldownTimer = 30000,            -- Time before showing the same territory notification again (in ms)
    EnterMessage = "Entering",        -- Message shown when entering a territory
    ExitMessage = "Leaving",          -- Message shown when exiting a territory
    ShowExitNotification = true,      -- Show notification when leaving a territory
    NotificationStyle = "top",        -- Options: "top" (vorp:NotifyTop) or "right" (vorp:Tip)
    
    -- Notification colors for different territory types
    Colors = {
        Default = "~COLOR_WHITE~",    -- Default color for territories
        Pincertens = "~COLOR_RED~",   -- Specific color for Pincertens family
        -- Add more family-specific colors here
    }
}
```

### Adding New Family Colors

To add color for a specific family's notifications:

1. Add an entry to the `Colors` table in the `Config.TerritoryNotify` section
2. The key should match part of the family's territory name
3. The value should be a RedM color code (like `~COLOR_RED~`)

### Commands

- `/checkterritory` - Manually check if you're in a family territory

## Useful Commands

- `/getregionhash` - Get information about the region you're currently in
- `/getcoords` - Get your current coordinates for creating custom area blips
- `/listterritories` - List all configured family territories in the console
- `/listareas` - List all custom areas in the console
- `/checkterritory` - Check if you're currently in a family territory

## Known Limitations

- RedM only allows coloring predefined regions - you cannot create entirely custom-shaped colored areas
- Region hashes cannot be directly determined in-game, so you need to use the reference table
- Custom areas are circular only - complex shapes are not supported

## Credits

- By Salah