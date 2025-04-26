# SB Mining Zones

A comprehensive mining system resource for RedM servers, focusing on creating realistic mining gameplay with designated mining zones and a complete mining economy.

## Table of Contents
- [Core Features](#core-features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Technical Details](#technical-details)
- [License](#license)
- [Credits](#credits)

## Core Features

### Mining Zone System
- **Zone Management**: Define custom mining areas throughout the map with specific radiuses
- **Activity Restriction**: Limit mining to designated zones only
- **Optional Flexibility**: Configure reduced success rate for mining outside zones
- **Map Navigation**: Customizable blips for mining locations
- **Player Notifications**: Zone entry/exit notifications

### Mining Store System
- **Complete Commerce**: Fully functional stores for buying tools and selling resources
- **Inventory Integration**: Seamless VORP inventory system integration
- **Job Permissions**: Optional job-based access to stores
- **Operating Hours**: Realistic store opening/closing hours
- **Dynamic Economy**: Random price fluctuations and store inventory limits

### Item Management
- **Auto-Registration**: Adds all mining items to database automatically
- **Weight System**: Full integration with inventory weight system
- **Item Categories**: Organized categories for tools, ores, etc.

### Economy Protection
- **Purchase Limits**: Daily limits for tools (1 pickaxe per day)
- **Store Inventory**: Configurable stock limits per store
- **Database Tracking**: Purchase history with date-based restrictions

### User Interface
- **Clean Menus**: Intuitive buying and selling interface
- **Visual Elements**: Item images and detailed descriptions
- **Quantity Control**: Amount selectors with price calculations

## Installation

1. Download the resource
2. Place in your `resources` folder
3. Ensure the folder is named `sb_miningzone`
4. Add `ensure sb_miningzone` to your server.cfg after VORP resources
5. Configure the mining zones and stores in the config files
6. Restart your server

## Configuration

The resource includes several configuration files:

### Main Configuration (`config/config.lua`)
```lua
Config.MiningZones = {
    {
        coords = {x = -1421.2853, y = 1171.9752, z = 226.3315},
        radius = 20.0,
        name = "Grizzlies Mining Area",
        description = "A prime mining location rich with various ores.",
        allow_mining = true,
        blip = true
    },
    -- Add more zones as needed
}

Config.StrictRestriction = true -- Completely restrict mining outside zones
Config.ReducedSuccessOutsideZones = false -- Only works if StrictRestriction is false
Config.OutsideZoneSuccessModifier = 0.3 -- 30% success rate outside zones
```

### Buy Items Configuration (`shared/buyItemsCFG.lua`)
```lua
Config.BuyItems = {
    GrizzliesStore = {
        {
            itemLabel = "Pickaxe",
            itemName = "pickaxe",
            currencyType = "cash",
            buyprice = 45,
            randomprice = math.random(40, 50),
            desc = "A sturdy pickaxe for mining ore deposits.\nLimit: 1 per in-game day.",
            category = "tools",
            itemLimit = 1,
        },
        -- Add more items as needed
    }
}
```

### Store Configuration (in `config/config.lua`)
```lua
Config.MiningStores = {
    GrizzliesStore = {
        Blip = {
            Allowed = true,
            Name = "Grizzlies Mining Store",
            sprite = 1475879922,
            Pos = vector3(-1392.6552, 1155.5912, 224.4771),
        },
        Npc = {
            Pos = vector4(-1392.6552, 1155.5912, 224.4771, 137.3867),
            Model = "U_M_M_BHT_MINEFOREMAN",
            Allowed = true,
        },
        storeName = "Grizzlies Mining Store",
        StoreHoursAllowed = true,
        StoreOpen = 6, -- 6 AM
        StoreClose = 22, -- 10 PM
        -- More options available
    }
}
```

## Technical Details

### Requirements
- VORP Core
- VORP Inventory
- VORP Mining
- VORP Menu

### Database Tables
- `pickaxe_purchases`: Tracks daily pickaxe purchases per character
  ```sql
  CREATE TABLE IF NOT EXISTS pickaxe_purchases (
      identifier VARCHAR(50) NOT NULL,
      charidentifier INT(11) NOT NULL,
      purchase_date DATE NOT NULL,
      PRIMARY KEY (identifier, charidentifier, purchase_date)
  )
  ```

### Exports

#### Client Exports
```lua
-- Check if player is in a mining zone
exports.sb_miningzone:IsPlayerInMiningZone()

-- Get the current mining zone data if player is in one
exports.sb_miningzone:GetCurrentMiningZone()

-- Get a specific config value
exports.sb_miningzone:GetConfigValue(key)
```

#### Server Exports
```lua
-- Get all mining zones
exports.sb_miningzone:GetMiningZones()

-- Get player counts in each mining zone
exports.sb_miningzone:GetPlayersInMiningZones()

-- Get all mining store data
exports.sb_miningzone:GetMiningStores()
```

### Events

#### Client Events
- `sb_miningzone:enteredMiningZone` - Triggered when player enters a mining zone
- `sb_miningzone:exitedMiningZone` - Triggered when player exits a mining zone
- `sb_miningstore:JobCheck` - Handles job verification response
- `sb_miningstore:OpenStoreMenu` - Opens the store menu
- `sb_miningstore:BuyItemResponse` - Handles purchase result
- `sb_miningstore:SellItemResponse` - Handles selling result
- `sb_miningstore:CloseMenu` - Closes the store menu

#### Server Events
- `sb_miningzone:checkMiningPermission` - Checks if player can mine at a location
- `sb_miningstore:CheckJob` - Verifies player job for store access
- `sb_miningstore:OpenStore` - Opens the store menu for a player
- `sb_miningstore:BuyItem` - Processes item purchase
- `sb_miningstore:SellItem` - Processes item sale
- `sb_miningzone:getPlayerItems` - Gets player inventory items

## License

This script is released under a Modified MIT License that restricts usage to personal, non-commercial purposes for the individual purchaser only. Redistribution, reselling, or sharing of this script is prohibited without explicit permission from the copyright holder.

See the [LICENSE](./LICENSE) file for full details.

## Credits

Created by Salah 