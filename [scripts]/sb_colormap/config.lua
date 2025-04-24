Config = {}

-- Map region color configuration
-- You can edit the colors of each region by changing the color values
-- Available colors can be found in RedM natives documentation
Config.ColorMap = {
    STATE_NEW_HANOVER = { -- whole new hanover area 
		hash = 0x41332496,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
    STATE_WEST_ELIZABETH = { -- whole west elisa area 
		hash = 0xD69B5B49,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
	STATE_LEMOYNE = { -- whole leymoyne state area 
		hash = 0x945395DF,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
    BAYOU_NWA = { -- Saint denis outer bounds
		hash = 0x2843E325,
		color = "BLIP_STYLE_AREA_BOUNDS_OVERLAY", -- This makes shadow on the map, you can disable it
    },
    BIG_VALLEY = { -- Strawberry area
		hash = 0x8DCC574F,
		color = "BLIP_STYLE_FM_EVENT",
    },
    BLUEGILL_MARSH = { -- prison inside area
		hash = 0x024C01CA,
		color = "BLIP_STYLE_DEBUG_YELLOW",
    },
    CHOLLA_SPRINGS = { -- armadillo area
		hash = 0x99B6A1E6,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    CUMBERLAND_FOREST = { -- cumberland forest area
		hash = 0x717F4A96,
		color = "BLIP_STYLE_AREA_BOUNDS",
    },
    DIEZ_CORONAS = { -- idk maybe mexico ?
		hash = 0x8966022D,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    GAPTOOTH_RIDGE = { -- GAPTOOTH_RIDGE
		hash = 0x3AC128F9,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    GREAT_PLAINS = { -- GREAT_PLAINS
		hash = 0x0E95FF51,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
	REGION_BAY_SAINT_DENIS = { -- saint denis city area
		hash = 0x2A6CBBA2,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },	
    DISTRICT_GRIZZLIES_EAST = { -- DISTRICT_GRIZZLIES_EAST
		hash = 0x943198D3,
		color = "BLIP_STYLE_FM_EVENT",
    },
    DISTRICT_GRIZZLIES_WEST = { -- DISTRICT_GRIZZLIES_WEST -- this one working the DISTRICT_GRIZZLIES can be undefined
		hash = 0xD41D039A,
		color = "BLIP_STYLE_FM_EVENT",
    },
    DISTRICT_HEARTLAND = { -- DISTRICT_HEARTLAND heartland oilfields and valentine
		hash = 0x724E7654,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
    DISTRICT_HENNIGANS_STEAD = { -- mcflarens ranch and thieves landing 
		hash = 0x33D88587,
		color = "BLIP_STYLE_COP_PERSISTENT",
    },
    DISTRICT_PERDIDO = { -- idk no idea-- border
		hash = 0x27253ED3,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    DISTRICT_PUNTA_ORGULL = { -- idk no idea
		hash = 0x5046DD11,
		color = "BLIP_STYLE_AREA_BOUNDS",
    },
    DISTRICT_RIO_BRAVO = { -- rio bravo
		hash = 0xD428627B,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    DISTRICT_ROANOKE_RIDGE = { -- annesburg and so on
		hash = 0x30FAE29B,
		color = "BLIP_STYLE_DEBUG_BLUE",
    },
    DISTRICT_SCARLETT_MEADOWS = { -- rhodes and so on
		hash = 0x0BB92EEF,
		color = "BLIP_STYLE_AREA_BOUNDS",
    },
    DISTRICT_TALL_TREES = { -- TALL_TREES
		hash = 0x763A8A87,
		color = "BLIP_STYLE_AREA_BOUNDS",
    },
    LBS_AMBARINO_BOUNTY = { -- water lines at valentine 
		hash = 0x3BBA228A,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    LBS_GUARMA_BOUNTY = { -- guarma waterlines ? 
		hash = 0x6009F334,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    LBS_LEMOYNE_BOUNTY = { -- lemoyne waterlines 
		hash = 0x0F32B44D,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    LBS_NEW_AUSTIN_BOUNTY = { -- newaustin waterlines 
		hash = 0xD339F6AB,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    LBS_NEW_HANOVER_BOUNTY = { -- new hanover waterlines 
		hash = 0x5CD2A36F,
		color = "BLIP_STYLE_DEBUG_RED",
    },
    LBS_W_ELIZABETH_BOUNTY = { -- strawberry waterlines 
		hash = 0xF030C0B2,
		color = "BLIP_STYLE_DEBUG_RED",
    },
	REGION_SCM_RHODES = { -- RHODES area
		hash = 0xD3F2B8A7,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
	REGION_BGV_STRAWBERRY = { -- STRAWBERRY city area
		hash = 0x4663EEB9,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
	REGION_CML_OLDFORTWALLACE = { -- fort wallace at valentine
		hash = 0x1BDD5A12,
		color = "BLIP_STYLE_DEBUG_RED",
    },
	REGION_GRZ_WAPITI = { -- WAPITI city area
		hash = 0xBB785C8A,
		color = "BLIP_STYLE_DEBUG_RED",
    },
	REGION_BAY_LAGRAS = { -- lagras small area
		hash = 0x9652B96E,
		color = "BLIP_STYLE_DEBUG_YELLOW",
    },
	REGION_GUA_MANICATO = { -- idk maybe guarma
		hash = 0x6E10D212,
		color = "BLIP_STYLE_DEBUG_RED",
    },
	REGION_HRT_EMERALDRANCH = { -- emeraldranch area
		hash = 0x6E7BDAC4,
		color = "BLIP_STYLE_DEBUG_BLUE",
    },
	REGION_ROA_VANHORNPOST = { -- VANHORNPOST area
		hash = 0x507B5360,
		color = "BLIP_STYLE_DEBUG_YELLOW",
    },
	REGION_SCM_BRAITHWAITEMANOR = { -- BRAITHWAITEMANOR area
		hash = 0xFC531E7A,
		color = "BLIP_STYLE_DEBUG_GREEN",
    },
	REGION_SCM_CALIGAHALL = { -- CALIGAHALL area
		hash = 0xD218D90D,
		color = "BLIP_STYLE_DEBUG_YELLOW",
    },
	REGION_SCM_RHODES = { -- RHODES area
		hash = 0xD3F2B8A7,
		color = "BLIP_STYLE_DEBUG_GREEN",
    }
} 

-- Custom Family Territories
-- Add your family territories here with their region hashes
-- Format: FAMILY_NAME = { hash = regionHash, color = "COLOR_NAME", label = "Family Name" }
Config.FamilyTerritories = {
    -- Example family territories (you can modify or remove these)
    EXAMPLE_FAMILY_VALENTINE = {
        hash = 0x724E7654, -- This is the DISTRICT_HEARTLAND hash (Valentine area)
        color = "BLIP_STYLE_ADVERSARY",
        label = "Valentine Outlaws"
    },
    EXAMPLE_FAMILY_RHODES = {
        hash = 0xD3F2B8A7, -- This is the RHODES area hash
        color = "BLIP_STYLE_MP_MISSION_GIVER",
        label = "Rhodes Gang"
    },
    -- Add more family territories as needed
}

-- Available region hashes reference
-- This table is for reference only - it shows the hash for many regions
-- To find more region hashes, you can use a helper script or research online
Config.RegionHashReference = {
    -- States
    STATE_AMBARINO = 0x3B8DD21A,
    STATE_LEMOYNE = 0x945395DF,
    STATE_NEW_AUSTIN = 0x41759831,
    STATE_NEW_HANOVER = 0x41332496,
    STATE_WEST_ELIZABETH = 0xD69B5B49,
    
    -- Towns and settlements
    TOWN_VALENTINE = 0x0A355D78, 
    TOWN_RHODES = 0x94532B8C,
    TOWN_STRAWBERRY = 0xCF6D9801,
    TOWN_SAINT_DENIS = 0x6437ACFE,
    TOWN_BLACKWATER = 0xBC581A5C,
    TOWN_ARMADILLO = 0x0EE1A2FF,
    TOWN_TUMBLEWEED = 0xD401A84E,
    TOWN_ANNESBURG = 0x19486A19,
    SETTLEMENT_LAGRAS = 0xD3F276D1,
    SETTLEMENT_MANZANITA_POST = 0x7B23B4C7,
    
    -- Add more as you discover them
}

-- BLIP STYLE COLORS for reference
Config.AvailableColors = {
    -- Standard colors
    "BLIP_STYLE_DEBUG_RED",
    "BLIP_STYLE_DEBUG_GREEN",
    "BLIP_STYLE_DEBUG_BLUE",
    "BLIP_STYLE_DEBUG_YELLOW",
    
    -- Special styles
    "BLIP_STYLE_ADVERSARY",          -- Purple
    "BLIP_STYLE_AREA_BOUNDS",        -- Light blue outline
    "BLIP_STYLE_AREA_BOUNDS_OVERLAY", -- Shaded overlay
    "BLIP_STYLE_COP_PERSISTENT",     -- Blue/grey
    "BLIP_STYLE_FM_EVENT",           -- Light purple
    "BLIP_STYLE_MP_MISSION_GIVER",   -- Orange
    "BLIP_STYLE_MP_ADVERSARY",       -- Red
    "BLIP_STYLE_AMBIENT_LOCATION",   -- White
    "BLIP_STYLE_FRIENDLY",           -- Light green
    
    -- Add more as needed
} 

-- Custom Area Blips
-- These are circular areas you can place anywhere on the map
-- Unlike region coloring, these let you define custom-sized areas with specific colors
Config.CustomAreaBlips = {
    -- Example custom areas (modify or remove these)
    {
        name = "Valentine Gang Territory",
        x = -284.28,      -- X coordinate
        y = 804.92,       -- Y coordinate
        radius = 100.0,   -- Size of the area in meters
        color = 6,        -- Color ID: 1=White, 2=Yellow, 3=Purple, 5=Blue, 6=Pink, 7=Red, 10=Green, etc.
        alpha = 128,      -- Transparency (0-255)
        highDetail = true, -- Higher quality circle
        visible = true    -- Whether the area is visible on the map
    },
    {
        name = "Saint Denis Territory",
        x = 2732.25,
        y = -1402.14,
        radius = 150.0,
        color = 10,       -- Green
        alpha = 100,
        highDetail = true,
        visible = true
    },
    -- Add more custom areas as needed
}

-- Custom Map Overlay Zones
-- These are more subtle area highlights that blend with the map better,
-- similar to the region coloring but for custom areas
Config.CustomMapOverlays = {
    -- Example overlay areas (modify or remove these)
    {
        name = "Valentine Family Zone",
        x = -284.28,        -- X coordinate
        y = 804.92,         -- Y coordinate
        radius = 100.0,     -- Size of the area in meters
        style = "BLIP_STYLE_AREA_BOUNDS_OVERLAY", -- Style matches the region coloring
        visible = true      -- Whether the area is visible on the map
    },
    {
        name = "Saint Denis Family Zone",
        x = 2732.25,
        y = -1402.14,
        radius = 150.0,
        style = "BLIP_STYLE_DEBUG_GREEN", -- Green tint that matches region coloring
        visible = true
    },
    -- Pincertens family territory from the screenshot
    {
        name = "Pincertens Family Territory",
        x = 1088.90,        -- X coordinate from screenshot
        y = -747.66,         -- Y coordinate from screenshot 
        radius = 150.0,     -- Size of the area in meters
        style = "BLIP_STYLE_DEBUG_RED", -- Red tint for their territory
        visible = true      -- Whether the area is visible on the map
    },
    -- Add more custom overlay areas as needed
}

-- Map overlay styling reference
Config.MapOverlayStyles = {
    -- These styles will blend with the map more naturally like the region coloring
    "BLIP_STYLE_DEBUG_GREEN",      -- Green tint
    "BLIP_STYLE_DEBUG_RED",        -- Red tint
    "BLIP_STYLE_DEBUG_BLUE",       -- Blue tint 
    "BLIP_STYLE_DEBUG_YELLOW",     -- Yellow tint
    "BLIP_STYLE_AREA_BOUNDS",      -- Light blue outline
    "BLIP_STYLE_AREA_BOUNDS_OVERLAY", -- Light shadow overlay (most subtle)
    "BLIP_STYLE_FM_EVENT",         -- Light purple
    "BLIP_STYLE_COP_PERSISTENT",   -- Blue/grey
    -- Add more as needed
} 