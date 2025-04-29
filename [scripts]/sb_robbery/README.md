# SB Robbery System

## Description
A comprehensive bank robbery system for RedM/VORP Framework. This script allows players to purchase dynamite from an NPC, rob banks, and collect rewards.

## Features
- NPC interaction with dialogue system
- Purchase dynamite from the NPC
- Random bank selection from available banks
- Dynamite placement and explosion mechanics
- Vault searching and reward collection
- Police notification system with map markers
- Cooldown system for banks
- Full integration with VORP Core and VORP Inventory

## Dependencies
- vorp_core
- vorp_inventory
- vorp_progressbar

## Installation
1. Ensure you have all dependencies installed and working
2. Extract the `sb_robbery` folder to your `resources/[scripts]` directory
3. Add `ensure sb_robbery` to your server.cfg file
4. Restart your server

## Configuration
The script is highly configurable through the `config.lua` file:

### NPC Settings
Configure the NPC that sells dynamite for bank robberies:
```lua
Config.NPCS = {
    {
        coords = vector4(-1786.1436, -397.5865, 155.6201, 51.1322), -- Npc coordinates
        model = 'A_M_M_UniGunslinger_01', -- Npc model
        outfit = false,
    },
}
```

### Bank Settings
Configure the available banks for robbery:
```lua
Config.Banks = {
    { coords = vector3(1290.0882, -1312.4019, 76.0399), name = "Rhodes Bank" },
    { coords = vector3(-820.1022, -1273.4377, 43.6513), name = "Blackwater Bank" },
}
```

### Reward Settings
Configure the items players can receive from bank robberies:
```lua
Config.BankItems = {
    { itemName = "diamond", amount = 3 },   
    { itemName = "goldbar", amount = 2 }, 
}
```

### Other Settings
- `Config.robberyCooldown`: Time (in ms) before a bank can be robbed again
- `Config.ZoneSize`: Size of the interaction zone around NPCs and banks
- `Config.DynamitePrice`: Price to purchase dynamite
- `Config.MinBankPolice`: Minimum number of police required online for bank robbery
- `Config.PoliceJobs`: Jobs considered as police

## Usage
1. Approach the robbery NPC (configured in `config.lua`)
2. Interact with the NPC to purchase dynamite (costs configured amount)
3. The NPC will randomly select one of the available banks
4. Travel to the selected bank
5. Plant the dynamite at the bank
6. Wait for the explosion
7. Search the vault for rewards

## Police Notification
When a robbery begins, all players with a police job will be notified and a marker will appear on their map showing the location of the robbery.

## Technical Details

### Client-Side
- NPC spawning and interaction
- Dialogue system for NPC conversations
- Dynamite placement and explosion effects
- Vault searching mechanics
- UI prompts and notifications

### Server-Side
- Money handling (via VORP Core)
- Inventory management (via VORP Inventory)
- Police notification system
- Reward distribution
- Bank cooldown system

## Credits
- Author: Salah
- Version: 1.1.0

## License

This script is protected by the cfx.re Escrow and Keymaster system and is licensed exclusively to the individual purchaser. The license is tied to the purchaser's cfx.re account.

### Key License Terms:
- Script is bound to the purchaser's cfx.re account license key
- Only the config.lua file(s) may be modified
- No redistribution, reselling, or transfer allowed
- No decompilation or reverse engineering permitted
- For use only on servers owned/operated by the purchaser

For complete license terms, please see the [LICENSE](./LICENSE) file included with this script.

**IMPORTANT**: Attempting to circumvent the protection system or violate license terms will result in immediate termination of your license without refund.

## Support
For support, contact the author directly.
