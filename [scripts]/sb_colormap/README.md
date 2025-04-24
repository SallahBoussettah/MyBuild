# SB ColorMap

A RedM resource that applies custom colors to map regions, making different territories easily distinguishable.

## Features

- Custom colors for all major regions in the RedM map
- Easy configuration through the config.lua file
- Clean code with proper cleanup when the resource stops
- No dependencies - works with any framework

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

### Available Colors

Some common color options include:
- BLIP_STYLE_DEBUG_RED
- BLIP_STYLE_DEBUG_GREEN
- BLIP_STYLE_DEBUG_BLUE
- BLIP_STYLE_DEBUG_YELLOW
- BLIP_STYLE_AREA_BOUNDS
- BLIP_STYLE_AREA_BOUNDS_OVERLAY
- BLIP_STYLE_FM_EVENT
- BLIP_STYLE_COP_PERSISTENT

## Credits

- Original script by Darky_13
- Integrated into VORP framework by Salah

## License

This resource is released under the MIT License. 