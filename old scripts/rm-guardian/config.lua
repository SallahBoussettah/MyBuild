Config = {}

Config.Webhook = {
    active = false,
    webhookAvatar = "https://i.imgur.com/8W9S8Wz.png",
    webhookName = "RedM Guardian",
    webhookUrl = "",
    lang = {
        kick = "Removed for: "
    }
}

-- Role Database checking system (Works with VORP framework, disable if using a different framework)
Config.Database = {
    active = true,
    adminCheckInterval = 60000,
    privilegedRoles = {
        "admin", "moderator", "staff"
    },
    lang = {
        webhook = {
            title = "Privilege Elevation Detected",
            description = "User's role has been changed to a privileged role!",
            playerName = "Character name",
            identifier = "User identifier",
            characterId = "Character identifier"
        }
    }
}

Config.Sanitizer = {
    active = true,
    lang = {
        reason = "Input Sanitation Failure",
        update = "Validating User Information",
        kick = "Connection denied due to username validation failure"
    }
}

Config.Velocity = {
    active = true,
    lang = {
        reason = "Movement Anomaly Detected"
    }
}

Config.ResourceProtection = {
    active = true,
    lang = {
        reason = "Unauthorized Resource Modification"
    }
}

Config.Network = {
    active = true,
    toleratedDisconnects = 2,
    checkInterval = 5000, -- Milliseconds
    timeoutThreshold = 20000,
    lang = {
        kickReason = "Connection stability requirement not met."
    }
}

Config.Idle = {
    active = true,
    kickTimeout = 1800, -- Seconds
    warningTimeout = 1500, -- Seconds
    lang = {
        kick = "You will be disconnected in ",
        kick2 = " due to inactivity",
        hours = " hours",
        minutes = " minutes",
        seconds = " seconds",
        kickReason = "Extended inactivity",
        whitelist = {
            id = "You must provide a valid user ID",
            wlAdded = "User added to idle whitelist",
            wlRemoved = "User removed from idle whitelist",
            err = "Operation failed"
        }
    }
}

Config.InputLimit = {
    active = true,
    violations = 0,
    maxViolations = 30,
    sensitivity = 100,
    lang = {
        kickReason = "Input rate limit exceeded",
        warning = "Rapid input detected! Continued behavior will result in removal."
    }
}

Config.ResourceStopProtection = {
    active = true,
    lang = {
        kickReason = "Resource termination attempt detected",
        warning = "Resource termination is not permitted"
    }
}

Config.EntityBlacklist = { -- Prevent unauthorized entity spawning
    active = false,

    -- Add prohibited entity models here
    -- Example: [GetHashKey("p_benchnbx02x")],
    -- See https://redlookup.com/objects for reference
    blacklistedModels = {}
}

-- Prevent users from using unlimited ammunition
Config.AmmoValidator = {
    active = true
}

Config.WeaponBlacklist = { -- Blacklist specific weapons 
    active = false,

    -- Add prohibited weapon models here
    -- Example: [GetHashKey("weapon_revolver_navy")],
    -- See https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua
    blacklistedWeapons = {}
}

Config.IntegrityCheck = { -- Prevent health manipulation
    active = true,
    baseHealth = 600,     -- Default value (2088 = Golden Core Health)
    lang = {
        kickReason = "Health manipulation detected"
    }
}

Config.EventLimiter = {
    active = false,
    threshold = 5, -- Default value
    whitelistedEvents = {
        -- Add whitelisted event names here
    },
    lang = {
        kickReason = 'User %s triggered event %s excessively with data %s', sender, eventName, eventDataString
    }
}

Config.CommandBlacklist = { -- Block suspicious commands
    active = true,
    list = {
        "hack",
        "mod:menu",
        "get:id",
        "cheat",
        "explode",
        "aim:assist",
        "suicide"
    },
    lang = {
        kickReason = "Prohibited command detected"
    }
}

Config.KeyBlacklist = { -- Block suspicious key combinations
    active = true,
    list = {
        {{47, 21}, "Shift + G Keys"},
        {{0x4AF4D473}, "Restricted Key"}  -- Delete key
    },
    lang = {
        kickReason = "Restricted key combination used"
    }
}

Config.AssetValidator = {
    active = false,
    list = {},
    lang = {
        kickReason = "Unauthorized texture detected"
    }
} 