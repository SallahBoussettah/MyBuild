Config = {}

Config.JobRequirement = {
    enable = false,
    jobs = {"job1", "job2"},
}

Config.JimmyShop = {
    {"water", "Water", 10},--itemname, label, price
}

Config.MissionOptions = {
    ["MenuMissionLabel"] = "Missions",
    ["MenuMissionDesc"] = "Kill the enemies of Jimmy",
    ["MenuShopLabel"] = "Shop",
    ["MenuShopDesc"] = "Buy items from Jimmy",
    ["NoMoreQuests"] = "There are no more Quests at Jimmy!",
    ["KillQuestInfo"] = "~o~~h~Go to the destination and kill the enemy!",
    ["TargetMapName"] = "Target",
    ["QuestMenuTitle"] = "Bloody Jimmy's Missions",
    ["TalkText"] =  "- Talk ",
    ["TalkControl"] = 0xD8F73058,
    ["TalkControlName"] = "[U]",
    ["FinishText"] = "Identify and finish Mission ",
    ["FinishControl"] = 0xD8F73058,
    ["FinishControlName"] = "[U]",
    ["StartText"] = "Start Mission ",
    ["StartControl"] = 0xD8F73058,
    ["StartControlName"] = "[U]",
    ["FailTimerAfterDeath"] = 10, --seconds
    ["MissionBlipId"] = -984192463,
    ["MissionBlipName"] = "Mission",
    ["FinishMoreQuests"] = "You have to finish more Quests to open Shop",
    ["JimmyShop"] = "Jimmy Shop",
    ["Options"] = "Options",
    ["NoMoney"] = "You dont have enough money!",
    ["NoJob"] = "You dont have the required job!",
}

Config.Npc = {
	[1] = {--questtype
		["Name"] = "Bloody Jimmy",
		["Model"] = `cs_nbxexecuted`,
        ["Preset"] = 0,
		["Pos"] = vector3(-240.49, 774.31, 117.09),
		["Heading"] = 108.91,
        ["AnimDict"] = "amb_rest_lean@world_human_lean@wall@right@male_b@idle_a",
        ["AnimName"] = "idle_c",
        ["Quests"] = {
            [1] = {
                ["Type"] = "kill",
                ["Name"] = "1. Mission",
                ["Desc"] = "Kill the enemy of Jimmy",
                ["Reward"] = 50,
                ["XP"] = 15,
                ["Success"] = "You killed the enemy! Reward: $$",
                ["Fail"] = "The enemy ran away! Go to Jimmy again!",
                ["TargetPos"] = vector3(-594.2, 511.84, 95.54),
                ["Guard"] = false,
                ["Targets"] =  {
                    [1] = {
                        ["Name"] = "Enemy",
                        ["Model"] = `a_m_m_unicorpse_01`,
                        ["Preset"] = 5,
                        ["Pos"] = vector3(-616.317, 531.128, 97.514),
                        ["Heading"] = 264.65,
                        ["Weapon"] = `weapon_pistol_m1899`,
                        ["Ammo"] = 100,
                        ["Combat"] = "defensive"
                    }
                }
            },
            [2] = {
                ["Type"] = "kill",
                ["Name"] = "2. Mission",
                ["Desc"] = "Kill the enemy of Jimmy",
                ["Reward"] = 70,
                ["XP"] = 30,
                ["Success"] = "You killed the enemy! Reward: $",
                ["Fail"] = "The enemy ran away! Go to Jimmy again!",
                ["TargetPos"] = vector3(-1838.73, 1310.44, 220.8),
                ["Guard"] = true,
                ["Guards"] = {
                    [1] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 0,
                        ["Pos"] = vector3(-1869.9, 1357.58, 203.76),
                        ["Heading"] = 209.0,
                        ["Weapon"] = `weapon_repeater_carbine`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [2] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 9,
                        ["Pos"] = vector3(-1881.4, 1358.33, 202.39),
                        ["Heading"] = 220.0,
                        ["Weapon"] = `weapon_revolver_cattleman`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [3] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 12,
                        ["Pos"] = vector3(-1899.57, 1338.66, 200.69),
                        ["Heading"] = 220.0,
                        ["Weapon"] = `weapon_revolver_cattleman`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [4] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 17,
                        ["Pos"] = vector3(-1903.7, 1326.57, 199.57),
                        ["Heading"] = 220.0,
                        ["Weapon"] = `weapon_revolver_doubleaction`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [5] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 24,
                        ["Pos"] = vector3(-1886.94, 1331.18, 200.26),
                        ["Heading"] = 282.0,
                        ["Weapon"] = `weapon_shotgun_pump`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    }
                },
                ["Targets"] =  {
                    [1] = {
                        ["Name"] = "The ENEMY",
                        ["Model"] = `u_m_m_bht_odriscollsleeping`,
                        ["Preset"] = 0,
                        ["Pos"] = vector3(-1879.45, 1330.31, 202.25),
                        ["Heading"] = 200.0,
                        ["Weapon"] = `weapon_shotgun_pump`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    }
                }
            },
            [3] = {--burned down town south valentine
                ["Type"] = "kill",
                ["Name"] = "3. Berry Green",
                ["Desc"] = "Kill the enemy of Jimmy",
                ["Reward"] = 100,
                ["XP"] = 30,
                ["Success"] = "You killed the enemy! Reward: $",
                ["Fail"] = "The enemy ran away! Go to Jimmy again!",
                ["TargetPos"] = vector3(-345.23, -114.62, 46.43),
                ["Guard"] = true,
                ["Guards"] = {
                    [1] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 2,
                        ["Pos"] = vector3(-330.39, -153.03, 51.08),
                        ["Heading"] = 44.18,
                        ["Weapon"] = `weapon_shotgun_repeating`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [2] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 3,
                        ["Pos"] = vector3(-345.0, -153.08, 50.65),
                        ["Heading"] = 17.13,
                        ["Weapon"] = `weapon_shotgun_repeating`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [3] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 5,
                        ["Pos"] = vector3(-316.95, -135.77, 51.47),
                        ["Heading"] = 70.25,
                        ["Weapon"] = `weapon_repeater_winchester`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [4] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 6,
                        ["Pos"] = vector3(-369.27, -117.5, 46.95),
                        ["Heading"] = 248.84,
                        ["Weapon"] = `weapon_repeater_winchester`,
                        ["Ammo"] = 10,
                        ["Combat"] = "defensive"
                    },
                    [5] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 7,
                        ["Pos"] = vector3(-366.1, -157.04, 51.13),
                        ["Heading"] = 299.63,
                        ["Weapon"] = `weapon_pistol_m1899`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    }
                },
                ["Targets"] =  {
                    [1] = {
                        ["Name"] = "Berry Green",
                        ["Model"] = `cs_brynntildon`,
                        ["Preset"] = 0,
                        ["Pos"] = vector3(-327.33, -150.24, 51.08),
                        ["Heading"] = 36.25,
                        ["Weapon"] = `weapon_pistol_m1899`,
                        ["Ammo"] = 10,
                        ["Combat"] = "defensive"
                    }
                }
            },
            [4] = {--Oil Fields
                ["Type"] = "kill",
                ["Name"] = "4. Mission",
                ["Desc"] = "Kill the enemy of Jimmy",
                ["Reward"] = 100,
                ["XP"] = 30,
                ["Success"] = "You killed the enemy! Reward: $",
                ["Fail"] = "The enemy ran away! Go to Jimmy again!",
                ["TargetPos"] = vector3(610.22, 585.86, 109.93),
                ["Guard"] = true,
                ["Guards"] = {
                    [1] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `a_m_m_bivworker_01`,
                        ["Preset"] = 0,
                        ["Pos"] = vector3(595.15, 567.91, 110.9),
                        ["Heading"] = 249.75,
                        ["Weapon"] = `weapon_melee_hatchet`,
                        ["Ammo"] = 1,
                        ["Combat"] = "offensive"
                    },
                    [2] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `a_m_m_bivworker_01`,
                        ["Preset"] = 2,
                        ["Pos"] = vector3(598.3, 566.51, 111.2),
                        ["Heading"] = 80.99,
                        ["Weapon"] = `weapon_melee_machete`,
                        ["Ammo"] = 1,
                        ["Combat"] = "offensive"
                    },
                    [3] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `a_m_m_bivworker_01`,
                        ["Preset"] = 6,
                        ["Pos"] = vector3(591.77, 562.68, 111.01),
                        ["Heading"] = 207.74,
                        ["Weapon"] = `weapon_melee_machete`,
                        ["Ammo"] = 1,
                        ["Combat"] = "offensive"
                    },
                    [4] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `a_m_m_bivworker_01`,
                        ["Preset"] = 7,
                        ["Pos"] = vector3(584.16, 557.86, 110.77),
                        ["Heading"] = 202.51,
                        ["Weapon"] = `weapon_shotgun_sawedoff`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    }
                },
                ["Targets"] =  {
                    [1] = {
                        ["Name"] = "The ENEMY",
                        ["Model"] = `a_m_m_bivworker_01`,
                        ["Preset"] = 23,
                        ["Pos"] = vector3(584.46, 557.39, 110.76),
                        ["Heading"] = 260.72,
                        ["Weapon"] = `weapon_rifle_boltaction`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    }
                }
            },
            [5] = {--moonstone pond
                ["Type"] = "kill",
                ["Name"] = "5. Mission",
                ["Desc"] = "Kill the enemy of Jimmy",
                ["Reward"] = 120,
                ["XP"] = 30,
                ["Success"] = "You killed the enemy! Reward: $",
                ["Fail"] = "The enemy ran away! Go to Jimmy again!",
                ["TargetPos"] = vector3(1233.8, 1197.33, 149.11),
                ["Guard"] = true,
                ["Guards"] = {
                    [1] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 10,
                        ["Pos"] = vector3(1257.82, 1144.59, 149.46),
                        ["Heading"] = 18.53,
                        ["Weapon"] = `weapon_shotgun_semiauto`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [2] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 11,
                        ["Pos"] = vector3(1251.73, 1151.221, 150.74),
                        ["Heading"] = 293.75,
                        ["Weapon"] = `weapon_shotgun_doublebarrel`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [3] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 14,
                        ["Pos"] = vector3(1246.16, 1141.70, 149.84),
                        ["Heading"] = 26.38,
                        ["Weapon"] = `weapon_repeater_winchester`,
                        ["Ammo"] = 10,
                        ["Combat"] = "offensive"
                    },
                    [4] = {
                        ["Name"] = "Gang member",
                        ["Model"] = `mp_g_m_m_animalpoachers_01`,
                        ["Preset"] = 20,
                        ["Pos"] = vector3(1244.73, 1148.58, 150.5),
                        ["Heading"] = 224.62,
                        ["Weapon"] = `weapon_repeater_winchester`,
                        ["Ammo"] = 10,
                        ["Combat"] = "defensive"
                    }
                },
                ["Targets"] =  {
                    [1] = {
                        ["Name"] = "Spicli",
                        ["Model"] = `g_m_m_unimicahgoons_01`,
                        ["Preset"] = 10,
                        ["Pos"] = vector3(1241.48, 1148.46, 150.21),
                        ["Heading"] = 183.33,
                        ["Weapon"] = `weapon_rifle_boltaction`,
                        ["Ammo"] = 10,
                        ["Combat"] = "defensive"
                    }
                }
            },
            [6] = {--hobbit house
            ["Type"] = "kill",
            ["Name"] = "6. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 130,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(779.98, 1847.71, 243.22),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimicahgoons_01`,
                    ["Preset"] = 29,
                    ["Pos"] = vector3(740.51, 1822.19, 237.15),
                    ["Heading"] = 247.12,
                    ["Weapon"] = `weapon_shotgun_pump`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                }
            },
                ["Targets"] =  {
                    [1] = {
                        ["Name"] = "The Enemy",
                        ["Model"] = `g_m_m_unimicahgoons_01`,
                        ["Preset"] = 28,
                        ["Pos"] = vector3(740.71, 1819.51, 237.13),
                        ["Heading"] = 344.5,
                        ["Weapon"] = `weapon_revolver_doubleaction`,
                        ["Ammo"] = 10,
                        ["Combat"] = "defensive"
                    }
                }
            },
            [7] = {--wapiti
            ["Type"] = "kill",
            ["Name"] = "7. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 50,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(276.85, 2053.87, 228.73),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 1,
                    ["Pos"] = vector3(252.35, 2080.19, 239.73),
                    ["Heading"] = 44.07,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [2] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 2,
                    ["Pos"] = vector3(246.48, 2083.38, 239.99),
                    ["Heading"] = 218.27,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [3] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 3,
                    ["Pos"] = vector3(233.73, 2096.26, 245.19),
                    ["Heading"] = 307.59,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 4,
                    ["Pos"] = vector3(225.67, 2102.1, 248.81),
                    ["Heading"] = 184.9,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [5] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 5,
                    ["Pos"] = vector3(222.37, 2097.27, 248.31),
                    ["Heading"] = 132.36,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [6] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 6,
                    ["Pos"] = vector3(226.85, 2120.17, 255.92),
                    ["Heading"] = 180.89,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [7] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 7,
                    ["Pos"] = vector3(233.3, 2140.0, 265.43),
                    ["Heading"] = 291.28,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [8] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 8,
                    ["Pos"] = vector3(244.72, 2138.3, 263.65),
                    ["Heading"] = 171.5,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "Flying Bull",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 15,
                    ["Pos"] = vector3(221.3, 2123.7, 257.05),
                    ["Heading"] = 181.78,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            }
        },
        [8] = {--fort north valentine
            ["Type"] = "kill",
            ["Name"] = "8. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] =  200,
            ["XP"] = 50,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(383.4, 1463.89, 177.87),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 8,
                    ["Pos"] = vector3(360.28, 1471.27, 179.82),
                    ["Heading"] = 147.41,
                    ["Weapon"] = `weapon_rifle_springfield`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [2] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 7,
                    ["Pos"] = vector3(364.88, 1472.99, 184.63),
                    ["Heading"] = 174.81,
                    ["Weapon"] = `weapon_rifle_springfield`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [3] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 6,
                    ["Pos"] = vector3(347.15, 1462.5, 183.72),
                    ["Heading"] = 302.99,
                    ["Weapon"] = `weapon_rifle_springfield`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 5,
                    ["Pos"] = vector3(340.52, 1476.82, 183.59),
                    ["Heading"] = 260.97,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [5] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 4,
                    ["Pos"] = vector3(348.51, 1489.51, 179.55),
                    ["Heading"] = 193.28,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [6] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 3,
                    ["Pos"] = vector3(333.14, 1485.82, 179.58),
                    ["Heading"] = 302.84,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [7] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 2,
                    ["Pos"] = vector3(323.63, 1498.78, 180.85),
                    ["Heading"] = 234.91,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [8] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 1,
                    ["Pos"] = vector3(355.74, 1502.72, 180.08),
                    ["Heading"] = 169.4,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "General",
                    ["Model"] = `s_m_m_army_01`,
                    ["Preset"] = 50,
                    ["Pos"] = vector3(349.37, 1506.47, 180.5),
                    ["Heading"] = 154.77,
                    ["Weapon"] = `weapon_rifle_boltaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            }
        },
        [9] = {--south valentine river
            ["Type"] = "kill",
            ["Name"] = "9. Az ügyfél II.",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(-755.04, -361.49, 40.84),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `MP_FM_BOUNTYTARGET_MALES_DLC008_01`,
                    ["Preset"] = 4,
                    ["Pos"] = vector3(-749.59, -399.21, 41.61),
                    ["Heading"] = 209.6,
                    ["Weapon"] = `weapon_shotgun_pump`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `MP_FM_BOUNTYTARGET_MALES_DLC008_01`,
                    ["Preset"] = 3,
                    ["Pos"] = vector3(-751.71, -406.82, 41.76),
                    ["Heading"] = 156.72,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [3] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `MP_FM_BOUNTYTARGET_MALES_DLC008_01`,
                    ["Preset"] = 2,
                    ["Pos"] = vector3(-733.48, -407.03, 41.63),
                    ["Heading"] = 3.57,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `MP_FM_BOUNTYTARGET_MALES_DLC008_01`,
                    ["Preset"] = 1,
                    ["Pos"] = vector3(-748.61, -417.32, 41.69),
                    ["Heading"] = 357.4,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
                ["Targets"] =  {
                    [1] = {
                        ["Name"] = "The Enemy",
                        ["Model"] = `g_m_m_unimicahgoons_01`,
                        ["Preset"] = 28,
                        ["Pos"] = vector3(-736.0, -438.54, 41.77),
                        ["Heading"] = 13.97,
                        ["Weapon"] = `weapon_revolver_doubleaction`,
                        ["Ammo"] = 10,
                        ["Combat"] = "defensive"
                    }
                }
            },
            [10] = {--heartlands
            ["Type"] = "kill",
            ["Name"] = "10. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(277.62, 147.17, 101.07),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Mexican Bandit",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 162,
                    ["Pos"] = vector3(315.61, 150.01, 114.36),
                    ["Heading"] = 85.07,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Mexican Bandit",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 163,
                    ["Pos"] = vector3(304.46, 135.67, 111.49),
                    ["Heading"] = 152.92,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [3] = {
                    ["Name"] = "Mexican Bandit",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 164,
                    ["Pos"] = vector3(334.64, 150.99, 126.23),
                    ["Heading"] = 136.26,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Mexican Bandit",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 165,
                    ["Pos"] = vector3(343.59, 140.16, 125.31),
                    ["Heading"] = 105.64,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
                ["Targets"] =  {
                    [1] = {
                        ["Name"] = "El Pedro",
                        ["Model"] = `MP_LBM_CARMELA_BANDITOS_01`,
                        ["Preset"] = 1,
                        ["Pos"] = vector3(345.55, 144.78, 123.51),
                        ["Heading"] = 106.31,
                        ["Weapon"] = `weapon_revolver_doubleaction`,
                        ["Ammo"] = 10,
                        ["Combat"] = "defensive"
                    }
                }
            },
            [11] = {-- island west of braithwaith manor
            ["Type"] = "kill",
            ["Name"] = "11. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 250,
            ["XP"] = 60,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(386.69, -1162.66, 41.59),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 62,
                    ["Pos"] = vector3(347.84, -1251.49, 44.61),
                    ["Heading"] = 325.7,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [2] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 63,
                    ["Pos"] = vector3(324.78, -1248.15, 42.67),
                    ["Heading"] = 334.41,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [3] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 64,
                    ["Pos"] = vector3(337.8, -1264.69, 42.96),
                    ["Heading"] = 321.33,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 65,
                    ["Pos"] = vector3(354.96, -1294.04, 43.31),
                    ["Heading"] = 340.56,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [5] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 66,
                    ["Pos"] = vector3(380.52, -1272.3, 41.9),
                    ["Heading"] = 346.5,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [6] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 67,
                    ["Pos"] = vector3(438.68, -1248.47, 45.09),
                    ["Heading"] = 14.67,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [7] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 68,
                    ["Pos"] = vector3(427.55, -1206.8, 44.91),
                    ["Heading"] = 34.69,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [8] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 69,
                    ["Pos"] = vector3(403.22, -1197.54, 44.77),
                    ["Heading"] = 36.93,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "Red Moon",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 16,
                    ["Pos"] = vector3(396.45, -1267.12, 41.91),
                    ["Heading"] = 18.79,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            }
        },
        [12] = {--rhodes south
            ["Type"] = "kill",
            ["Name"] = "12. Mission.",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(702.87, -1185.53, 46.86),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `mp_g_m_m_animalpoachers_01`,
                    ["Preset"] = 30,
                    ["Pos"] = vector3(703.8, -1160.63, 48.79),
                    ["Heading"] = 229.21,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [2] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `mp_g_m_m_animalpoachers_01`,
                    ["Preset"] = 31,
                    ["Pos"] = vector3(699.76, -1127.45, 51.19),
                    ["Heading"] = 197.08,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [3] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `mp_g_m_m_animalpoachers_01`,
                    ["Preset"] = 32,
                    ["Pos"] = vector3(726.32, -1121.64, 57.54),
                    ["Heading"] = 154.64,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `mp_g_m_m_animalpoachers_01`,
                    ["Preset"] = 33,
                    ["Pos"] = vector3( 749.6, -1131.33, 56.39),
                    ["Heading"] = 142.47,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [5] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `mp_g_m_m_animalpoachers_01`,
                    ["Preset"] = 34,
                    ["Pos"] = vector3(758.71, -1098.28, 56.88),
                    ["Heading"] = 110.38,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [5] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `mp_g_m_m_animalpoachers_01`,
                    ["Preset"] = 35,
                    ["Pos"] = vector3(672.65, -1098.91, 51.92),
                    ["Heading"] = 204.32,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "The Leader",
                    ["Model"] = `mp_u_m_m_animalpoacher_01`,
                    ["Preset"] = 1,
                    ["Pos"] = vector3(720.96, -1087.3, 56.89),
                    ["Heading"] = 166.0,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            }
        },
        [13] = {--lemonye village with burned down church
            ["Type"] = "kill",
            ["Name"] = "13. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 150,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(1700.408, -405.293, 49.011),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Cultist",
                    ["Model"] = `RE_RALLYDISPUTE_MALES_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(1752.0024414062, -413.591, 48.048),
                    ["Heading"] = 155.432,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [2] = {
                    ["Name"] = "Cultist",
                    ["Model"] = `RE_RALLYDISPUTE_MALES_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(1772.9777832031, -399.45, 47.291),
                    ["Heading"] = 95.323,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [3] = {
                    ["Name"] = "Cultist",
                    ["Model"] = `RE_RALLYDISPUTE_MALES_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3( 1782.4006347656, -408.969, 46.860),
                    ["Heading"] = 70.104,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Cultist",
                    ["Model"] = `RE_RALLYDISPUTE_MALES_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(1791.7747802734, -413.251, 45.769),
                    ["Heading"] =  96.654,
                    ["Weapon"] = `WEAPON_MELEE_KNIFE`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "The Cultist Boss",
                    ["Model"] = `RE_RALLYDISPUTE_MALES_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(1792.7940673828, -396.904, 46.116),
                    ["Heading"] =  63.637,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            }
        },
        [14] = {--Hillbilly Camp
            ["Type"] = "kill",
            ["Name"] = "14. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(2496.861, 733.851, 74.03),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Hillbilly",
                    ["Model"] = `a_m_m_btchillbilly_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(2536.474, 763.161, 75.0411),
                    ["Heading"] = 127.821,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [2] = {
                    ["Name"] = "Hillbilly",
                    ["Model"] = `a_m_m_btchillbilly_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(2528.837, 749.990, 75.011),
                    ["Heading"] = 126.195,
                    ["Weapon"] = `WEAPON_MELEE_KNIFE`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Hillbilly",
                    ["Model"] = `a_m_m_btchillbilly_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(2548.520, 780.407, 75.48),
                    ["Heading"] = 120.778,
                    ["Weapon"] = `WEAPON_MELEE_KNIFE`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [4] = {
                    ["Name"] = "Hillbilly",
                    ["Model"] = `a_m_m_btchillbilly_01`,
                    ["Preset"] = 6,
                    ["Pos"] = vector3(2556.87, 794.679, 76.169),
                    ["Heading"] = 117.395,
                    ["Weapon"] = `WEAPON_MELEE_KNIFE`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [5] = {
                    ["Name"] = "Hillbilly",
                    ["Model"] = `a_m_m_btchillbilly_01`,
                    ["Preset"] = 7,
                    ["Pos"] = vector3(2544.943, 814.254, 75.803),
                    ["Heading"] = 156.0281,
                    ["Weapon"] = `WEAPON_MELEE_KNIFE`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [6] = {
                    ["Name"] = "Hillbilly",
                    ["Model"] = `a_m_m_btchillbilly_01`,
                    ["Preset"] = 8,
                    ["Pos"] = vector3(2556.664, 824.187, 76.2937),
                    ["Heading"] = 135.22,
                    ["Weapon"] = `WEAPON_MELEE_KNIFE`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "The Infection",
                    ["Model"] = `a_m_m_btchillbilly_01`,
                    ["Preset"] = 39,
                    ["Pos"] = vector3(2544.739, 820.974, 75.645),
                    ["Heading"] =  153.134,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
        },
        [15] = {-- Fort near Van Horn
            ["Type"] = "kill",
            ["Name"] = "15. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(2460.860, 309.429, 71.498),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_y_army_01`,
                    ["Preset"] = 10,
                    ["Pos"] = vector3(2444.258, 291.186, 70.347),
                    ["Heading"] = 286.752,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_y_army_01`,
                    ["Preset"] = 10,
                    ["Pos"] = vector3(2462.983, 278.173, 75.432),
                    ["Heading"] = 319.730,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_y_army_01`,
                    ["Preset"] = 10,
                    ["Pos"] = vector3(2442.020, 278.361, 76.565),
                    ["Heading"] = 243.958,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [4] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_y_army_01`,
                    ["Preset"] = 10,
                    ["Pos"] = vector3(2464.619, 293.387, 74.732),
                    ["Heading"] = 6.893,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [5] = {
                    ["Name"] = "Soldier",
                    ["Model"] = `s_m_y_army_01`,
                    ["Preset"] = 10,
                    ["Pos"] = vector3(2456.610, 274.099, 71.0831),
                    ["Heading"] = 342.579,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "The General",
                    ["Model"] = `s_m_y_army_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(2446.108, 288.838, 67.333),
                    ["Heading"] =  7.4958,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
        },
        [16] = {-- Caliga Hall
            ["Type"] = "kill",
            ["Name"] = "16. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(1852.46, -1226.621, 42.429),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Worker",
                    ["Model"] = `a_m_m_vhtboatcrew_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(1850.077, -1251.51, 43.212),
                    ["Heading"] = 321.00,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Worker",
                    ["Model"] = `a_m_m_vhtboatcrew_01`,
                    ["Preset"] = 1,
                    ["Pos"] = vector3(1859.762, -1275.018, 43.118),
                    ["Heading"] =  4.354,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Worker",
                    ["Model"] = `a_m_m_vhtboatcrew_01`,
                    ["Preset"] = 2,
                    ["Pos"] = vector3(1861.756, -1291.680, 42.910),
                    ["Heading"] = 351.614,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [4] = {
                    ["Name"] = "Worker",
                    ["Model"] = `a_m_m_vhtboatcrew_01`,
                    ["Preset"] = 3,
                    ["Pos"] = vector3(1830.588, -1293.360, 42.641),
                    ["Heading"] = 317.590,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [5] = {
                    ["Name"] = "Worker",
                    ["Model"] = `a_m_m_vhtboatcrew_01`,
                    ["Preset"] = 4,
                    ["Pos"] = vector3(1828.026, -1282.000, 43.207),
                    ["Heading"] = 355.875,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "Mr. Caliga",
                    ["Model"] = `cs_clive`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(1824.0432, -1310.457, 42.855),
                    ["Heading"] =  252.062,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
        },
        [17] = {-- Swamp 
            ["Type"] = "kill",
            ["Name"] = "17. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(2205.937, -547.587, 40.220),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Swamp Bandit",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(2236.661, -553.750, 41.575),
                    ["Heading"] = 66.49,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Swamp Bandit",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 1,
                    ["Pos"] = vector3(2247.534, -535.561, 42.181),
                    ["Heading"] = 84.078,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Swamp Bandit",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 2,
                    ["Pos"] = vector3(2245.716, -566.301, 40.945),
                    ["Heading"] = 47.071,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Swamp Bandit",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 3,
                    ["Pos"] = vector3(2277.002, -537.066, 41.604),
                    ["Heading"] = 92.084,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [5] = {
                    ["Name"] = "Swamp Bandit",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 4,
                    ["Pos"] = vector3(2285.833, -538.020, 41.06),
                    ["Heading"] = 70.0,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [6] = {
                    ["Name"] = "Swamp Bandit",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 5,
                    ["Pos"] = vector3(2274.065, -575.223, 41.72),
                    ["Heading"] = 67.5,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [7] = {
                    ["Name"] = "Swamp Bandit",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 6,
                    ["Pos"] = vector3(2267.174, -580.971, 41.08),
                    ["Heading"] = 25.875,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [8] = {
                    ["Name"] = "Swamp Bandit",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 7,
                    ["Pos"] = vector3(2305.0166, -562.396, 41.178),
                    ["Heading"] = 79.833,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "Swamp Monster",
                    ["Model"] = `mp_g_m_m_uniswamp_01`,
                    ["Preset"] = 28,
                    ["Pos"] = vector3(2292.508, -542.266, 41.057),
                    ["Heading"] =  107.82,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                }
            },
        },
        [18] = {-- Mount Hagen
            ["Type"] = "kill",
            ["Name"] = "18. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(-1385.295, 1156.934, 224.067),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(-1390.436, 1142.898, 219.234),
                    ["Heading"] = 41.590,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 1,
                    ["Pos"] = vector3(-1404.934, 1138.804, 224.667),
                    ["Heading"] = 310.528,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 2,
                    ["Pos"] = vector3(-1403.779, 1129.481, 227.781),
                    ["Heading"] = 335.126,
                    ["Weapon"] = `weapon_shotgun_pump`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [4] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 3,
                    ["Pos"] = vector3(-1415.426, 1133.497, 225.545),
                    ["Heading"] = 320.860,
                    ["Weapon"] = `weapon_shotgun_pump`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [5] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 4,
                    ["Pos"] = vector3(-1416.234, 1169.50, 226.501),
                    ["Heading"] = 225.647,
                    ["Weapon"] = `weapon_shotgun_pump`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [6] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 5,
                    ["Pos"] = vector3(-1423.318, 1171.448, 226.306),
                    ["Heading"] = 230.293,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [7] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 6,
                    ["Pos"] = vector3(-1440.850, 1188.158, 226.365),
                    ["Heading"] = 228.163,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "Highlander",
                    ["Model"] = `mp_u_m_m_legendarybounty_002`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(-1443.201, 1205.45, 226.327),
                    ["Heading"] =  156.38163757324,
                    ["Weapon"] = `weapon_rifle_boltaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
        },
        [19] = {-- Eastern Caves
            ["Type"] = "kill",
            ["Name"] = "19. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 250,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(-2365.778, 122.588, 215.777),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 7,
                    ["Pos"] = vector3(-2370.011, 115.318, 216.721),
                    ["Heading"] = 273.568,
                    ["Weapon"] = `weapon_repeater_carbine`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 8,
                    ["Pos"] = vector3(-2358.018, 112.766, 216.959),
                    ["Heading"] = 99.500755310059,
                    ["Weapon"] = `weapon_repeater_carbine`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 9,
                    ["Pos"] = vector3(-2351.097, 112.272, 217.685),
                    ["Heading"] =  77.566,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [4] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 10,
                    ["Pos"] = vector3(-2339.712, 105.325, 222.475),
                    ["Heading"] = 63.584,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [5] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 11,
                    ["Pos"] = vector3(-2331.277, 101.476, 222.222),
                    ["Heading"] = 66.757,
                    ["Weapon"] = `weapon_shotgun_repeating`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [6] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 12,
                    ["Pos"] = vector3(-2327.231, 89.622, 220.755),
                    ["Heading"] =  332.551,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [7] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 13,
                    ["Pos"] = vector3(-2305.513, 75.739, 230.382),
                    ["Heading"] = 43.867,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [8] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 14,
                    ["Pos"] = vector3(-2298.435, 81.525, 231.904),
                    ["Heading"] =  69.536,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [9] = {
                    ["Name"] = "Mercenary",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 15,
                    ["Pos"] = vector3(343.828, 62.546, 214.154),
                    ["Heading"] = 330.015,
                    ["Weapon"] = `weapon_repeater_winchester`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "The Leader",
                    ["Model"] = `mp_u_m_m_dyingpoacher_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(-2320.291, 75.215, 222.666),
                    ["Heading"] =  353.928,
                    ["Weapon"] = `weapon_shotgun_repeating`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
        },
        [20] = {--South Strawberry
            ["Type"] = "kill",
            ["Name"] = "20. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 250,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(-1470.556, -770.062, 103.682),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 16,
                    ["Pos"] = vector3(-1483.159, -759.253, 104.615),
                    ["Heading"] = 183.227,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 17,
                    ["Pos"] = vector3(-1505.776, -753.089, 105.938),
                    ["Heading"] = 212.874,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 18,
                    ["Pos"] = vector3(-1524.501, -759.396, 110.307),
                    ["Heading"] = 196.902,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [4] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 19,
                    ["Pos"] = vector3(-1531.015, -771.602, 107.825),
                    ["Heading"] = 259.520,
                    ["Weapon"] = `weapon_rifle_boltaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [5] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 20,
                    ["Pos"] = vector3(-1528.397, -791.294, 105.508),
                    ["Heading"] = 288.0111,
                    ["Weapon"] = `weapon_rifle_boltaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [6] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 21,
                    ["Pos"] = vector3(-1512.8033, -793.335, 103.001),
                    ["Heading"] = 301.2477,
                    ["Weapon"] = `weapon_rifle_boltaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [7] = {
                    ["Name"] = "Gang member",
                    ["Model"] = `g_m_m_unimountainmen_01`,
                    ["Preset"] = 22,
                    ["Pos"] = vector3(-1509.900, -813.904, 105.646),
                    ["Heading"] = 308.220,
                    ["Weapon"] = `weapon_repeater_henry`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "The Money Man",
                    ["Model"] = `a_m_m_rhdobesemen_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(-1505.455, -833.172, 103.490),
                    ["Heading"] =  319.005,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
        },
        
        [21] = {--Indian cemetery
            ["Type"] = "kill",
            ["Name"] = "21. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 300,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(-1529.305, -926.8635, 85.735),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 40,
                    ["Pos"] = vector3(-1574.743, -924.269, 84.618),
                    ["Heading"] = 269.4411,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 41,
                    ["Pos"] = vector3(-1583.013, -923.595, 84.788),
                    ["Heading"] = 206.277,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 42,
                    ["Pos"] = vector3(-1594.305, -921.340, 84.707),
                    ["Heading"] = 237.394,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [4] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 43,
                    ["Pos"] = vector3(-1581.711, -894.613, 85.048),
                    ["Heading"] = 220.720,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [5] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 44,
                    ["Pos"] = vector3(-1603.110, -908.321, 87.401),
                    ["Heading"] = 189.467,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [6] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 45,
                    ["Pos"] = vector3(-1611.159, -890.541, 88.907),
                    ["Heading"] = 265.472,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [7] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 46,
                    ["Pos"] = vector3(-1595.573, -872.973, 86.684),
                    ["Heading"] = 272.156,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [8] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 47,
                    ["Pos"] = vector3(-1576.145, -872.721, 86.962),
                    ["Heading"] = 229.738,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [9] = {
                    ["Name"] = "Indian",
                    ["Model"] = `a_m_m_wapwarriors_01`,
                    ["Preset"] = 48,
                    ["Pos"] = vector3(-1626.188, -873.901, 89.521),
                    ["Heading"] = 253.337,
                    ["Weapon"] = `weapon_bow`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "Smoking Bear",
                    ["Model"] = `mp_u_m_m_legendarybounty_004`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(-1627.598, -878.606, 89.969),
                    ["Heading"] =  284.416,
                    ["Weapon"] = `weapon_rifle_springfield`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
        },
        [22] = {-- Mexican Bandit in river near Blackwater
            ["Type"] = "kill",
            ["Name"] = "22. Mission",
            ["Desc"] = "Kill the enemy of Jimmy",
            ["Reward"] = 200,
            ["XP"] = 40,
            ["Success"] = "You killed the enemy! Reward: $",
            ["Fail"] = "The enemy ran away! Go to Jimmy again!",
            ["TargetPos"] = vector3(-929.0812, -896.180, 40.866),
            ["Guard"] = true,
            ["Guards"] = {
                [1] = {
                    ["Name"] = "Banditos",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 0,
                    ["Pos"] = vector3(-901.119, -931.219, 41.479),
                    ["Heading"] = 34.497,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [2] = {
                    ["Name"] = "Banditos",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 1,
                    ["Pos"] = vector3(-937.124, -957.958, 44.554),
                    ["Heading"] = 334.152,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [3] = {
                    ["Name"] = "Banditos",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 2,
                    ["Pos"] = vector3(-922.694, -970.404, 42.877),
                    ["Heading"] = 6.0108995437622,
                    ["Weapon"] = `weapon_shotgun_doublebarrel`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [4] = {
                    ["Name"] = "Banditos",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 3,
                    ["Pos"] = vector3(-923.687, -987.534, 44.532),
                    ["Heading"] = 354.9585,
                    ["Weapon"] = `weapon_repeater_carbine`,
                    ["Ammo"] = 10,
                    ["Combat"] = "offensive"
                },
                [5] = {
                    ["Name"] = "Banditos",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 4,
                    ["Pos"] = vector3(-892.810, -988.202, 41.707),
                    ["Heading"] = 12.450,
                    ["Weapon"] = `weapon_repeater_carbine`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [6] = {
                    ["Name"] = "Banditos",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 5,
                    ["Pos"] = vector3(-875.755, -977.164, 41.525),
                    ["Heading"] = 23.437,
                    ["Weapon"] = `weapon_shotgun_pump`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
                [7] = {
                    ["Name"] = "Banditos",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 6,
                    ["Pos"] = vector3(-863.214, -999.479, 42.494),
                    ["Heading"] = 49.520,
                    ["Weapon"] = `weapon_shotgun_pump`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                },
            },
            ["Targets"] =  {
                [1] = {
                    ["Name"] = "The Mexican Bandit",
                    ["Model"] = `g_m_m_unibanditos_01`,
                    ["Preset"] = 160,
                    ["Pos"] = vector3( -852.894, -1011.677, 43.994),
                    ["Heading"] = 27.718,
                    ["Weapon"] = `weapon_revolver_doubleaction`,
                    ["Ammo"] = 10,
                    ["Combat"] = "defensive"
                }
            },
        },
        }
	},
}