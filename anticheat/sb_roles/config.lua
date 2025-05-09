Config = {}

-- Database Role Protection Configuration
-- Monitors for unauthorized changes to admin roles in the database
Config.DBRoles = {
    active = true,
    
    -- Database check interval (milliseconds)
    checkInterval = 50000,
    
    -- Database configuration - For VORP framework
    database = {
        -- Table and column names (modify if using custom database structure)
        table = "users",         -- Users table name
        groupColumn = "group",   -- Column containing the user's role/group
        identifier = "identifier", -- Column with the user's identifier
        
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
    },
    
    -- Language settings
    lang = {
        -- Discord notification text
        discord = {
            title = "Database Role Change Detected",
            description = "A user's role has been changed to a protected role!",
            playerName = "Player name",
            steam = "Steam identifier",
            character = "Character identifier",
            oldGroup = "Previous role",
            newGroup = "New role",
            action = "Action taken"
        }
    }
}

-- Discord webhook settings (using sb_discord if available)
Config.Discord = {
    active = false,          -- Set to true to enable webhook notifications using sb_discord
    webhookType = "roles",   -- Webhook type to use (must be defined in sb_discord config)
    logLevel = 1,            -- Log level for Discord notifications
    
    -- Actions to take on unauthorized role changes
    actions = {
        notify = true,       -- Send Discord notification
        revert = true,       -- Attempt to revert the role change
        log = true           -- Log to server console
    },
    
    -- Log detail level
    detailedLogs = true      -- Include full detail in logs
} 