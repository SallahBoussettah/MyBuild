Config = {}
Config.framework = "redemrp-reboot"--"redemrp" or "vorp" or "qbr" or "qbr2" or "redemrp-reboot" or "rsg"
Config.RefreshRate = 5

Config.Texts = {
    Zoom = "Zoom",
    Flip = "Flip",
    PutAway = "Put Away",
    LegendaryMap = "Legendary Animal Map",
    CantView = "You cant view the map now!",
    NoMap = "You dont have the map to view!",
    NoJob = "You dont have the required job to view!",
}

Config.Textures = {
    cross = {"scoretimer_textures", "scoretimer_generic_cross"},
    locked = {"menu_textures","stamp_locked_rank"},
    tick = {"scoretimer_textures","scoretimer_generic_tick"},
    money = {"inventory_items", "money_moneystack"},
    alert = {"menu_textures", "menu_icon_alert"},
}

--[[
    Usable Animal IDs:
    alligator, alligator2
    bear, bear2
    beaver, beaver2
    bison, bison2
    boar, boar2
    buck, buck2
    cougar, cougar2
    coyote, coyote2
    elk, elk2
    fox, fox2
    moose, moose2
    panther, panther2
    ram, ram2
    wolf, wolf2
]]

Config.LegendaryMaps = {
    [1] = {
        name = "Map 1",
        blip = {enable = true, sprite = -1031152097},
        coords = vector3(1855.822, -1237.817, 42.723),
        job = {"collector", "hunter"},
        item = "ricx_legendary_map_1",
        animals = { -- Use Animal IDs
            [1] = "boar", [2] = "bear2", [3] = "", [4] = "", [5] = "", [6] = "", [7] = "", [8] = "", [9] = "", [10] = "",
			[11] = "", [12] = "", [13] = "", [14] = "", [15] = "", [16] = "", [17] = "", [18] = "", [19] = "", [20] = "",
			[21] = "", [22] = "", [23] = "", [24] = "", [25] = "", [26] = "", [27] = "", [28] = "",
        },
    },
    [2] = {
        name = "Map 2",
        blip = {enable = true, sprite = -1031152097},
        coords = vector3(1855.822, -1237.817, 42.723),
        job = {"collector", "hunter"},
        item = "ricx_legendary_map_2",
        animals = { -- Use Animal IDs
            [1] = "boar", [2] = "", [3] = "elk", [4] = "elk2", [5] = "", [6] = "", [7] = "", [8] = "panther", [9] = "", [10] = "",
			[11] = "bear", [12] = "", [13] = "fox", [14] = "", [15] = "", [16] = "", [17] = "", [18] = "moose", [19] = "", [20] = "",
			[21] = "", [22] = "", [23] = "", [24] = "", [25] = "wolf", [26] = "", [27] = "wolf2", [28] = "",
        },
    },
}

--[[
    --REDEM:RP INVENTORY ITEM

    ["ricx_legendary_map_1"] = { label = "Legendary Animal Map 1", description = "Use to view", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/ricx_legendary_map_1.png", type = "item_standard",},
    ["ricx_legendary_map_2"] = { label = "Legendary Animal Map 2", description = "Use to view", weight = 0.05, canBeDropped = true, canBeUsed = true, requireLvl = 0, limit = 5,imgsrc = "items/ricx_legendary_map_2.png", type = "item_standard",},

    --QBR/QR/RS ITEM
    ['ricx_legendary_map_1'] 					= {['name'] = 'ricx_legendary_map_1', 			 	  	['label'] = 'Legendary Animal Map 1',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'ricx_legendary_map_1.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Use to view'},
	['ricx_legendary_map_2'] 					= {['name'] = 'ricx_legendary_map_2', 			 	  	['label'] = 'Legendary Animal Map 2',	    				['weight'] = 1,			['type'] = 'item', 				['image'] = 'ricx_legendary_map_1.png', 					['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,    	['level'] = 0,		['description'] = 'Use to view'},
	
]]
