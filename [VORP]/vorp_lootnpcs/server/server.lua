local Core = exports.vorp_core:GetCore()
local T = Translation.Langs[Lang]

RegisterServerEvent('npcloot:give_reward', function(data)
    local _source = source

    if data ~= 1 then -- change this number acording to  your client side  cheaters can see this so do a new number and in client as well on this event they must match
        return print("cheater detected Id:", _source, GetPlayerName(_source), GetPlayerIdentifiers(_source))
    end

    local User = Core.getUser(_source)
    if not User then
        return
    end

    local Character = User.getUsedCharacter

    if Config.canReceiveWeapons then
        local chance = math.random(1, Config.chanceGettingWeapon)
        if chance < Config.receiveWeapon then
            local ammo = { ["nothing"] = 0 }
            local reward1 = Config.weapons
            local chance1 = math.random(1, #reward1)
            local canCarryWeapons = exports.vorp_inventory:canCarryWeapons(_source, 1, nil, Config.weapons[chance1].name)
            if not canCarryWeapons then
                return Core.NotifyRightTip(_source, T.invFullWeapon, 3000)
            end
            exports.vorp_inventory:createWeapon(_source, Config.weapons[chance1].name, ammo, {})
            if Config.useNotifyRight then
                Core.NotifyRightTip(_source, T.youGot .. Config.weapons[chance1].label, 3000)
            else
                Core.NotifyLeft(_source, T.notifytitle, "" .. T.youGot .. "" .. Config.weapons[chance1].label .. "",
                    "BLIPS", "blip_ambient_bounty_target", 3000, "COLOR_GREEN")
            end
        else -- info on finding nothing
            if Config.useNotifyRight then
                Core.NotifyRightTip(_source, T.noWeapon, 3000)
            else
                Core.NotifyLeft(_source, T.notifytitle, "" .. T.noWeapon .. "", "BLIPS", "blip_destroy", 3000,
                    "COLOR_RED")
            end
        end
    end

    if Config.canReceiveMoney then
        local chance1 = math.random(1, Config.chanceGettingMoney)
        if chance1 < Config.receiveMoney then
            local item_type = math.random(1, #Config.money)
            Character.addCurrency(0, Config.money[item_type])
            if Config.useNotifyRight then
                Core.NotifyRightTip(_source, T.youGot .. string.format("%.2f", Config.money[item_type]) .. T
                    .currency, 3000)
            else
                Core.NotifyLeft(_source, T.notifytitle,
                    T.youGot .. string.format("%.2f", Config.money[item_type]) .. T.currency, "BLIPS",
                    "blip_ambient_bounty_target", 3000, "COLOR_GREEN")
            end
        else -- info on finding nothing
            if Config.useNotifyRight then
                Core.NotifyRightTip(_source, T.noMoney, 3000)
            else
                Core.NotifyLeft(_source, T.notifytitle, "" .. T.noMoney .. "", "BLIPS", "blip_destroy", 3000,
                    "COLOR_RED")
            end
        end
    end


    if Config.canReceiveGold then
        local chance2 = math.random(1, Config.chanceGettingGold)
        if chance2 < Config.receiveGold then
            local item_type = math.random(1, #Config.gold)
            Character.addCurrency(1, Config.gold[item_type])
            if Config.useNotifyRight then
                Core.NotifyRightTip(_source,
                    T.youGot .. Config.gold[item_type] .. T.nugget, 3000)
            else
                Core.NotifyLeft(_source, T.notifytitle, T.youGot .. Config.gold[item_type] .. T.nugget, "BLIPS",
                    "blip_ambient_bounty_target", 3000, "COLOR_GREEN")
            end
        else
            if Config.useNotifyRight then
                Core.NotifyRightTip(_source, T.noGold, 3000)
            else
                Core.NotifyLeft(_source, T.notifytitle, "" .. T.noGold .. "", "BLIPS", "blip_destroy", 3000,
                    "COLOR_RED")
            end
        end
    end

    if Config.canReceiveItems then
        local chance3 = math.random(1, Config.chanceGettingItem)
        if chance3 < Config.receiveItem then
            local chance4 = math.random(1, #Config.items)
            local count = 1
            local canCarryInv = exports.vorp_inventory:canCarryItem(_source, Config.items[chance4].name, count)
            if not canCarryInv then
                return print("cant carry")
            end

            exports.vorp_inventory:addItem(_source, Config.items[chance4].name, count)

            if Config.useNotifyRight then
                Core.NotifyRightTip(_source, T.youGot .. Config.items[chance4].label, 3000)
            else
                Core.NotifyLeft(_source, T.notifytitle, T.youGot .. Config.items[chance4].label, "BLIPS",
                    "blip_ambient_bounty_target", 3000, "COLOR_GREEN")
            end
        else
            if Config.useNotifyRight then
                Core.NotifyRightTip(_source, T.noItem, 3000)
            else
                Core.NotifyLeft(_source, T.notifytitle, "" .. T.noItem .. "", "BLIPS", "blip_destroy", 3000,
                    "COLOR_RED")
            end
        end
    end
end)
