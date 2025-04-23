# VORP Framework Overview

VORP (Virtual Online Role Play) is a comprehensive RedM framework designed for role-playing servers. This document provides an overview of the core modules and their functionality.

## Core Modules

### 1. vorp_core

The foundation of the VORP framework, providing essential server functionality.

**Key Features:**
- Character management and multi-character support
- Currency system (Gold, Cash, Role Points)
- User permission system and group management
- Discord webhook integration
- PVP settings and management
- UI customization
- Player respawn and health management
- Ban/unban system

**Important Commands:**
- `/addGroup [playerId] [group]` - Assign a group to a player
- `/addJob [playerId] [job] [grade] [salary]` - Assign a job to a player
- `/addItem [playerId] [item] [amount]` - Add items to a player's inventory
- `/addWeapon [playerId] [weapon] [ammo]` - Provide weapons to a player
- `/delMoney [playerId] [type] [amount]` - Remove currency from a player
- `/addMoney [playerId] [type] [amount]` - Add currency to a player
- `/revive [playerId]` - Revive a player
- `/teleport [playerId]` - Teleport to a player
- `/heal [playerId]` - Heal a player and replenish their needs
- `/ban [playerId] [duration]` - Ban a player
- `/unBan [playerId]` - Unban a player
- `/warn [playerId]` - Warn a player
- `/unWarn [playerId]` - Remove a warning from a player

### 2. vorp_inventory

Advanced inventory management system with customizable options.

**Key Features:**
- Item and weapon management
- Customizable inventory interface
- Weight system with configurable limits
- Weapon serial numbers
- Dropping and picking up items
- Searchable inventory
- Job-specific inventory restrictions
- Item and weapon filtering

**Configuration Options:**
- Starting items and weapons for new players
- Inventory appearance and functionality
- Weapon limit settings
- Item weights and usability
- Custom props for dropped items

### 3. vorp_character

Character creation and customization module.

**Key Features:**
- Detailed character creation
- Clothing and appearance options
- Multiple character support
- Character attributes and statistics
- Character persistence in database

### 4. vorp_admin

Administrative tools and management interface.

**Key Features:**
- Admin menu with comprehensive tools
- Player management functions
- Permission-based admin actions
- NoClip functionality for staff
- Scoreboard/player list
- Logging and webhook integration

**Admin Tools:**
- Player teleportation
- Item/weapon/money management
- Player punishment (ban, kick, etc.)
- Server management functions
- Database utilities

### 5. vorp_banking

Banking system for the economy.

**Key Features:**
- Bank account management
- Deposits and withdrawals
- Transfer system
- Bank locations

### 6. vorp_metabolism

Character needs and status management.

**Key Features:**
- Hunger and thirst systems
- Health and stamina management
- Item consumption effects
- Status UI

### 7. vorp_stables

Horse and vehicle management system.

**Key Features:**
- Horse purchasing and customization
- Vehicle (wagon) management
- Stable locations
- Horse and vehicle retrieval

### 8. vorp_crafting

Crafting system for creating items.

**Key Features:**
- Customizable crafting recipes
- Resource gathering
- Crafting locations
- Job-specific crafting options

### 9. vorp_housing

Property and housing system.

**Key Features:**
- Property purchase and management
- Furniture customization
- Storage capabilities
- Door management

## Additional Modules

- **vorp_fishing**: Fishing activities and fish selling
- **vorp_mining**: Mining resources and processing
- **vorp_lumberjack**: Wood cutting and processing
- **vorp_hunting**: Animal hunting and skinning
- **vorp_stores**: Shop system for buying/selling items
- **vorp_weaponsv2**: Advanced weapon management
- **vorp_barbershop**: Character appearance modification
- **vorp_animations**: Animation control for players
- **vorp_progressbar**: Visual progress indicators
- **vorp_inputs**: Input dialog system
- **vorp_zonenotify**: Area notifications
- **vorp_police**: Law enforcement tools and systems
- **vorp_medic**: Medical and healthcare functionality
- **vorp_mailbox**: In-game mail system

## Framework Requirements

- **oxmysql**: Database connector for MySQL operations
- RedM server with up-to-date resources

## Installation Basics

1. Place modules in `resources/[VORP]/` directory
2. Ensure proper load order (vorp_core should load first)
3. Configure each module according to server needs
4. Restart server after configuration

## Using the Framework

The VORP framework provides a complete ecosystem for RedM roleplay servers, with all the tools needed for:
- Character management
- Economy
- Jobs and activities
- Administration
- Property ownership
- Customization

Server administrators should carefully configure each module according to their server's theme and requirements for the best player experience. 