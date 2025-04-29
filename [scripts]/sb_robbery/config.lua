Config = {}


Config.Keys = {
    ENTER = 0xC7B5340A, 
}

Config.NPCS = {
    {
        coords = vector4(-1786.1436, -397.5865, 155.6201, 51.1322), -- Npc coordinates
        model = 'A_M_M_UniGunslinger_01', -- Npc model
        outfit = false,
    },
}

-- Timer and zone size
Config.robberyCooldown = 7200000 -- 2 hours in milliseconds
Config.storeRobberyCooldown = 3600000 -- 1 hour in milliseconds for stores
Config.ZoneSize = 2.0 -- 
Config.LockpickTime = 120000 
Config.Policealert = 5000 
Config.DynamitePrice = 1500 


Config.PoliceJobs = {
    'police',
}


Config.MinPolice = 1 -- Minimum police for store robbery

Config.MinBankPolice = 1 


-- Store robbery cash rewards
Config.StoreRewards = {
    {amount = 50, chance = 5},   -- $50 - 5% chance
    {amount = 40, chance = 15},  -- $40 - 10% chance (cumulative 15%)
    {amount = 30, chance = 30},  -- $30 - 15% chance (cumulative 30%)
    {amount = 25, chance = 50},  -- $25 - 20% chance (cumulative 50%)
    {amount = 20, chance = 75},  -- $20 - 25% chance (cumulative 75%)
    {amount = 15, chance = 90},  -- $15 - 15% chance (cumulative 90%)
    {amount = 10, chance = 100}  -- $10 - 10% chance (cumulative 100%)
}


Config.BankItems = {
    { itemName = "diamond", amount = 3 },   
    { itemName = "goldbar", amount = 2 }, 
}


-- Stores that can be robbed
Config.Shops = {
    { coords = vector3(-324.2566, 804.1712, 116.8816), name = "Valentine General Store" },
    { coords = vector3(2825.3081, -1320.1149, 45.7553), name = "Saint Denis General Store"},
    { coords = vector3(-783.8916, -1321.6003, 42.8841), name = "Blackwater General Store"},
    { coords = vector3(-1789.5017, -387.5222, 159.3285), name = "Strawberry General Store" },
    { coords = vector3(-3687.3408, -2622.7187, -14.4311), name = "Armadillo General Store"},
    { coords = vector3(-5486.3012, -2937.5539, -1.3999), name = "Tumbleweed General Store" },
    { coords = vector3(1330.0543, -1293.6337, 76.0214), name = "Rhodes General Store" }
}


Config.startbankheist = vector3(-1786.1436, -397.5865, 155.6201)

Config.Banks = {
    
    -- { coords = vector3(1290.0882, -1312.4019, 76.0399), name = "Rhodes Bank" },
    { coords = vector3(-820.1022, -1273.4377, 43.6513), name = "Blackwater Bank" },
}




Config.selectedLanguage = 'en'


Config.Languages = {
    ['en'] = {
        langCode = 'en',
        rob = 'START ROBBERY',
        bankRobbery = 'Bank Robbery',
        storeRobbery = 'Store Robbery',
        enterPrompt = 'Press [~e~ENTER~q~] to start the robbery',
        talkPrompt = 'Press [~e~ENTER~q~] to talk about the bank robbery',
        acceptPrompt = 'Press [~e~ENTER~q~] to accept',
        robberyInProgress = 'Press [~e~ENTER~q~] to start the robbery',
        storeRobberyPrompt = 'Press [~e~ENTER~q~] to rob this store',
        dynamiteBlowMessage2 = 'You are placing the dynamite.',
        dynamiteBlowMessage = 'The dynamite will explode! Get away! Find cover!',
        robberySuccess = 'You are searching in the vault',
        notifyPolice = 'You received a telegram about a robbery! Hurry up!',
        noDynamite = 'You have no dynamite!',
        notEnoughMoney = 'You don\'t have enough money!',
        Talk1 = 'Are you looking for someone?',
        Talk2 = 'You don\'t seem like a worthless person. I have a job offer for you.',
        Talk3 = 'I have plenty of dynamite. I can sell it to you, and you can blow up the bank vault with it.',
        Talk4 = 'In the end, you will obtain valuable items.',
        notEnoughPolice = 'Not enough police! The robbery cannot be started.',
        noLockpick = 'You don\'t have a lockpick! The robbery cannot be started.',
        notifyPolice2 = 'A notification has been sent to the sheriffs!',
        insufficientMoney = 'You don\'t have enough money!',
        dynamiteGiven = 'Here are the banks you can rob: %s! You got the dynamite. Finish the job.',
        robberyStarted = 'Robbery has started!',
        lootObtained = 'You found something in the vault!',
        cashObtained = 'You stole $%d from the register!',
        storeRobberyStarted = 'You are threatening the store clerk...',
        storeRobberySuccess = 'You successfully robbed the store!',
        notEnoughMoneyLoot = 'You don\'t have enough money, you cannot take the loot!',
        BankrobberyLoot = 'Press [~e~ENTER~q~] to search the vault',
        bankRobberyMessage = 'This bank has been robbed before.',
        storeRobberyMessage = 'This place has been robbed before.',
        bankCooldownMessage = 'The bank will be available to rob again in %d minutes.',
        storeCooldownMessage = 'The store will be available to rob again in %d minutes.',
        bankOnCooldown = 'This bank cannot be robbed for another %s.',
        storeOnCooldown = 'This store cannot be robbed for another %s.',
        hour = 'hour',
        hours = 'hours',
        minute = 'minute',
        minutes = 'minutes',
        ["and"] = 'and'
    }
}