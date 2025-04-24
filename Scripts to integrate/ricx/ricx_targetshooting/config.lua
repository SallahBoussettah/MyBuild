Config = {}
Config.framework = "redemrp-reboot"--"redemrp" or "vorp" or "qbr" or "qbr2" or "redemrp-reboot" or "rsg"

Config.ricx_achievements = false -- turn true if you use ricx_achievements and want to add achievements to Target Shoot Finishes (requires configuration in ricx_achievements as well just like example ac_rc_targetshoot_1)

Config.Prompts = {
    PromptStart = 0x05CA7C52, --DOWN ARROW
    PromptLeaderBoard = 0x4AF4D473, --DEL
    PromptDuel = 0x8AAA0AD4, --LEFT ALT
}
Config.LeaderboardClose = 0x156F7119 --BACKSPACE
Config.LeaderboardChange = 0x4AF4D473 -- DEL - to change Latest Contesters Cache Leaderboard
Config.LeaderBoardWeapons = 0x9D2AEA88 -- LEFT CLICK

Config.LeaderboardCache = 10 -- shows the last 10 finishes, resets at script restart

Config.GameEnd = "target_end" -- in any case if the game requires stopping, the command can be used to stop Target Shooting

Config.InviteCommand = "target_accept"
Config.InviteExpire = 7 -- seconds

Config.Marker = {
    rgba = {126, 0, 0, 100},
    size = {2.0, 2.0, 0.3},
    enable = true,
}

Config.Texts = {
    PromptStart = "Start",
    PromptLeaderBoard = "Leaderboard",
    PromptDuel = "Duel",
    --TEXTS
    Leaderboard = "Leaderboard",
    Time = "Time",
    LastOnes = "Latest Ones",
    Weapon = "Weapon",
    ADistance = "Average Distance",
    FinishedGames = "Finished Games",
    NoContester = "No contesters in Leaderboard!",
    NewRecord = "You broke your record!",
    TargetShooting = "Target Shooting",
    Finished = "Finished Target Shooting!",
    SavedTime = "Your time is saved!",
    NoMoney = "You dont have enough money!",
    UsedNow = "Target Shooting is occupied!",
    Starting = "Shooting starts now!",
    Fail1 = "Failed! Others shot too much target!",
    Fail2 = "Failed! Too close to the target!",
    Fail3 = "Failed! Do not change the weapon!",
    Fail4 = "Failed Target Shooting!",
    InviteSent = "Invite sent! Wait for response now!",
    InviteGot = "You have an invite!",
    UseCommand = "Use the following command to accept:",
    NoPlayer = "Player was not found!",
    ExpiredInvite = "Invite expired! Try again!",
    NoInvite = "There is no invite for you right now!",
    PlayerId = "Add Player Id",
    NotValid1 = "Cant invite yourself!",
    DuelStart = "Duel started! Shoot as many objects as you can!",
    DuelEnd = "Duel ended!",
    YourP = "Your Points:",
    OppP = "Opponent's Points:",
    You = "You",
    Opponent = "Opponent",
}

Config.Textures = {
    cross = {"scoretimer_textures", "scoretimer_generic_cross"},
    locked = {"menu_textures","stamp_locked_rank"},
    tick = {"scoretimer_textures","scoretimer_generic_tick"},
    money = {"inventory_items", "money_moneystack"},
    alert = {"menu_textures", "menu_icon_alert"},
}

Config.Sounds = {
    started = {"HUD_MP_FREE_MODE", "HP_HORSE"},
    ended = {"FMA_ARCHERY_Sounds", "BULLSEYE"},
    cp = {"FMA_ARCHERY_Sounds", "OUTER_RING"},
    fail = {"DEATH_FAIL_RESPAWN_SOUNDS","FADE_TO_BLACK_OFF_MISSION"},
}

Config.TargetDisplay = {
    lighting = true,
    ptfx = {enable = true, dict = "eagle_eye", name = "eagle_eye_clue_animal_transform"},
}

Config.ShowNamesDuel = true

Config.TargetShootings = {
    target1 = {
        name = "Target Armadillo",
        blip = {enable = true, sprite = 1366733613},
        coords = vector3(-3672.270, -2588.551, -14.675),
        price = 10,
        maxHitsFromOthersBeforeFail = 3, -- for solo game
        minDistanceBeforeFail = 3.0, -- minimum distance between player and target | for solo game
        ricx_achievements = "ac_rc_targetshoot_1", -- requires ricx_achievements | for solo game
        targets = {
            --objType: between 1 and 6
            {pos = vector3(-3672.426, -2579.851, -14.458), rot = vector3(0.0, 0.0, -154.99), objType = `p_watermelon01x`},
            {pos = vector3(-3667.910, -2579.628, -14.446), rot = vector3(0.0, 0.0, -12.4), objType = 2},
            {pos = vector3(-3666.685, -2573.063, -14.572), rot = vector3(0.0, 0.0, -11.0), objType = 5},
            {pos = vector3(-3667.841, -2572.325, -14.111), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3669.535, -2570.253, -13.511), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3668.131, -2571.027, -14.111), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3670.453, -2570.581, -13.511), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3672.372, -2571.587, -13.591), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3671.290, -2573.023, -14.591), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3669.593, -2571.438, -14.591), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3668.351, -2572.650, -14.591), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3673.716, -2573.195, -14.571), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3672.996, -2571.740, -12.811), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3673.647, -2571.538, -12.811), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3675.231, -2571.750, -14.051), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3675.698, -2572.184, -14.051), rot = vector3(0.0, 0.0, -6.0), objType = 5},
            {pos = vector3(-3676.246, -2569.793, -13.521), rot = vector3(0.0, 0.0, -6.0), objType = 5},            
            {pos = vector3(-3676.013, -2579.325, -14.458 ), rot = vector3(0.0, 0.0, 16.54), objType = 3},
            {pos = vector3(-3676.246, -2581.896, -14.458), rot = vector3(0.0, 0.0, 17.5), objType = 4},
        },
        duel_targets = {
            {pos = vector3(-3666.685, -2573.063, -14.572), rot = vector3(0.0, 0.0, -11.0)},
            {pos = vector3(-3667.841, -2572.325, -14.111), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3669.535, -2570.253, -13.511), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3668.131, -2571.027, -14.111), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3670.453, -2570.581, -13.511), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3672.372, -2571.587, -13.591), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3671.290, -2573.023, -14.591), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3669.593, -2571.438, -14.591), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3668.351, -2572.650, -14.591), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3673.716, -2573.195, -14.571), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3672.996, -2571.740, -12.811), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3673.647, -2571.538, -12.811), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3675.231, -2571.750, -14.051), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3675.698, -2572.184, -14.051), rot = vector3(0.0, 0.0, -6.0)},
            {pos = vector3(-3676.246, -2569.793, -13.521), rot = vector3(0.0, 0.0, -6.0)},
        },
    },
    target2 = {
        name = "Target Scarecrow",
        blip = {enable = true, sprite = 1366733613},
        coords = vector3(1714.771, -438.340, 47.836),
        price = 12,
        maxHitsFromOthersBeforeFail = 3,
        minDistanceBeforeFail = 3.0, -- minimum distance between player and target 
        targets = {
            --objType: between 1 and 6
            {pos = vector3(1715.338, -425.279, 47.863), rot = vector3(0.0, 0.0, -2.0), objType = 3},
            {pos = vector3(1705.104, -420.139, 47.811), rot = vector3(0.0, 0.0, 4.3), objType = 3},
            {pos = vector3(1711.833, -412.620, 47.792), rot = vector3(0.0, 0.0, 2.2), objType = 3},
            {pos = vector3(1722.714, -409.201, 47.102), rot = vector3(0.0, 0.0, -44.0), objType = 3},
            {pos = vector3(1717.174, -406.058, 47.368), rot = vector3(0.0, 0.0, -10.0), objType = 3},
            {pos = vector3(1732.938, -426.654, 47.216), rot = vector3(0.0, 0.0, -58.0), objType = 3},
            {pos = vector3(1731.782, -417.760, 47.015), rot = vector3(0.0, 0.0, -40.0), objType = 3},            
        },
        duel_targets = {
            {pos = vector3(1715.338, -425.279, 47.863), rot = vector3(0.0, 0.0, -2.0)},
            {pos = vector3(1705.104, -420.139, 47.811), rot = vector3(0.0, 0.0, 4.3)},
            {pos = vector3(1711.833, -412.620, 47.792), rot = vector3(0.0, 0.0, 2.2)},
            {pos = vector3(1722.714, -409.201, 47.102), rot = vector3(0.0, 0.0, -44.0)},
            {pos = vector3(1717.174, -406.058, 47.368), rot = vector3(0.0, 0.0, -10.0)},
            {pos = vector3(1732.938, -426.654, 47.216), rot = vector3(0.0, 0.0, -58.0)},
            {pos = vector3(1731.782, -417.760, 47.015), rot = vector3(0.0, 0.0, -40.0)},            
        },
    },
    target3 = {
        name = "Target Marsh Shine",
        blip = {enable = true, sprite = 1366733613},
        coords = vector3(2124.886, -501.549, 40.967),
        price = 8,
        maxHitsFromOthersBeforeFail = 3,
        minDistanceBeforeFail = 3.0, -- minimum distance between player and target 
        targets = {
            --objType: between 1 and 6
            {pos = vector3(2135.250, -501.650, 40.816), rot = vector3(0.0, 0.0, -77.0), objType = 5},
            {pos = vector3(2135.234, -500.657, 40.816), rot = vector3(0.0, 0.0, -77.0), objType = 5}, 
            {pos = vector3(2137.408, -501.334, 40.762), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2137.338, -499.721, 40.734), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2138.876, -500.660, 40.767), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2140.862, -498.542, 40.786), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2140.548, -498.113, 40.786), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2140.544, -497.298, 40.746), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2133.980, -498.835, 40.642), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2131.688, -496.369, 40.549), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2135.827, -497.868, 40.608), rot = vector3(0.0, 0.0, -77.0), objType = 5},                 
            {pos = vector3(2134.663, -494.371, 40.525), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2139.177, -496.174, 40.545), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2137.475, -493.009, 40.514), rot = vector3(0.0, 0.0, -77.0), objType = 5},     
            {pos = vector3(2146.102, -492.150, 40.540), rot = vector3(0.0, 0.0, -77.0), objType = 5},   
            {pos = vector3(2146.618, -488.337, 40.486), rot = vector3(0.0, 0.0, -77.0), objType = 5},   
        },
        duel_targets = {
            {pos = vector3(2135.250, -501.650, 40.816), rot = vector3(0.0, 0.0, -77.0)},
            {pos = vector3(2135.234, -500.657, 40.816), rot = vector3(0.0, 0.0, -77.0)}, 
            {pos = vector3(2137.408, -501.334, 40.762), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2137.338, -499.721, 40.734), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2138.876, -500.660, 40.767), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2140.862, -498.542, 40.786), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2140.548, -498.113, 40.786), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2140.544, -497.298, 40.746), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2133.980, -498.835, 40.642), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2131.688, -496.369, 40.549), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2135.827, -497.868, 40.608), rot = vector3(0.0, 0.0, -77.0)},                 
            {pos = vector3(2134.663, -494.371, 40.525), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2139.177, -496.174, 40.545), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2137.475, -493.009, 40.514), rot = vector3(0.0, 0.0, -77.0)},     
            {pos = vector3(2146.102, -492.150, 40.540), rot = vector3(0.0, 0.0, -77.0)},   
            {pos = vector3(2146.618, -488.337, 40.486), rot = vector3(0.0, 0.0, -77.0)},   
        },
    },
    target4 = {
        name = "Target Desert",
        blip = {enable = true, sprite = 1366733613},
        coords = vector3(-6073.560, -3286.690, -18.726),
        price = 10,
        maxHitsFromOthersBeforeFail = 3,
        minDistanceBeforeFail = 5.0, -- minimum distance between player and target 
        targets = {
            --objType: between 1 and 6
            {pos = vector3(-6074.568, -3308.899, -19.041), rot = vector3(0.0, 0.0, -175.0), objType = 5},
            {pos = vector3(-6073.498, -3308.921, -19.207), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6072.691, -3309.815, -19.246), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6071.530, -3310.277, -19.421), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6070.965, -3309.360, -19.598), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6069.832, -3309.090, -19.878), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6070.222, -3306.010, -19.826), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6069.610, -3305.005, -19.924), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6067.882, -3306.519, -20.194), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6065.767, -3308.511, -20.572), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6063.917, -3309.259, -20.859), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6062.372, -3308.238, -20.978), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6063.390, -3306.132, -20.883), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6063.718, -3304.495, -20.918), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6063.174, -3303.761, -21.070), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6062.065, -3303.534, -21.301), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6058.777, -3304.856, -21.819), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6057.010, -3304.888, -22.028), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6057.614, -3303.541, -22.011), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6058.789, -3302.034, -22.051), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6060.130, -3300.792, -22.022), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6062.503, -3298.460, -21.521), rot = vector3(0.0, 0.0, -170.0), objType = 5},
            {pos = vector3(-6063.990, -3297.092, -21.148), rot = vector3(0.0, 0.0, -170.0), objType = 5},
        },
        duel_targets = {
            {pos = vector3(-6074.568, -3308.899, -19.041), rot = vector3(0.0, 0.0, -175.0)},
            {pos = vector3(-6073.498, -3308.921, -19.207), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6072.691, -3309.815, -19.246), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6071.530, -3310.277, -19.421), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6070.965, -3309.360, -19.598), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6069.832, -3309.090, -19.878), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6070.222, -3306.010, -19.826), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6069.610, -3305.005, -19.924), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6067.882, -3306.519, -20.194), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6065.767, -3308.511, -20.572), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6063.917, -3309.259, -20.859), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6062.372, -3308.238, -20.978), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6063.390, -3306.132, -20.883), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6063.718, -3304.495, -20.918), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6063.174, -3303.761, -21.070), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6062.065, -3303.534, -21.301), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6058.777, -3304.856, -21.819), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6057.010, -3304.888, -22.028), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6057.614, -3303.541, -22.011), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6058.789, -3302.034, -22.051), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6060.130, -3300.792, -22.022), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6062.503, -3298.460, -21.521), rot = vector3(0.0, 0.0, -170.0)},
            {pos = vector3(-6063.990, -3297.092, -21.148), rot = vector3(0.0, 0.0, -170.0)},
        },
    },
    
}

Config.WeaponNames = {
    [`weapon_pistol_volcanic`] = "Volcanic Pistol",
    [`weapon_pistol_m1899`] = "M1899 Pistol",   
    [`weapon_pistol_semiauto`] = "SemiAuto Pistol",
    [`weapon_pistol_mauser`] = "Mauser Pistol", 

    [`weapon_repeater_evans`] = "Evans Repeater",
    [`weapon_repeater_henry`] = "Henry Repeater",
    [`weapon_repeater_winchester`] = "Winchester Repeater",
    [`weapon_repeater_carbine`] = "Carbine Repeater",    
  
    [`weapon_revolver_doubleaction`] = "Double-Action Revolver",
    [`weapon_revolver_cattleman`] = "Cattleman Revolver",   
    [`weapon_revolver_cattleman_mexican`] = "Cattleman Mexican Revolver",
    [`weapon_revolver_lemat`] = "Lemat Revolver",  
    [`weapon_revolver_schofield`] = "Schofield Revolver",   
    [`weapon_revolver_doubleaction_gambler`] = "Double-Action Gambler",      
    [`weapon_revolver_navy`] = "Navy Revolver",
    [`weapon_revolver_navy_crossover`] = "Navy Crossover Revolver",
  
    [`weapon_rifle_springfield`] = "Springfield Rifle",   
    [`weapon_rifle_boltaction`] = "BoltAction Rifle",    
    [`weapon_rifle_varmint`] = "Varmint Rifle", 
    [`weapon_rifle_elephant`] = "Elephant Rifle",

    [`weapon_shotgun_sawedoff`] = "Sawed Off Shotgun",  
    [`weapon_shotgun_doublebarrel_exotic`] = "D.Barrel Exotic Shotgun",
    [`weapon_shotgun_pump`] = "Pump Shotgun",      
    [`weapon_shotgun_repeating`] = "Repeating Shotgun", 
    [`weapon_shotgun_semiauto`] = "SemiAuto Shotgun",  
    [`weapon_shotgun_doublebarrel`] = "Double Barrel Shotgun",   

    [`weapon_sniperrifle_carcano`] = "Carcano Rifle",
    [`weapon_sniperrifle_rollingblock`] = "RollingBlock Rifle",

    [`weapon_bow`] = "Bow",                    
    [`weapon_bow_improved`] = "Improved Bow",
}
