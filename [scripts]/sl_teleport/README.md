# Prison Escape System

A script for RedM servers that allows players to escape from the Strawberry Jail using dynamite.

## Features

- Players can use dynamite to blow a hole in the jail cell wall
- System requires players to have dynamite item in their inventory
- Configurable cooldown timers and alert mechanisms
- Integrated with VORP police system
- Cell checks to ensure players can only teleport out from inside cells
- Admin commands for resetting the system

## VORP Police Integration

This script is fully integrated with the VORP police system:

- When a prison break occurs, on-duty police officers are alerted
- Uses the standard VORP police alert system with blips and notifications
- Only officers on duty will receive alerts
- Alerts the closest officers to the location (configurable number of officers)
- Displays custom messages for explosions and escape attempts

## Requirements

- VORP Core
- VORP Inventory
- VORP Police

## Installation

1. Copy the `sb_prisonbreak` folder to your server's `resources` directory
2. Add `ensure sb_prisonbreak` to your server.cfg
3. Configure the script in `config.lua` to match your server needs

## Configuration

The main configuration file is `config.lua`. Important settings include:

- `Config.Teleport` - Configure cell boundaries and teleport points
- `Config.Dynamite` - Set dynamite item name and placement options
- `Config.Alerts` - Configure alert system parameters
- `Config.TeleportActiveTime` - How long the teleport is available after explosion
- `Config.Cooldown` - Global cooldown between teleports

## Commands

- `/resetjail` - Admin command to reset all jail system state
- `/getpos` - Debug command to get current position (for configuration)
- `/forceteleport` - Debug command to force teleport (admin only)

## Credits

Created by Your Name/Organization 