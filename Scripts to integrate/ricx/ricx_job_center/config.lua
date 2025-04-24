Config = {}

Config.framework = "redemrp" --"redemrp" or "redemrp-reboot" or "vorp" or "qbr" or "qbr2" or "rsg"
Config.MenuPos = "right"
Config.Prompts = {
    PromptOpen = 0x05CA7C52,
}

Config.MaxJobsPerPlayer = 3

Config.Marker = {
    rgba = {126, 0, 0, 100},
    size = {2.0, 2.0, 0.3},
}

Config.JobCooldown = 24--hours CD after accepting a job or leaving one. After CD player can get a new job or leave an another one
Config.UnemployedJobVariable = "unemployed"

Config.Texts = {
    PromptOpen = "Open",
    --TEXTS
    JobCenter = "Job Center",
    CantDo = "You cant do that! Cooldown is not ended!",
    HaveJobAlready = "You have this job already!",
    NoMoreJob = "You cant get more jobs!",
    NoJobs = "You dont have any job!",
    GotNewJob = "You got a new job!",
    LeftJob = "You left the job!",
    JobChanged = "Your main job changed!",
    MainSame = "You have this main job already!",
    CantLeaveMain = "You cant leave your main job!",
    --
    AvailableJobs = "Available Jobs",
    BrowseJobs = "Browse Jobs",
    MyJobs = "My Jobs",
    EditJobs = "Edit your Jobs",
    Options = "Options",
    SetNoMain = "Set no Main Job",
    YourJobs = "Your Jobs",
    SetMain = "Set as Main Job",
    SetMainD = "This will be your main job!",
    LeaveJob = "Leave Job",
    LeaveJobD =  "Leave the job!",
    GoUnemployed = "Go Unemployed",
}

Config.Textures = {
    cross = {"scoretimer_textures", "scoretimer_generic_cross"},
    locked = {"menu_textures","stamp_locked_rank"},
    tick = {"scoretimer_textures","scoretimer_generic_tick"},
    money = {"inventory_items", "money_moneystack"},
    alert = {"menu_textures", "menu_icon_alert"},
}

Config.JobCenters = {
    [1] = {
        name = "Job Center: Valentine",
        blip = {enable = true, sprite = 1173759417},
        coords = vector3(-241.779, 750.213, 116.776),
        jobs = {"farmer", "dog_breeder", "collector","gun_dealer"},--available jobs at job Center from Config.Jobs array
    },
    [2] = {
        name = "Job Center: Saint Denis",
        blip = {enable = true, sprite = 1173759417},
        coords = vector3(2531.451, -1218.678, 52.681),
        jobs = {"police",},--available jobs at job Center from Config.Jobs array
    },
}



Config.Jobs = {
    --MAKE SURE TO ADD HERE ALL YOUR AVAILABLE JOBS! IF YOU WANT THE JOB AVAILABLE AT CENTERS, CHECK THE Config.JobCenters FOR EXAMPLES
    ["police"] = {id_name = "police", label = "Police", desc = "Example DESC:<br>Keep the peace!"},
    ["farmer"] = {id_name = "farmer", label = "Farmer", desc = "Example DESC:<br>Farmer will have more option with<br>plants and animals.<br>Plant seeds or take care of chickens."},--for new line add <br> like in the example
    ["dog_breeder"] = {id_name = "dog_breeder", label = "Dog Breeder", desc = "Example DESC:<br>Dog Breeder can buy dogs at dog shops.<br>Train the dogs and sell them to others"},
    ["collector"] =  {id_name = "collector", label = "Collector", desc = "Example DESC:<br>Collectors can find and sell different items.<br>Collect Animal Notes, Dino Bone Photos<br>or other valuables"},
    ["gun_dealer"] = {id_name = "gun_dealer", label = "Gun Dealer", desc = "Example DESC:<br>Gun dealers can interact with gun stores<br>to customize weapons.<br>Find buyers for the customized weapons"},
}