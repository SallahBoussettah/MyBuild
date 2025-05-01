Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "Command Blacklist",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}

-- Commands Blacklist Configuration
-- Blacklisted commands. This can be used to detect and prevent cheat menu commands
Config.Commands = { 
    active = true,
    list = {
        "lynx",
        "test:exp",
        "get:playerid",
        "test",
        "bomb",
        "test:aimbot",
        "kms"
    },
    lang = {
        kickreason = "Cheat command detected"
    }
} 