-- * BUY ITEMS * --
-- Items that can be purchased from the mining store

-- * TO ADD DECIMAL PRICES TO THE RANDOMPRICE DO IT LIKE THIS: math.random(30, 50) / 100 >> this will equal to 0.30 to 0.50 or math.random(300, 500) / 100 will equal to 3.00 to 5.00

Config.BuyItems = {
    -- GrizzliesStore is the key used in Config.MiningStores
    GrizzliesStore = {
        -- Tools Category
        {
            itemLabel = "Pickaxe",
            itemName = "pickaxe",
            currencyType = "cash",
            buyprice = 45,
            randomprice = math.random(40, 50),
            desc = "A sturdy pickaxe for mining ore deposits.\nLimit: 1 per in-game day.",
            category = "tools",
            itemLimit = 1, -- Limit the number that can be purchased at once
        },
        
        -- Add additional mining tools here as needed
        {
            itemLabel = "Mining Lantern",
            itemName = "lantern",
            currencyType = "cash",
            buyprice = 15,
            randomprice = math.random(12, 18),
            desc = "A lantern to light your way in dark mining tunnels.",
            category = "tools",
            itemLimit = 3,
        }
    },
    MountHagenStore = {
        -- Tools Category
        {
            itemLabel = "Pickaxe",
            itemName = "pickaxe",
            currencyType = "cash",
            buyprice = 35,
            randomprice = math.random(40, 50),
            desc = "A sturdy pickaxe for mining ore deposits.\nLimit: 1 per in-game day.",
            category = "tools",
            itemLimit = 1, -- Limit the number that can be purchased at once
        },
        
        -- Add additional mining tools here as needed
        {
            itemLabel = "Mining Lantern",
            itemName = "lantern",
            currencyType = "cash",
            buyprice = 10,
            randomprice = math.random(12, 18),
            desc = "A lantern to light your way in dark mining tunnels. But ofc you don't need here.",
            category = "tools",
            itemLimit = 3,
        }
    },
} 