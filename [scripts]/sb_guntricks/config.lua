Config = {}

-- USAGE: Use /guntrick or /gt in chat to toggle gun tricks

-- GAMEPLAY SETTINGS
Config.AllowAnimationsToFinish = true -- If true, animations continue when aiming/shooting 
                                      -- (TAB key will always stop animations)

-- Control prompts
Config.Prompts = {
    Do = 0xE30CD707,    -- [R]
    End = 0xB238FE0B,   -- [TAB]
    Prev = 0xA65EBAB4,  -- [LEFT ARROW]
    Next = 0xDEB34313,  -- [RIGHT ARROW]
}

-- Gun tricks available
Config.Tricks = {
    {`KIT_EMOTE_TWIRL_GUN`, "Twirl"},
    {`KIT_EMOTE_TWIRL_GUN_DUAL`, "Dual Twirl"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_A`, "Twirl A"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_B`, "Twirl B"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_C`, "Twirl C"},
    {`KIT_EMOTE_TWIRL_GUN_VAR_D`, "Twirl D"},
}

-- Use VORP notifications instead of native
Config.UseVORPNotify = true