# VORP Framework Configuration Guide

This document outlines the key configuration options for the main VORP modules, explaining how to customize your server.

## vorp_core Configuration

The core module contains the foundation settings for your server. Key configurations in `config.lua` include:

### General Server Settings
```lua
Lang = "English"                 -- Server language
Config.autoUpdateDB = true       -- Enable automatic database updates
Config.Whitelist = false         -- Enable/disable whitelist
```

### Starting Settings
```lua
Config.initGold = 0.0            -- Initial gold for new players
Config.initMoney = 200.0         -- Initial money for new players
Config.initRol = 0.0             -- Initial role-play currency
Config.initInvCapacity = 35.0    -- Initial inventory capacity
Config.initXp = 0                -- Initial experience points
Config.initJob = "unemployed"    -- Default job
Config.initJobGrade = 0          -- Default job grade
Config.initGroup = "user"        -- Default user group
```

### Player Settings
```lua
Config.maxHealth = 10            -- Maximum health (10 is full)
Config.maxStamina = 10           -- Maximum stamina (10 is full)
Config.PVP = true                -- Enable/disable PVP
Config.PVPToggle = false         -- Allow players to toggle PVP
Config.savePlayersTimer = 10     -- Auto-save interval (minutes)
```

### UI Settings
```lua
Config.HideUi = false            -- Show/hide all UI
Config.UIPosition = 'TopRight'   -- UI position
Config.UILayout = 'Column'       -- UI layout ('Row' or 'Column')
```

### Respawn Settings
```lua
Config.HealthOnRespawn = 500     -- Health after respawn
Config.RespawnTime = 10          -- Time before respawn allowed (seconds)
Config.UseDeathHandler = true    -- Use default death handling
```

## vorp_inventory Configuration

The inventory module manages all items, weapons, and player storage. Key configurations include:

### General Settings
```lua
Config.DoubleClickToUse = true    -- Double-click to use items
Config.InventorySearchable = true  -- Enable search bar in inventory
Config.DisableDeathInventory = true -- Disable inventory while dead
```

### Item Display Settings
```lua
Config.UseRolItem = false         -- Show RO$ in inventory
Config.UseGoldItem = false        -- Show gold in inventory
Config.AddDollarItem = true       -- Show dollars in inventory
```

### Weapons and Inventory Limits
```lua
Config.MaxItemsInInventory = {
    Weapons = 6,                  -- Max weapons per player
}

Config.startItems = {              -- Starting items for new players
    consumable_raspberrywater = 2, 
    ammorevolvernormal = 1   
}

Config.startWeapons = {            -- Starting weapons for new players
    "WEAPON_MELEE_KNIFE"
}
```

## vorp_character Configuration

Character creation and customization settings in `config.lua`:

```lua
Config.MaxCharacters = 5           -- Maximum characters per player
Config.AllowPlayerDeleteCharacter = true -- Allow character deletion
```

## vorp_admin Configuration

Admin menu and tools configuration:

```lua
Config.Key = 0x3C3DD371,         -- PGDOWN to open menu
Config.CanOpenMenuWhenDead = true, -- Staff can open menu when dead
Config.useQWreports = true,      -- Enable QW reports integration
```

### NoClip Controls
```lua
Config.Controls = {
    goUp = 0xF84FA74F,           -- Q
    goDown = 0x07CE1E61,         -- Z
    turnLeft = 0x7065027D,       -- A
    turnRight = 0xB4E465B4,      -- D
    goForward = 0x8FD015D8,      -- W
    goBackward = 0xD27782E3,     -- S
    changeSpeed = 0x8FFC75D6,    -- L-Shift
    Cancel = 0x4AF4D473          -- Delete
}
```

### Allowed Groups
```lua
Config.AllowedGroups = {
    admin = true,
    -- Add more groups that can access admin menu
}
```

## vorp_banking Configuration

Banking system settings:

```lua
Config.NewPlayers = false         -- Prevent new players from using banks
Config.WithdrawLimit = true       -- Limit withdrawals
Config.maxWithdrawLimit = 100000  -- Max withdrawal amount
Config.maxDeposit = 10000000      -- Max deposit amount
```

### Bank Locations
```lua
Config.banks = {
    Valentine = {
        city = "Valentine",
        blip = true,              -- Show on map
        blipcoords = vector3(-308.50, 776.24, 118.75),
        NpcAllowed = true,        -- Show NPC
        NpcCoords = vector4(-308.02, 773.82, 116.75, 18.69),
    },
    -- More banks...
}
```

## vorp_metabolism Configuration

Player needs and status management:

```lua
Config.StatusInterval = 10000 -- Time in ms to check status
Config.HealthCoreLevel = 100  -- Core level at start (0-100)
Config.StaminaCoreLevel = 100 -- Core level at start (0-100)
```

### Metabolism Settings
```lua
Config.OnDutyJob = {"police", "doctor"} -- Jobs that don't lose status while on duty
Config.DrainSystemMetabolism = 2 -- 1 = realistic, 2 = balanced, 3 = casual
```

## vorp_housing Configuration

Property management settings:

```lua
Config.AutoPayRent = true        -- Automatic rent payments
Config.RentSystem = true         -- Enable rent system
Config.evictionNotice = 5        -- Days before eviction
Config.RentCoolDown = 25         -- Days between rent payments
```

## How to Configure Your Server

1. **Backup First:** Always backup your configurations before making changes
2. **Edit Carefully:** Use a code editor like Visual Studio Code to edit `.lua` files
3. **Restart Resources:** After making changes, restart the affected resources or the entire server
4. **Test Changes:** Verify that changes work as intended in a controlled environment
5. **Document Changes:** Keep track of customizations for future reference

### Configuration Best Practices

- **Start Small:** Begin with minimal changes and test each change
- **Use Comments:** Add comments in config files to explain custom values
- **Maintain Consistency:** Keep related settings in line with each other
- **Check Dependencies:** Be aware of how one module's settings affect others
- **Consider Performance:** Some settings may impact server performance

## Examples of Common Configurations

### Starter Pack for New Players
```lua
-- In vorp_core/config.lua
Config.initMoney = 500.0         -- Higher starting money

-- In vorp_inventory/config.lua
Config.startItems = {             
    consumable_raspberrywater = 5,
    consumable_bread = 3,
    ammorevolvernormal = 20,
    kit_bandana = 1
}

Config.startWeapons = {           
    "WEAPON_MELEE_KNIFE",
    "WEAPON_REVOLVER_CATTLEMAN"
}
```

### Hardcore Survival Settings
```lua
-- In vorp_core/config.lua
Config.initMoney = 25.0          -- Lower starting money
Config.PVP = true                -- Enable PVP

-- In vorp_metabolism/config.lua
Config.DrainSystemMetabolism = 1 -- Realistic metabolism
```

### RP-Focused Server
```lua
-- In vorp_core/config.lua
Config.Whitelist = true          -- Enable whitelist
Config.MaxCharacters = 1         -- Single character per player

-- In vorp_admin/config.lua
Config.AllowedGroups = {         -- Strict admin permissions
    admin = true,
    moderator = false
}
```

Remember that all settings should be adjusted to match your server's theme and player base preferences. 