# SL_Teleport

A RedM script that allows players to teleport out of jail cells after using dynamite. This script provides an alternative to wall breaking mechanisms while still requiring the use of dynamite to initiate a prison break.

## Features

- Dynamite placement to initiate a jail break
- After explosion, a teleport option appears
- Cell detection system to ensure only players inside cells can teleport
- Animation during teleport process
- Configurable teleport points and destinations
- Law enforcement alerts
- Different key bindings (G for dynamite, E for teleport)
- Cooldown system to prevent abuse
- Admin commands for management
- Debug features for easy configuration

## Installation

1. Download the resource and place it in your `resources/[scripts]` directory
2. Add `ensure sl_teleport` to your server.cfg
3. Configure the `config.lua` file to match your needs
4. Restart your server

## Configuration

The script is highly configurable through the `config.lua` file. Key settings include:

- `Config.Debug` - Enable/disable debug mode
- `Config.TeleportPoint.position` - The position where the dynamite and teleport interaction happens
- `Config.TeleportPoint.destination` - Where players will be teleported to
- `Config.Dynamite` - Settings for dynamite item, countdown, and cooldown
- `Config.Teleport.cellArea` - Area that defines the jail cell boundaries
- `Config.TeleportActiveTime` - How long the teleport option remains available after explosion
- `Config.Alerts` - Settings for law enforcement notifications

## Usage

### For Players

1. Approach the jail cell wall (at the teleport interaction point)
2. Hold G to place dynamite (requires dynamite item in inventory)
3. Wait for countdown and explosion
4. After explosion, a teleport option will appear for players inside the cell
5. Hold E to initiate the teleport when inside the cell (different key than dynamite placement)
6. Wait for the animation to complete
7. You will be teleported outside the cell

### Admin Commands

- `/teleportinfo` - Shows your current coordinates (only in debug mode)
- `/resetteleport` - Resets the teleport system including cooldown (admin only)

## Dependencies

- VORP Core
- VORP Inventory

## Support

For any issues or feature requests, please contact the author.

## Author

Created by Salah 