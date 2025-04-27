Config = {}

-- USAGE OPTIONS
-- Use /guntrick or /gt in chat to toggle gun tricks

-- GAMEPLAY SETTINGS
-- No notifications when aiming/shooting - menu will close silently
-- and animations will continue to play naturally

-- Control prompts - using the specified RedM control codes
Config.Prompts = {
    Do = 0xE30CD707,    -- [R]
    End = 0xB238FE0B,   -- [TAB]
    Prev = 0xA65EBAB4,  -- [LEFT ARROW]
    Next = 0xDEB34313,  -- [RIGHT ARROW]
}

-- Gun tricks available in the menu
Config.Tricks = {
    {`KIT_EMOTE_TWIRL_GUN`, "Twirl"},
    {`KIT_EMOTE_TWIRL_GUN_DUAL`, "Dual Twirl"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_A`, "Twirl A"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_B`, "Twirl B"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_C`, "Twirl C"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_D`, "Twirl D"},
}

-- Notifications settings
Config.UseVORPNotify = true -- Set to false if you want to use default game notifications