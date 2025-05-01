ConfigMain = {}

--Jail Event for use in other scripts
--TriggerServerEvent('lawmen:JailPlayer', function(id, time, "the location string")
--[[
Jail ID's
Sisika = sk
Blackwater = bw
Armadillo = ar
Tumbleweed = tu
Strawberry = st
Valentine = val
Saint Denis = sd
Annesburg = an
]]
ConfigMain.BossGrade = 6 -- Grade of boss rank, has access to boss options.
ConfigMain.HandcuffHotkeyActive = false
ConfigMain.synsociety = false -- If you use syn_society and want compatability
ConfigMain.CheckHorse = true -- If you want to check horse ID's
Locale = 'en'

PayCheck = false -- If true built in paycheck system will activate. If you use another paycheck system make this false
PaycheckInfo = {
     Waittime = 1, -- minutes to wait before pay
     police = {
          [0] = 14,
          [1] = 16,
          [2] = 18,
          [3] = 20,
          [4] = 22,
          [5] = 24,
          [6] = 26,
     },
     marshal = {
          [0] = 16,
          [1] = 18,
          [2] = 20,
          [3] = 22,
     }
}

BankInfo = {
     banktable = 'bank_users' ,
     moneycolumn = 'money',
     charidcolumn = 'charidentifier',
     banknamecolumn = 'name',
     names ={
          {display = "Valentine", value = 'Valentine'},
          {display = "Blackwater", value = 'Blackwater'},
          {display = "Rhodes", value = 'Rhodes'},
          {display = "StDenis", value = 'StDenis'},
          {display = "Armadillo", value = 'Armadillo'},
     }
}

InventoryOptions = {
     privatestorage = true, -- Gives option in cabinet menu for personal storage
     sharedstorage = true, -- Gives option in cabinet menu for shared job storage
     allstoragessame = true, --All shared storages will be the same at all departments
     id = "lawstorage",
     name = "Law Storage",
     privatelimit = 2500,
     sharedlimit = 2500,
     acceptWeapons = true,
     ignorestacklimit = true,
     whitelistitems = true, -- or ie  {'wool','water','pickaxe'}
     whitelistweapons = false, -- ie {'weapon_revolver_cattleman'}
     usewhitelist = false -- only allow whitelisted items and weapons in
}


OffDutyJobs = {
     'offpolice',
     'offmarshal',
     'offlawmen',
     'offsheriffrhodes',
}

OnDutyJobs = {
     'police',
     'marshal',
     'lawmen',
     'sheriffrhodes',
}

ConfigMain.ondutycommand = "goonduty"         -- Go on duty Command
ConfigMain.offdutycommand = "gooffduty"       --Go off duty Command
ConfigMain.adjustbadgecommand = "adjustbadge" -- Go on duty Command
ConfigMain.openpolicemenu = "pmenu"            -- Open Police Menu Command
ConfigMain.jailcommand = 'jail'               --Command to jail for cops and admins
ConfigMain.unjailcommand = 'unjail'           --Command to unjail for cops and admins
ConfigMain.finecommand = 'fine'               --Command to fine for cops and admins

-- Police Office Blips Configuration
ConfigMain.ShowOfficeBlips = true -- Set to false to disable all office blips
ConfigMain.OfficeBlips = {
    sisika = {
        enabled = true,
        name = "Sisika Penitentiary",
        coords = { x = 3359.64, y = -668.57, z = 45.78 },
        sprite = 1322310532, -- Using the government/law office icon
        scale = 0.1
    },
    blackwater = {
        enabled = true,
        name = "Blackwater Sheriff Office",
        coords = { x = -766.71, y = -1263.08, z = 44.02 },
        sprite = 1322310532,
        scale = 0.1
    },
    valentine = {
        enabled = true,
        name = "Valentine Sheriff Office",
        coords = { x = -273.05, y = 810.97, z = 119.37 },
        sprite = 1322310532,
        scale = 0.1
    },
    armadillo = {
        enabled = true,
        name = "Armadillo Sheriff Office",
        coords = { x = -3619.05, y = -2600.14, z = -13.34 },
        sprite = 1322310532,
        scale = 0.1
    },
    tumbleweed = {
        enabled = true,
        name = "Tumbleweed Sheriff Office",
        coords = { x = -5528.43, y = -2926.27, z = -1.36 },
        sprite = 1322310532,
        scale = 0.1
    },
    strawberry = {
        enabled = true,
        name = "Strawberry Sheriff Office",
        coords = { x = -1812.50, y = -355.99, z = 161.85 },
        sprite = 1322310532,
        scale = 0.1
    },
    rhodes = {
        enabled = true,
        name = "Rhodes Sheriff Office",
        coords = { x = 1356.05, y = -1301.87, z = 77.76 },
        sprite = 1322310532,
        scale = 0.1
    },
    stdenis = {
        enabled = true,
        name = "Saint Denis Police Department",
        coords = { x = 2502.75, y = -1310.78, z = 48.95 },
        sprite = 1322310532,
        scale = 0.1
    },
    annesburg = {
        enabled = true,
        name = "Annesburg Sheriff Office",
        coords = { x = 2901.57, y = 1310.95, z = 44.93 },
        sprite = 1322310532,
        scale = 0.1
    }
}
