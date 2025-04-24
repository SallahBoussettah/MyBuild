# SL Position

A simple position display script for RedM by Salah.

## Features

- Display current player coordinates on screen
- Toggle display with F3 key or `/pos` command
- Multiple coordinate display formats
- Show/hide heading
- Copy coordinates to chat with `/copypos` command
- Fully configurable appearance

## Commands

- `/pos` - Toggle coordinate display
- `/heading` - Toggle heading display
- `/posformat` - Cycle through coordinate formats (Vector3, Detailed, Compact)
- `/copypos` - Copy current coordinates in vector3 format to chat

## Configuration

Edit `config.lua` to customize:

- Display position on screen
- Text size and font
- Colors
- Format and precision
- Toggle keys

## Installation

1. Place the `sl_position` folder in your server's `resources/[scripts]` directory
2. Add `ensure sl_position` to your `server.cfg`
3. Restart your server or start the resource

## Requirements

- RedM server
- VORP Core (for notifications) 