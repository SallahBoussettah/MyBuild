Config = {}
Config.framework = "redemrp-reboot"--"redemrp" or "vorp" or "qbr" or "qbr2" or "redemrp-reboot" or "rsg"

Config.ViewDistanceObject = 70.0

Config.AdminIdentifiers = {
    "steam:3230030"
}

Config.CanAnyoneCloseLocker = true
Config.GiveBackLockerItemAtRemove = false

Config.StashSizes = {
    ["redemrp"] = false,--no stash size in redemrp 2.0
    ["redemrp-reboot"] = 500,
    ["rsg"] =  {maxweight = 10000, slots = 20},
    ["qbr"] =  {maxweight = 10000, slots = 20},
    ["qbr2"] =  {maxweight = 10000, slots = 20},
    ["vorp"] = 500,
}

Config.Prompts = {
    PromptOpen = 0x05CA7C52,
    PromptPlace = 0x05CA7C52,
    PromptCancel = 0x308588E6, 
    PromptRotate = 0x62800C92,
    PromptRotate2 = 0x8BDE7443,
    PromptHammer = 0x07B8BEAF,
    PromptLock = 0xD9D0E1C0,
    PromptShoot = 0x07B8BEAF,
    PromptDestroy = 0x43DBF61F,
    PromptDestroy2 = 0x07B8BEAF,
}

Config.Marker = {
    rgba = {126, 0, 0, 100},
    size = {2.0, 2.0, 0.3},
    enable = true,
}

Config.Texts = {
    PromptOpen = "Open",
    PromptPlace = "Place",
    PromptCancel = "Cancel",
    PromptRotate = "Rotate",
    PromptRotate2 = "Rotate",
    PromptHammer = "Hit",
    PromptMove = "Move",
    PromptShoot = "Shoot Lock",
    PromptLock = "Locker Lock",
    PromptDestroy = "Destroy",
    --TEXTS
    Lockers = "Locker",
    LastHit = "Last Hit",
    NoAround = "Make sure noone is around you to open!",
    GoCloser = "Go closer to Locker!",
    LockerIsLocked = "Locker is locked!",
    WaitSome = "You cant do that now, wait some time!",
    CantDo = "You cant do that!",
    LockerIsUnlocked = "Locker is already unlocked!",
    WaitBefore = "You have to wait some time before doing again!",
    LockerUnlock = "Locker is unlocked now!",
    LockerLock = "Locker is locked now!",
    NotOwned = "You dont own this Locker!",
    LockerUnlock2 = "Great Shot! Locker is unlocked now!",
    MissShovel = "You dont have Shovel to Dig!",
    NoLocker = "You dont have Locker item!",
    LimitReached = "Locker Limit reached!",
    LockerPlaced = "Locker placed successfully!",
    WalkAway = "Walk a little bit away for shooting!",
    TooClose = "You are too close for shooting!",
    NoAmmo = "You need more ammo for shooting!",
    NoWeapon = "You need a Gun first!",
    UnlockedAlready = "Locker is already unlocked!",
    CantPlaceHere = "You cant place it here, find another spot!",
    MissAxe = "You are missing the Axe!",
    LockerDestroyed = "Locker is destroyed!",
    AddCode = "Add Code",
    InvalidCode = "Invalid Code!",
    --Webhooks
    W_Source = "Source",
    W_Id = "Identifiers",
    W_LockerID = "Locker ID",
    W_LockerIDL = "Locker Lock",
    W_Locked = "Lock",
    W_Code = "Code",
}

Config.Textures = {
    cross = {"scoretimer_textures", "scoretimer_generic_cross"},
    locked = {"menu_textures","stamp_locked_rank"},
    tick = {"scoretimer_textures","scoretimer_generic_tick"},
    money = {"inventory_items", "money_moneystack"},
    alert = {"menu_textures", "menu_icon_alert"},
}

Config.DisableKeysWhilePlace = {
    --add here control keys to disable
    0xD9D0E1C0,
    0xCEFD9220,
}

Config.HammerMashAmount = 2 
Config.MaxLockersPerPlayer = 10

Config.Destroy = {
    required_item = {item = "axe_barricade", amount = 1, remove = false},
    mash_amount = 2,
}

Config.box = `p_chair_crate02x`

Config.CodeLength = 5
Config.LockOpenBullets = 2

Config.Lockers = {
    r_locker1 = {
        item = "r_locker1",
        name = "Locker 1",
        model = `p_barrel_cor02x`,
        code = false,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker2 = {
        item = "r_locker2",
        name = "Locker 2",
        model = `p_cabinet01x`,
        code = true,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker3 = {
        item = "r_locker3",
        name = "Locker 3",
        model = `p_cabinet03x`,
        code = true,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker4 = {
        item = "r_locker4",
        name = "Locker 4",
        model = `p_cabinet15x`,
        code = true,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker5 = {
        item = "r_locker5",
        name = "Locker 5",
        model = `p_gunrack02x`,
        code = true,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker6 = {
        item = "r_locker6",
        name = "Locker 6",
        model = `s_vault_lrg_l_val01x`,
        code = true,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker7 = {
        item = "r_locker7",
        name = "Locker 7",
        model = `s_vault_med_l_val01x`,
        code = true,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker8 = {
        item = "r_locker8",
        name = "Locker 8",
        model = `s_vault_sml_l_val01x`,
        code = true,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker9 = {
        item = "r_locker9",
        name = "Locker 9",
        model = `mp004_mp_gfh_cratebooze01x`,
        code = false,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
    r_locker10 = {
        item = "r_locker10",
        name = "Locker 10",
        model = `mp006_p_mp006_crate012x`,
        code = true,
        stash_size = {
            ["redemrp"] = false,--no stash size in redemrp 2.0
            ["redemrp-reboot"] = 50,
            ["rsg"] =  {maxweight = 2500, slots = 10},
            ["qbr"] =  {maxweight = 2500, slots = 10},
            ["qbr2"] =  {maxweight = 2500, slots = 10},
            ["vorp"] = {size = 50, acceptWeapons = true, shared = true, ignoreItemStackLimit = true, whitelistItems = false, UsePermissions = false, UseBlackList = false, whitelistWeapons = false},
        },
    },
}


--[[
    --REDEM:RP INVENTORY ITEM

    ["r_locker1"] = { label = "Locker 1", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker1.png", type = "item_standard",},
    ["r_locker2"] = { label = "Locker 2", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker2.png", type = "item_standard",},
    ["r_locker3"] = { label = "Locker 3", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker3.png", type = "item_standard",},
    ["r_locker4"] = { label = "Locker 4", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker4.png", type = "item_standard",},
    ["r_locker5"] = { label = "Locker 5", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker5.png", type = "item_standard",},
    ["r_locker6"] = { label = "Locker 6", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker6.png", type = "item_standard",},
    ["r_locker7"] = { label = "Locker 7", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker7.png", type = "item_standard",},
    ["r_locker8"] = { label = "Locker 8", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker8.png", type = "item_standard",},
    ["r_locker9"] = { label = "Locker 9", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker9.png", type = "item_standard",},
    ["r_locker10"] = { label = "Locker 10", description = "Place for storage", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/r_locker10.png", type = "item_standard",},

    --QBR/QR/RS ITEM
    ['r_locker1'] 					= {['name'] = 'r_locker1', 			 	  	['label'] = 'Locker 1',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker1.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker2'] 					= {['name'] = 'r_locker2', 			 	  	['label'] = 'Locker 2',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker2.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker3'] 					= {['name'] = 'r_locker3', 			 	  	['label'] = 'Locker 3',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker3.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker4'] 					= {['name'] = 'r_locker4', 			 	  	['label'] = 'Locker 4',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker4.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker5'] 					= {['name'] = 'r_locker5', 			 	  	['label'] = 'Locker 5',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker5.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker6'] 					= {['name'] = 'r_locker6', 			 	  	['label'] = 'Locker 6',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker6.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker7'] 					= {['name'] = 'r_locker7', 			 	  	['label'] = 'Locker 7',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker7.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker8'] 					= {['name'] = 'r_locker8', 			 	  	['label'] = 'Locker 8',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker8.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker9'] 					= {['name'] = 'r_locker9', 			 	  	['label'] = 'Locker 9',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker9.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},
    ['r_locker10'] 					= {['name'] = 'r_locker10', 			 	  	['label'] = 'Locker 10',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'r_locker10.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Place for storage'},

]]
