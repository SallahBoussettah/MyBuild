# SB Police

A comprehensive police system for VORP Framework that offers complete law enforcement roleplay functionality.

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

### Complete Law Enforcement System
- **On/Off Duty Management**: Toggle between on-duty and off-duty law enforcement roles
- **Badge Management**: Toggle badge visibility with a simple command
- **Police Menu**: Comprehensive menu for all police functions
- **Item Search**: Search suspects and view their inventory
- **Multiple Department Support**: Works with various law enforcement roles including police, marshal, and sheriff departments

### Jail & Detention System
- **Multiple Jail Locations**: Support for various jail facilities across the map
- **Jail Chores**: Inmates can reduce sentence time by completing chores
- **Community Service**: Alternative to jail sentences for minor offenses
- **Automatic Teleportation**: Returns escaped prisoners back to jail
- **Time Tracking**: Full persistence of jail sentences through server restarts

### Economy Integration
- **Fine System**: Issue monetary penalties to offenders
- **Paycheck System**: Tiered salary system based on rank
- **Bank Integration**: Compatible with various banking systems

### Storage & Inventory
- **Police Storage**: Access to department-specific storage for items and weapons
- **Private Storage**: Personal storage lockers for officers
- **Shared Storage**: Department-wide shared storage

### Police Functionality
- **Handcuffing**: Restrain and escort suspects
- **Suspect Search**: Examine suspect inventories
- **Wagon Transport**: Place suspects in police wagons
- **Dragging**: Drag restrained suspects

## Installation

1. Copy the `sb_police` folder to your `[scripts]` directory
2. Import the `sql.sql` file to your database
3. Add `ensure sb_police` to your `server.cfg` file
4. Restart your server

## Usage

### Basic Commands
- `/goonduty` - Switch to on-duty law enforcement role
- `/gooffduty` - Switch to off-duty law enforcement role
- `/adjustbadge` - Toggle badge visibility
- `/pmenu` - Open the police menu
- `/jail [player_id] [time_in_minutes] [jail_id]` - Jail a player
- `/unjail [player_id]` - Release a player from jail
- `/fine [player_id] [amount]` - Fine a player

### Jail System
The system supports multiple jail locations, each with a specific ID:
- `sk` - Sisika
- `bw` - Blackwater
- `ar` - Armadillo
- `tu` - Tumbleweed
- `st` - Strawberry
- `val` - Valentine
- `sd` - Saint Denis
- `an` - Annesburg

### Police Menu
Access the police menu using `/pmenu` to:
- Search suspects
- Handcuff/escort suspects
- Issue fines
- Jail offenders
- Assign community service
- Access police storage

## Configuration

The script offers extensive configuration options through multiple config files:

### Main Configuration (ConfigMain.lua)
- Law enforcement job settings
- Boss rank settings
- Paycheck configuration
- Handcuff hotkey toggle
- Bank integration settings
- Inventory and storage options
- On-duty/off-duty job definitions

### Jail Configuration (ConfigJail.lua)
- Jail locations and coordinates
- Jail cell positions
- Chore locations and rewards
- Breakout settings

### Cabinet Configuration (ConfigCabinets.lua)
- Gun cabinet locations
- Storage access points
- Department-specific storage options

### Community Service Configuration (ConfigService.lua)
- Service locations
- Task settings
- Minigame difficulty options

### Webhook Configuration (ConfigWebhook.lua)
- Discord webhook integration
- Notification settings for various police actions

## Technical Details

### Server Functions
- Player data management
- Jail time tracking and persistence
- Fine processing
- Storage and inventory handling
- Community service management

### Client Functions
- UI and prompt management
- Animation handling
- Location-based functionality
- Menu integration

### Database Schema
The script uses several database tables:
- `jail` - Tracks jailed players and sentence information
- `communityservice` - Manages community service assignments
- `society_ledger` - Handles department funds

## Requirements

- VORP Core
- VORP Character
- VORP Inventory
- VORP Utils
- oxmysql
- feather-menu
- bcc-utils

## Credits

- Original script by Salah
- Designed for VORP Framework

## License

This script is protected by the cfx.re Escrow and Keymaster system and is licensed exclusively to the individual purchaser. The license is tied to the purchaser's cfx.re account.

### Key License Terms:
- Script is bound to the purchaser's cfx.re account license key
- Only the config.lua file(s) and language files may be modified
- No redistribution, reselling, or transfer allowed
- No decompilation or reverse engineering permitted
- For use only on servers owned/operated by the purchaser

For complete license terms, please see the [LICENSE](./LICENSE) file included with this script.

**IMPORTANT**: Attempting to circumvent the protection system or violate license terms will result in immediate termination of your license without refund.
