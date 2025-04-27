# SB Gun Tricks

A resource for VORP Framework that allows players to perform gun twirling tricks with revolvers and pistols.

## Table of Contents
- [Core Features](#core-features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Technical Details](#technical-details)
- [Requirements](#requirements)
- [Credits](#credits)
- [License](#license)

## Core Features

### Gun Trick System
- **Multiple Animations**: Various gun twirling tricks and flourish animations
- **Menu Interface**: Easy to use prompt-based menu for selecting tricks
- **Weapon Detection**: Compatible with all revolvers and pistols in RedM
- **Seamless Gameplay**: Menu automatically closes when aiming/shooting without interrupting animations
- **Fully Configurable**: All aspects can be customized via config.lua

### Control & Command System
- **Simple Commands**: Toggle tricks with straightforward chat commands 
- **Intuitive Controls**: Prompt-based control system for performing tricks
- **Responsive Design**: Real-time feedback when performing tricks
- **Automatic Closure**: The menu quietly closes during combat situations

### Notification Integration
- **Framework Support**: Integrated with VORP notifications
- **Configurable Display**: Option to use native game notifications instead
- **Clear Feedback**: Informative messages for all user actions

## Installation

1. Copy the `sb_guntricks` folder to your `[scripts]` directory
2. Add `ensure sb_guntricks` to your `server.cfg` file
3. Restart your server

## Usage

### Command Method
1. Equip a revolver or pistol
2. Type `/guntrick` or `/gt` in chat to toggle the gun tricks menu
3. Use the arrow keys to cycle through available tricks
4. Press R to perform the selected trick
5. Press Tab to exit the tricks menu
6. Aim or shoot to automatically close the menu (trick animation will finish naturally)

## Configuration

You can modify the following settings in `config.lua`:

### Control Keys

The script uses the following RedM control codes:

```lua
Config.Prompts = {
    Do = 0xE30CD707,    -- [R]
    End = 0xB238FE0B,   -- [TAB]
    Prev = 0xA65EBAB4,  -- [LEFT ARROW]
    Next = 0xDEB34313,  -- [RIGHT ARROW]
}
```

### Available Tricks

You can add, remove, or reorder tricks in the config:

```lua
Config.Tricks = {
    {`KIT_EMOTE_TWIRL_GUN`, "Twirl"},
    {`KIT_EMOTE_TWIRL_GUN_DUAL`, "Dual Twirl"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_A`, "Twirl A"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_B`, "Twirl B"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_C`, "Twirl C"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_D`, "Twirl D"},
}
```

### Notifications

You can toggle between VORP notifications and native game notifications:

```lua
Config.UseVORPNotify = true -- Set to false if you want to use default game notifications
```

### Gameplay Settings

```lua
-- The menu will close silently when aiming or shooting
-- (animations will continue to play naturally)
```

## Technical Details

### Client Functions
```lua
-- Main functions in client.lua:
-- SetupPrompts() - Creates and registers the prompt controls
-- ShowTrickMenu() - Displays the gun trick selection menu
-- PerformGunTrick() - Handles the animation for the selected trick
-- CloseMenuOnAiming() - Detects aiming/shooting and closes menu
```

### Resource Footprint
- Lightweight script with minimal performance impact
- Efficient event handling for seamless gameplay
- Clean implementation of RedM native functions

## Requirements

- VORP Core
- RedM

## Credits

- Original script by Salah
- Modified for VORP Framework
- Special thanks to the VORP community

## License

This resource is released under a Modified MIT License that restricts usage to personal, non-commercial purposes for the individual purchaser only. Redistribution, reselling, or sharing of this script is prohibited without explicit permission from the copyright holder.

See the [LICENSE](./LICENSE) file for full details.