Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "AFK System",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}

-- AFK System Configuration
Config.AFK = {
    active = true,
    kicktime = 1800, -- Seconds until kick (default: 30 minutes)
    warntime = 1600, -- Seconds until warning (default: 26 minutes before kick)
    lang = {
        kick = "You will be kicked in ",
        kick2 = " for AFK",
        hours = " hours",
        minutes = " minutes",
        seconds = " seconds",
        kickreason = "AFK",
        whitelist = {
            id = "You must include a user id",
            wladded = "User Added to Whitelist",
            wlremoved = "User Removed from Whitelist",
            err = "An Error has Occurred"
        }
    }
} 