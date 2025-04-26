# SB Mining Zones

A script that restricts mining to specific zones on the map for VORP framework.

## Features

- Define specific areas where players can mine
- Completely restrict mining outside of designated zones
- Option to reduce success rate outside of mining zones instead of completely restricting
- Map blips for mining zones
- Debug mode to visualize mining zone areas
- Easy integration with vorp_mining

## Requirements

- VORP Core
- VORP Mining

## Installation

1. Download the resource
2. Extract it to your resources folder
3. Make sure the folder name is `sb_miningzone`
4. Add `ensure sb_miningzone` to your server.cfg (make sure it loads after vorp_mining)

## Configuration

Edit the `config.lua` file to customize your mining zones:

```lua
Config.MiningZones = {
    {
        coords = {x = -1424.001, y = 1176.164, z = 226.345}, -- Grizzlies Mining Area (example)
        radius = 100.0,
        name = "Grizzlies Mining Area",
        description = "A prime mining location rich with various ores.",
        allow_mining = true,
        blip = true -- Show blip for this zone
    },
    -- Add more zones here
}
```

### Configuration Options

- `Config.Debug` - Enable debug mode to see zone markers in the world
- `Config.CheckInterval` - How often (in ms) to check if player is in a mining zone
- `Config.RestrictedMiningMessage` - Message shown when trying to mine outside a zone
- `Config.ShowMiningZoneBlips` - Whether to show blips for mining zones on the map
- `Config.Blip` - Configuration for the mining zone blips
- `Config.StrictRestriction` - If true, completely prevent mining outside zones
- `Config.ReducedSuccessOutsideZones` - If true, reduce success chance outside zones
- `Config.OutsideZoneSuccessModifier` - Success rate multiplier outside zones (0.3 = 30%)

## Exports

The script provides these exports for other resources:

### Client

```lua
-- Check if player is in a mining zone
exports.sb_miningzone:IsPlayerInMiningZone()

-- Get the current mining zone data if player is in one
exports.sb_miningzone:GetCurrentMiningZone()
```

### Server

```lua
-- Get all mining zones
exports.sb_miningzone:GetMiningZones()

-- Get player counts in each mining zone
exports.sb_miningzone:GetPlayersInMiningZones()
```

## Events

### Client

- `sb_miningzone:enteredMiningZone` - Triggered when player enters a mining zone
- `sb_miningzone:exitedMiningZone` - Triggered when player exits a mining zone

## License

[MIT License](https://opensource.org/licenses/MIT)

## Credits

Created by Salah 