-- Language configurations for mining store
TranslationStores = {}
TranslationStores.Langs = {
    English = {
        -- Store prompt
        openStore = "Press",
        storePrompt = "Open Store",
        
        -- Store menu labels
        storeTitle = "Mining Store",
        sellTo = "Sell to Store",
        buyFrom = "Buy from Store",
        back = "Back",
        exit = "Exit",
        
        -- Store messages
        storeClosed = "The Mining Store is currently closed. It opens at",
        storeOpen = "The Mining Store is open. Welcome!",
        cantCarry = "You cannot carry any more of this item.",
        soldItem = "You sold",
        boughtItem = "You bought",
        forCash = "for",
        ofCash = "dollars",
        
        -- Error messages
        noMoney = "You don't have enough money!",
        noItems = "You don't have any items to sell.",
        limitReached = "The store cannot buy any more of this item.",
        
        -- Pickaxe limit messages
        pickaxeLimitReached = "You can only purchase one pickaxe per in-game day.",
        pickaxeLimitReminder = "Remember: You can only purchase one pickaxe per in-game day.",
    }
} 