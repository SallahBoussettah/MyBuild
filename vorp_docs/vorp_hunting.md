# VORP Hunting Documentation

## Overview
VORP Hunting is a comprehensive hunting system for the VORP Core framework that enables players to hunt animals, process carcasses, and sell the resulting items to butchers. The script handles every aspect of hunting, from killing animals to selling pelts and carcasses, with quality variations and butchers across the map.

## Features
- Complete hunting system with skinning mechanics
- Multiple butcher locations that purchase animal parts
- Quality-based rewards system (poor, good, perfect pelts)
- Animal carcass and pelt management
- Horse pelt storage system
- Item rewards from skinning animals
- Optional butcher job locking
- Multiple language support
- Webhook support for sales tracking

## Dependencies
- VORP Core
- VORP Inventory
- VORP Character

## How It Works

### Core Mechanics
1. **Hunting Animals**: Players hunt animals using weapons
2. **Skinning Animals**: After killing an animal, players can skin it to obtain items
3. **Transporting**: Players can:
   - Carry small animal carcasses
   - Carry large animal pelts
   - Store pelts on the back of their horse
4. **Selling**: Players can sell carcasses, pelts, and other animal items to butchers throughout the map

### Butcher System
- Multiple butcher locations across the map with customizable NPC models
- Optional job restriction (butchers only buy from players with appropriate job)
- Selling interface with prompt-based interaction
- Different payment rates based on animal type and quality

### Animal Quality System
- Animals have three quality levels: poor, good, and perfect
- Quality affects the price paid by butchers
- Quality multipliers can be configured per animal
- Horse pelts are tracked with the same quality system

### Skinning System
- Skinning animals provides configurable items to the player's inventory
- Different items with varying quantities based on animal type
- Fully configurable item list with multiple reward possibilities
- Random quantity options

## Configuration Options

### Main Settings
- `Config.DevMode`: Enable/disable development mode for testing
- `Config.Linux`: Special setting for Linux servers
- `Config.butcherfunction`: Enable/disable butcher functionality
- `Config.Language`: Multiple language settings for UI text
- `Config.webhook`: Discord webhook for sale logging
- `Config.keys`: Key mapping configuration
- `Config.aiButcherped`: Enable/disable AI butcher NPCs
- `Config.joblocked`: Restrict butchers to specific jobs

### Item Quantity Settings
- `Config.ItemQuantity.Max`: Maximum items from skinning when amount is random
- `Config.ItemQuantity.Min`: Minimum items from skinning when amount is random

### Butcher Locations
Configure butchers with the `Config.Butchers` table. Each butcher has:
- `butchername`: Display name
- `butcherjob`: Required job (if job locking is enabled)
- `blip`: Map blip icon
- `npcmodel`: NPC model hash
- `coords`: Location coordinates
- `heading`: NPC facing direction
- `radius`: Interaction radius
- `showblip`: Whether to show on map
- `butcherped`: Whether to spawn NPC

### Animals Configuration
Two major configuration tables:
1. `Config.SkinnableAnimals`: Animals that are skinned to get items
2. `Config.Animals`: Animals that can be sold as carcasses or with quality-based pelts

Each animal entry includes:
- Name and model hash
- Reward items and amounts
- Money, gold, and XP rewards
- Quality ratings (poor, good, perfect) with multipliers
- Display information and textures

## Database Integration
The script doesn't include a separate SQL file but works with existing items in the VORP inventory system.

## Technical Implementation Details

### Client-Side
- Detects animals and pelts being carried by the player
- Manages horse pelt storage and retrieval
- Handles butcher interactions and prompts
- Tracks animal quality states

### Server-Side
- Processes reward calculations based on animal type and quality
- Handles inventory management for skinning rewards
- Manages currency rewards from butchers
- Implements webhook integration for logging

### Notable Functions
- `giveReward()`: Central function for handling all reward calculations
- `SellAnimal()`: Function for processing all animal sales to butchers
- `getUnMinedNearbyRock()`: Function for detecting animals for skinning

## Advanced Usage
- **Custom Animal Addition**: Use the `/animal` command to identify new animal hashes
- **Multiple Item Rewards**: Configure multiple items from skinning with the following structure:
  ```lua
  givenItem = {"meat", "feathers", "claws", "beak"}
  givenAmount = {{1,4}, {2,5}, 0, 1}
  ```
  This gives 1-4 meat, 2-5 feathers, a random amount of claws, and exactly 1 beak.

## Technical Notes
- The script handles network entity ownership for proper animal deletion
- Uses native functions for animal quality detection
- Implements proper inventory validation before awarding items
- Special handling for the Linux OS money format
- Supports webhooks for tracking player earnings 