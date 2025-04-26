-- * SELL ITEMS * --
-- Items that players can sell to the mining store

-- * TO ADD DECIMAL PRICES TO THE RANDOMPRICE DO IT LIKE THIS: math.random(30, 50) / 100 >> this will equal to 0.30 to 0.50 or math.random(300, 500) / 100 will equal to 3.00 to 5.00

Config.SellItems = {
    -- GrizzliesStore is the key used in Config.MiningStores
    GrizzliesStore = {
        -- Gold Nugget (from Mining.sql)
        {
            itemLabel = "Gold Nugget",
            itemName = "goldnugget",
            currencyType = "cash",
            sellprice = 30,
            randomprice = math.random(25, 35),
            desc = "Sell gold nuggets to the mining store.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Copper Bar (from Mining.sql)
        {
            itemLabel = "Copper Bar",
            itemName = "clay",
            currencyType = "cash",
            sellprice = 15,
            randomprice = math.random(12, 18),
            desc = "Sell copper bars to the mining store.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Zinc Bar (from Mining.sql)
        {
            itemLabel = "Zinc Bar",
            itemName = "provision_coal",
            currencyType = "cash",
            sellprice = 12,
            randomprice = math.random(10, 15),
            desc = "Sell zinc bars to the mining store.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Titanium Bar (from Mining.sql)
        {
            itemLabel = "Titanium Bar",
            itemName = "copper",
            currencyType = "cash",
            sellprice = 25,
            randomprice = math.random(20, 30),
            desc = "Sell titanium bars to the mining store.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Blacksteel Bar (from Mining.sql)
        {
            itemLabel = "Blacksteel Bar",
            itemName = "iron",
            currencyType = "cash",
            sellprice = 20,
            randomprice = math.random(18, 25),
            desc = "Sell blacksteel bars to the mining store.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Brass Bar (from Mining.sql)
        {
            itemLabel = "Brass Bar",
            itemName = "sulfur",
            currencyType = "cash",
            sellprice = 18,
            randomprice = math.random(15, 22),
            desc = "Sell brass bars to the mining store.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Lead Bar (from Mining.sql)
        {
            itemLabel = "Lead Bar",
            itemName = "stone",
            currencyType = "cash",
            sellprice = 10,
            randomprice = math.random(8, 12),
            desc = "Sell lead bars to the mining store.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Coal (from vorp_mining/config.lua)
        {
            itemLabel = "Coal",
            itemName = "coal",
            currencyType = "cash",
            sellprice = 8,
            randomprice = math.random(6, 10),
            desc = "Sell coal to the mining store. Used as fuel for furnaces.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Nitrite (from vorp_mining/config.lua)
        {
            itemLabel = "Nitrite",
            itemName = "nitrite",
            currencyType = "cash",
            sellprice = 16,
            randomprice = math.random(14, 20),
            desc = "Sell nitrite to the mining store. Used in crafting explosives.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Rocks (from vorp_mining/config.lua)
        {
            itemLabel = "Rocks",
            itemName = "rock",
            currencyType = "cash",
            sellprice = 5,
            randomprice = math.random(3, 7),
            desc = "Sell rocks to the mining store. Basic building material.",
            category = "ore",
            itemLimit = 50,
        },
        
        -- Salt (from vorp_mining/config.lua)
        {
            itemLabel = "Salt",
            itemName = "salt",
            currencyType = "cash",
            sellprice = 7,
            randomprice = math.random(5, 9),
            desc = "Sell salt to the mining store. Used for preserving food.",
            category = "ore",
            itemLimit = 50,
        },
    }
} 