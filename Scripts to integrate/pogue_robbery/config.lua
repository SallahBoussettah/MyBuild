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
Config.robberyCooldown = 120000 -- 
Config.ZoneSize = 2.0 -- 
Config.LockpickTime = 120000 
Config.Policealert = 5000 
Config.DynamitePrice = 1500 


Config.PoliceJobs = {
    'offbwsheriff',
    'offvalsheriff',
    'offarmsheriff',
    'offtwsheriff',
    'offstbsheriff',
    'offrhdsheriff',
    'offsdsheriff',
    'offannsheriff',
    'offmarshal',
    'offpinkerton',
    'offpolice',
    'bwsheriff',
    'valsheriff',
    'armheriff',
    'twsheriff',
    'stbsheriff',
    'rhdsheriff',
    'sdsheriff',
    'annsheriff',
    'marshal',
    'pinkerton',
    'police'
}


Config.MinPolice = 1 

Config.MinBankPolice = 1 


Config.StoreItems = {
    { itemName = "goldbar", amount = 1 },  
    { itemName = "diamond", amount = 1 }, 
}


Config.BankItems = {
    { itemName = "diamond", amount = 5 },   
    { itemName = "goldbar", amount = 3 }, 
}



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
    
    { coords = vector3(1290.0882, -1312.4019, 76.0399), name = "Rhodes Bank" },
    { coords = vector3(-820.1022, -1273.4377, 43.6513), name = "Blackwater Bank" },
}




Config.selectedLanguage = 'tr'


Config.Languages = {
    ['tr'] = {
        langCode = 'tr',
        rob = 'SOYGUNA BASLA',
        bankRobbery = 'Banka Soygunu',
        enterPrompt = 'Soygunu baslatmak icin [~e~ENTER~q~] Bas',
        talkPrompt = 'Banka soygunu hakkinda konusmak icin [~e~ENTER~q~] Bas',
        acceptPrompt = 'Kabul etmek icin [~e~ENTER~q~] Bas',
        robberyInProgress = 'Soygunu baslatmak icin [~e~ENTER~q~] Bas',
        dynamiteBlowMessage2 = 'Dinamiti yerlestiriyorsun.',
        dynamiteBlowMessage = 'Dinamit patlayacak! Uzaklas! Saklanacak bir yer bul!',
        robberySuccess = 'Kasada bir seyler ariyorsun',
        notifyPolice = 'Bir soygun olduguna dair telgraf aldiniz! Hizla git! ',
        noDynamite = 'Dinamitin yok!',
        notEnoughMoney = 'Yeterli paran yok!',
        Talk1 = 'Birini mi ariyorsun?',
        Talk2 = 'Bos birine benzemiyorsun. Sana bir is teklifim var.',
        Talk3 = 'Elimde fazlaca dinamit var. Sana satabilirim. sende bu dinamit ile banka kasasi patlatabilirsin.',
        Talk4 = 'Sonunda degerli esyalar elde edeceksin.',
        notEnoughPolice = "Yeterli sayida polis yok! Soygun baslatilamaz.",
        noLockpick = "Uzerinde maymuncuk (lockpick) yok! Soygun baslatilamaz.",
        notifyPolice2 = "Sheriflere bildirim gonderildi!",
        insufficientMoney = "Yeterli paran yok!",
        dynamiteGiven = "Iste soyabilecegin bankalar: %s! Dinamiti aldin. Isi bitir.",
        robberyStarted = "Soygun basladi!",
        lootObtained = "Kasada bir sey buldun!",
        notEnoughMoneyLoot = "Yeterli paran yok, loot alamazsin!",
        BankrobberyLoot = 'Kasayi aramak icin [~e~ENTER~q~] Bas',
        bankRobberyMessage = "Bu banka daha once soyulmus.",
        storeRobberyMessage = "Burasi daha once soyulmus.",
    },
    ['en'] = {
        langCode = 'en',
        rob = 'START ROBBERY',
        bankRobbery = 'Bank Robbery',
        enterPrompt = 'Press [~e~ENTER~q~] to start the robbery',
        talkPrompt = 'Press [~e~ENTER~q~] to talk about the bank robbery',
        acceptPrompt = 'Press [~e~ENTER~q~] to accept',
        robberyInProgress = 'Press [~e~ENTER~q~] to start the robbery',
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
        notEnoughMoneyLoot = 'You don\'t have enough money, you cannot take the loot!',
        BankrobberyLoot = 'Press [~e~ENTER~q~] to search the vault',
        bankRobberyMessage = 'This bank has been robbed before.',
        storeRobberyMessage = 'This place has been robbed before.',        
    }
}