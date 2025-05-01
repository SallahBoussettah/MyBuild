Config = {}

-- Discord webhook configuration for notifications
Config.Discord = {
    active = false,
    webhookavatar = "https://cdn2.iconfinder.com/data/icons/frosted-glass/256/Danger.png",
    webhookname = "Key Blacklist",
    webhook = "", -- Add your Discord webhook URL here
    lang = {
        kick = "Kicked for: "
    }
}

-- Keys Blacklist Configuration
-- Blacklist certain keys from being pressed. This can be used to detect and prevent cheat menu keys
Config.Keys = { 
    active = true,
    list = {
        {{0x4BC9DABB, 0x760A9C6F}, "Shift + G Keys"}, -- Updated key codes for Shift (0x4BC9DABB) and G (0x760A9C6F) in RedM
        {{0x4AF4D473}, "Cheat Menu"}, -- Delete key
        -- For testing, let's add some alternative Shift+G combinations with different key codes
        {{0x8FFC75D6, 0x760A9C6F}, "Left Shift + G Keys"}, -- Left shift specifically
        {{0xE8342FF2, 0x760A9C6F}, "Right Shift + G Keys"}, -- Right shift specifically
        -- You can add more blacklisted key combinations here
        -- Format: {{key1, key2, key3, key4}, "Description"}
        -- Up to 4 keys can be combined
        -- Single keys use format: {{keyCode}, "Description"}
    },
    lang = {
        kickreason = "Cheat Menu detected"
    }
} 