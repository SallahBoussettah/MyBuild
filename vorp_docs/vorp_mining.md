# VORP Mining Documentation

## Overview
VORP Mining is a resource for the VORP Core framework that allows players to mine rocks throughout the RedM world. Players can use a pickaxe to mine rocks and obtain various minerals and resources which can be used in crafting or sold for profit.

## Features
- Interactive mining using a pickaxe
- Minigame-based resource collection
- Pickaxe durability system with wear and break chance
- Configurable mining restrictions in towns
- Variety of mineable resources with configurable drop rates
- Supports multiple language options

## Dependencies
- VORP Core
- syn_minigame

## How It Works

### Core Mechanics
1. **Finding Rocks**: Players can approach any of the numerous rock models defined in the config file
2. **Starting Mining**: When near a rock, players press the configured prompt key (default: Spacebar) to start mining
3. **Mining Process**: 
   - The system checks if the player has a pickaxe in their inventory
   - If present, the player's character will equip the pickaxe and begin the mining animation
   - Player presses the mine key (default: Left mouse button) to swing at the rock
   - Each swing triggers a minigame through syn_minigame
   - Successful minigame completion rewards the player with items
   - Failed attempts display humorous messages
4. **Ending Mining**:
   - Mining ends when the player completes the configured number of swings (MinSwing-MaxSwing)
   - Player can manually stop mining by pressing the cancel key (default: F)
   - Mining also stops if the pickaxe breaks

### Durability System
- Each pickaxe has a durability value stored in item metadata
- Durability decreases by 1 with each mining session
- When durability falls below the configured threshold, there's a chance the pickaxe will break
- Break chance is configurable (PickaxeBreakChanceMin to PickaxeBreakChanceMax)

### Town Restrictions
- Mining can be restricted in specific towns (configurable)
- When in a restricted town, the mining prompt won't appear

### Resource Collection
- Successful mining swings provide configurable resources
- Each resource has a defined chance percentage and maximum amount
- Examples include clay, coal, copper, iron, nitrite, rock, salt, and gold nuggets
- Items are directly added to the player's inventory

## Configuration Options

### Main Settings
- `Config.Pickaxe`: Item name for the pickaxe tool
- `Config.MinePromptKey`: Key to start mining (default: 0xD9D0E1C0/Spacebar)
- `Config.StopMiningKey`: Key to stop mining (default: 0x3B24C470/F)
- `Config.MineRockKey`: Key to swing pickaxe (default: 0x07B8BEAF/Left mouse click)
- `Config.MinSwing`/`Config.MaxSwing`: Range for required swings per rock
- `Config.PickaxeDurabilityThreshold`: When durability drops below this, there's a break chance
- `Config.PickaxeBreakChanceMin`/`Config.PickaxeBreakChanceMax`: Range for pickaxe break chance
- `Config.minDifficulty`/`Config.maxDifficulty`: Difficulty range for mining minigame

### Town Restrictions
Configure which towns allow mining with the `Config.TownRestrictions` table.

### Items
Configure mining rewards with the `Config.Items` table. Each item has:
- `name`: Item database name
- `label`: Display name
- `chance`: Probability of getting this item (higher number = more likely)
- `amount`: Maximum amount to receive

### Rocks
Extensive list of rock model hashes that can be mined in the game.

## Database Integration
The script includes an SQL file that adds mining-related items to the database:
- Gold Nuggets
- Clay
- Coal
- Copper
- Iron
- Sulfur
- Stone
- Pickaxe

## Technical Implementation Details

### Client-Side
- Detects when players are near minable rocks
- Handles mining animations and prompts
- Manages the minigame interaction
- Tracks mined rocks with cooldown timers

### Server-Side
- Handles inventory checks for the pickaxe
- Manages pickaxe durability through metadata
- Controls item rewards based on minigame success
- Processes pickaxe breakage chance

### Shared Components
- Configuration options
- Translation system with multiple language support

## Command Reference
No specific commands are included with this resource.

## Technical Notes
- Mined rocks have a cooldown of 30 minutes (1,800,000ms) before they can be mined again
- The script uses native functions for entity detection and animation control
- Uses the VORP inventory metadata system to track pickaxe durability 