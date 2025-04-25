# VORP Lumberjack Documentation

## Overview
VORP Lumberjack is a resource for the VORP Core framework that allows players to chop trees throughout the RedM world to gather wood and other forestry resources. Players can use an axe to chop trees and obtain various materials which can be used in crafting or sold for profit.

## Features
- Interactive wood chopping using an axe
- Minigame-based resource collection
- Axe durability system with wear and break chance
- Configurable tree chopping restrictions in towns
- Various tree types that can be harvested
- Variety of forestry resources with configurable drop rates
- Supports multiple language options

## Dependencies
- VORP Core
- syn_minigame

## How It Works

### Core Mechanics
1. **Finding Trees**: Players can approach any of the numerous tree models defined in the config file
2. **Starting Chopping**: When near a tree, players press the configured prompt key (default: Spacebar) to start chopping
3. **Chopping Process**: 
   - The system checks if the player has an axe in their inventory
   - If present, the player's character will equip the axe and begin the chopping animation
   - Player presses the chop key (default: Left mouse button) to swing at the tree
   - Each swing triggers a minigame through syn_minigame
   - Successful minigame completion rewards the player with items
   - Failed attempts display humorous messages
4. **Ending Chopping**:
   - Chopping ends when the player completes the configured number of swings (MinSwing-MaxSwing)
   - Player can manually stop chopping by pressing the cancel key (default: F)
   - Chopping also stops if the axe breaks

### Durability System
- Each axe has a durability value stored in item metadata
- Durability decreases by 1 with each chopping session
- When durability falls below 20, there's a chance the axe will break
- Break chance is set to 1 in 3 (random value 1-3, breaks on 1)

### Town Restrictions
- Chopping can be restricted in specific towns (configurable)
- When in a restricted town, the chopping prompt won't appear

### Resource Collection
- Successful chopping swings provide configurable resources
- Each resource has a defined chance percentage and maximum amount
- Examples include sap, honey, soft wood, hard wood, rubber, fibers, and pulp
- Items are directly added to the player's inventory

## Configuration Options

### Main Settings
- `Config.Axe`: Item name for the axe tool (default: "hatchet")
- `Config.ChopPromptKey`: Key to start chopping (default: 0xD9D0E1C0/Spacebar)
- `Config.CancelChopKey`: Key to stop chopping (default: 0x3B24C470/F)
- `Config.ChopTreeKey`: Key to swing axe (default: 0x07B8BEAF/Left mouse click)
- `Config.MinSwing`/`Config.MaxSwing`: Range for required swings per tree (default: 1-5)
- `Config.minDifficulty`/`Config.maxDifficulty`: Difficulty range for chopping minigame (default: 3800-2000)

### Town Restrictions
Configure which towns allow tree chopping with the `Config.TownRestrictions` table. By default, chopping is disabled in all major towns.

### Items
Configure chopping rewards with the `Config.Items` table. Each item has:
- `name`: Item database name
- `label`: Display name
- `chance`: Probability of getting this item (higher number = more likely)
- `amount`: Maximum amount to receive

Default items include:
- Sap (chance 8, max 2)
- Honey (chance 5, max 2)
- Soft Wood (chance 10, max 5)
- Hard Wood (chance 8, max 5)
- Rubber (chance 5, max 4)
- Fibers (chance 8, max 5)
- Pulp (chance 10, max 3)

### Trees
Extensive list of tree model names that can be chopped in the game, organized by type:
- Birch trees
- Cedar trees
- Dead trees
- Maple trees
- Oak trees
- Pine trees
- And many more varieties

## Technical Implementation Details

### Client-Side
- Detects when players are near choppable trees
- Handles chopping animations and prompts
- Manages the minigame interaction
- Tracks chopped trees with cooldown timers (15 minutes)

### Server-Side
- Handles inventory checks for the axe
- Manages axe durability through metadata
- Controls item rewards based on minigame success
- Processes axe breakage chance

### Shared Components
- Configuration options
- Translation system with multiple language support (English, Italian, Portuguese, French, German, Spanish)

## Translation System
The script includes a comprehensive translation system with humorous messages displayed when players fail the chopping minigame. These include phrases like:
- "You idiot, watch out!"
- "Oops, that almost went into my foot..."
- "Just past the wasp's nest! phew."
- "All chicks dead, the bird's nest is gone!"

Each language includes translations for these messages as well as for all UI prompts and notifications.

## Command Reference
No specific commands are included with this resource.

## Technical Notes
- Chopped trees have a cooldown of 15 minutes (900,000ms) before they can be chopped again
- The script uses native functions for entity detection and animation control
- Uses the VORP inventory metadata system to track axe durability
- Durability is displayed in the item description
- Requires the axe item to be in the player's inventory (named "hatchet" by default) 