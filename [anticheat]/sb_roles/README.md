# sb_roles - RedM Database Role Protection System

A standalone resource for RedM that monitors and protects admin roles in your database from unauthorized changes.

## Features

- Monitors database for unauthorized admin role promotions
- Automatically detects and alerts about suspicious role changes
- Can revert unauthorized role changes automatically
- Two protection methods: snapshot-based or whitelist-based
- Detailed Discord alerts when issues are detected
- Works with the VORP framework database structure (customizable for other frameworks)

## Installation

1. Extract the `sb_roles` folder to your server's `resources/[anticheat]` directory
2. Add `ensure sb_roles` to your server.cfg (after sb_discord and oxmysql)
3. Configure the settings in `config.lua` to match your database structure and security needs

## Configuration

```lua
Config = {}

-- Database Role Protection Configuration
Config.DBRoles = {
    active = true,                  -- Enable/disable the entire system
    
    -- Database check interval (milliseconds)
    checkInterval = 50000,
    
    -- Database configuration - For VORP framework
    database = {
        -- Table and column names (modify if using custom database structure)
        table = "users",            -- Users table name
        groupColumn = "group",      -- Column containing the user's role/group
        identifier = "identifier",  -- Column with the user's identifier
        
        -- Character table (for additional information in logs)
        characterTable = "characters",
        characterIdentifier = "identifier", -- Column that links to users table
        characterIdColumn = "charidentifier" -- Column with character ID
    },
    
    -- Roles to monitor for unauthorized changes
    protectedRoles = {
        "admin",  -- Top-level admin role
        "mod",    -- Moderator role
        -- Add more roles that should be protected
    },
    
    -- Role checking method
    -- "snapshot": Takes a snapshot of all user roles on startup and alerts if they change
    -- "whitelist": Checks against a predefined whitelist of approved admin accounts
    method = "snapshot",
    
    -- Whitelist of approved admin accounts (only used if method = "whitelist")
    -- Format: ["identifier"] = "role"
    -- Example: ["steam:110000112345678"] = "admin"
    whitelistedAdmins = {
        -- Add your whitelisted admin identifiers here
    }
}

-- Discord webhook settings (using sb_discord if available)
Config.Discord = {
    active = false,            -- Set to true to enable webhook notifications using sb_discord
    webhookType = "roles",     -- Webhook type to use (must be defined in sb_discord config)
    
    -- Actions to take on unauthorized role changes
    actions = {
        notify = true,         -- Send Discord notification
        revert = true,         -- Attempt to revert the role change
        log = true             -- Log to server console
    }
}
```

## Protection Methods

This resource offers two methods of protecting admin roles:

### Snapshot Method (Default)

When the server starts, the script takes a "snapshot" of all existing admin roles in the database. It then periodically checks the database and alerts if any new admin accounts appear that weren't in the original snapshot.

**Best for:** Servers where admin changes are infrequent and typically done during server maintenance.

### Whitelist Method

This method compares admin accounts against a predefined whitelist in the config. Only accounts listed in the `whitelistedAdmins` section can have admin privileges.

**Best for:** High-security environments where you want explicit control over exactly which accounts can have admin roles.

## Discord Integration

This module integrates with sb_discord to send notifications about unauthorized role changes:

1. Ensure you have sb_discord installed and configured
2. Set `Config.Discord.active = true` in config.lua
3. Make sure the webhook type is properly configured in sb_discord

## Database Compatibility

By default, this resource is configured for VORP framework databases. To adapt it to another database structure, modify the table and column names in the `Config.DBRoles.database` section.

> **Note about MySQL reserved keywords:** If your database uses column names that are MySQL reserved keywords (like "group"), the script automatically handles this by wrapping these column names in backticks. You don't need to change the configuration, but be aware that column names like "group", "order", "key", etc. are reserved in MySQL.

## License

MIT License - See LICENSE file for details

## Support

For support, bug reports, or suggestions, please create an issue on the GitHub repository. 