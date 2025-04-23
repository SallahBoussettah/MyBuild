# VORP Framework Commands

This document lists all available commands in the VORP framework, organized by module.

## vorp_core Commands

### Admin Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/addGroup` | [playerId] [group] | Assign a group to a player | Admin |
| `/addJob` | [playerId] [job] [grade] [salary] | Assign a job to a player | Admin |
| `/addItem` | [playerId] [item] [amount] | Add items to a player's inventory | Admin |
| `/addWeapon` | [playerId] [weapon] [ammo]  | Provide weapons to a player | Admin |
| `/delMoney` | [playerId] [type] [amount] | Remove currency from a player | Admin |
| `/addMoney` | [playerId] [type] [amount] | Add currency to a player | Admin |
| `/delWagons` | [playerId] | Delete a player's wagons | Admin |
| `/revive` | [playerId] | Revive a player | Admin |
| `/teleport` | [playerId] | Teleport to a player | Admin |
| `/delHorse` | [playerId] | Delete a player's horse | Admin |
| `/heal` | [playerId] | Heal a player and replenish their needs | Admin |

### Whitelist Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/addWhitelist` | [playerId] | Add a player to the whitelist | Admin |
| `/unWhitelist` | [playerId] | Remove a player from the whitelist | Admin |

### Player Management Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/ban` | [playerId] [duration] | Ban a player | Admin |
| `/unBan` | [playerId] | Unban a player | Admin |
| `/warn` | [playerId] | Issue a warning to a player | Admin |
| `/unWarn` | [playerId] | Remove a warning from a player | Admin |
| `/charName` | [playerId] [firstName] [lastName] | Change a character's name | Admin |
| `/charCreateAdd` | [playerId] [amount] | Allow a player to create additional characters | Admin |
| `/charCreateRemove` | [playerId] [amount] | Remove a player's ability to create additional characters | Admin |

### Player Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/myJob` | None | Display the player's current job and details | User |
| `/hideUi` | None | Hide all UI elements | User |
| `/toggleUi` | None | Toggle the visibility of VORP UI elements | User |
| `/stopAnim` | None | Stop animations if a player is stuck | User |

## vorp_admin Commands

### Admin Menu
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/adminMenu` | None | Open the admin menu | Admin |

### NoClip
NoClip is controlled via keybinds configured in the admin module:
- Q - Go up
- Z - Go down
- A - Turn left
- D - Turn right
- W - Go forward
- S - Go backward
- L-Shift - Change speed
- Delete - Cancel NoClip

## vorp_inventory Commands

### Inventory Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/getInv` | None | Get inventory information (Dev mode only) | Admin |

## vorp_banking Commands

### Banking Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/cash` | None | Check your cash balance | User |
| `/gold` | None | Check your gold balance | User |

## vorp_character Commands

### Character Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/hidehat` | None | Toggle hat visibility | User |
| `/hidemask` | None | Toggle mask visibility | User |
| `/hidebelt` | None | Toggle belt visibility | User |

## vorp_fishing Commands

### Fishing Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/startfishing` | None | Start fishing if you have a fishing rod | User |
| `/stopfishing` | None | Stop fishing | User |

## vorp_metabolism Commands

### Metabolism Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/hunger` | None | Check your hunger level | User |
| `/thirst` | None | Check your thirst level | User |

## vorp_housing Commands

### Housing Commands
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/createhouse` | [price] [range] | Create a new house for sale (Staff only) | Admin |
| `/delhouse` | [houseId] | Delete a house (Staff only) | Admin |
| `/buyhouse` | None | Buy the house you're standing in | User |
| `/knockhouse` | None | Knock on a house door | User |

## vorp_doorlocks Commands

### Door Management
| Command | Parameters | Description | Required Permission |
|---------|------------|-------------|---------------------|
| `/doorlocks` | None | Enter door creation mode | Admin |

## Key Controls

Many VORP modules use key controls instead of commands. Here are some common key bindings:

| Key | Function | Module |
|-----|----------|--------|
| I | Open inventory | vorp_inventory |
| G | Pickup item | vorp_inventory |
| PGDN | Open admin menu | vorp_admin |
| E | Interact with objects/NPCs | Various modules |

*Note: These key bindings can be customized in each module's configuration file.*

## Configuration

Most command functionality can be configured or disabled in each module's config.lua file. Administrators should review these settings to customize the server experience. 