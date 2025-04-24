data = {}
local VorpCore
local VorpInv
local QBRItems
local QRCore
local qc
local RSGCore

local ConfigS = Config

if not ConfigS.framework then 
    if GetResourceState('redem') == 'started' then
        ConfigS.framework = "redemrp"
    elseif GetResourceState('redem_roleplay') == 'started' and GetResourceState('redem') ~= 'started' and GetResourceState('vorp_core')  ~= 'started' then
        ConfigS.framework = "redemrp-reboot"
    elseif GetResourceState('vorp_core') == 'started' then
        ConfigS.framework = "vorp"
    elseif GetResourceState('qbr-core') == 'started' then
        ConfigS.framework = "qbr"
    elseif GetResourceState('rsg-core') == 'started' then
        ConfigS.framework = "rsg"
    elseif GetResourceState('qr-core') == 'started' then
        ConfigS.framework = "qbr2"
    end
end

if ConfigS.framework == "redemrp" then
    TriggerEvent("redemrp_inventory:getData",function(call)
        data = call
    end)
elseif ConfigS.framework == "redemrp-reboot" then
    TriggerEvent("redemrp_inventory:getData",function(call)
        data = call
    end)
    RedEM = exports["redem_roleplay"]:RedEM()
elseif ConfigS.framework == "vorp" then 
    TriggerEvent("getCore",function(core)
        VorpCore = core
    end)
    
    VorpInv = exports.vorp_inventory:vorp_inventoryApi()
elseif ConfigS.framework == "qbr" then 
    qc = "qbr-core"
    QBRItems = exports[qc]:GetItems()
elseif ConfigS.framework == "qbr2" then 
    qc = "qr-core"
    QRCore = exports[qc]:GetCoreObject()
elseif ConfigS.framework == "rsg" then 
    qc = "rsg-core"
    RSGCore = exports[qc]:GetCoreObject()
end
--------------------------------------------------------------------------------------------------------------------------------------------
function IsAdmin(src)
    local _source = src
    local a = nil
    local identifier = ""
    if ConfigS.framework == "redemrp" then 
        TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
            identifier = tostring(user.getIdentifier())
            if (user.getGroup() == "admin" or user.getGroup() == "superadmin") then	
                a = true
            else
                a = false
            end
        end) 
        Citizen.Wait(200)
    elseif ConfigS.framework == "redemrp-reboot" then 
        local Player = RedEM.GetPlayer(src)
        identifier = Player.identifier
        if (Player.group == "admin" or Player.group == "superadmin") then	
            a = true
        else
            a = false
        end
    elseif ConfigS.framework == "vorp" then 
        local User = VorpCore.getUser(_source)
        local Character = User.getUsedCharacter
        local group = Character.group
        local group2 = User.group
        identifier = Character.identifier
        if (group == "admin" or group == "superadmin") or (group2 == "admin" or group2 == "superadmin") then	
            a = true
        else
            a = false
        end
    elseif ConfigS.framework == "qbr" or ConfigS.framework == "qbr2" or ConfigS.framework == "rsg" then 
        local User 
        if  ConfigS.framework == "qbr" then
            User = exports[qc]:GetPlayer(src)
        elseif ConfigS.framework == "qbr2" then 
            User = QRCore.Functions.GetPlayer(src)
        elseif ConfigS.framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(src)
        end
        identifier = User.PlayerData.license
        a = false
    end
    if not a then 
        if ConfigS.AdminIdentifiers then 
            if ConfigS.AdminIdentifiers[identifier] then 
                a = true
            end
        end
    end
    return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
function GetRDMPlayer(src)
    local a = nil 
    if ConfigS.framework == "redemrp" then
        TriggerEvent('redemrp:getPlayerFromId', src, function(user)
            if user then 
                local identifier = tostring(user.getIdentifier())
                local charid = tonumber(user.getSessionVar("charid"))
                local pname = user.getName()
                local money = user.getMoney()
                local job = user.getJob()
                local grade = user.getJobgrade()
                a = {identifier = identifier, charid = charid, name = pname, money = money, job = job, grade = grade}
            else
                a = false 
            end
        end)
        Wait(200)
    elseif ConfigS.framework == "redemrp-reboot" then
        local Player = RedEM.GetPlayer(src)
        if Player then 
            local identifier = Player.identifier
            local charid = Player.charid
            local pname = Player.firstname.." "..Player.lastname   
            local money = Player.money
            local job = Player.job   
            local grade = Player.jobgrade
            a = {identifier = identifier, charid = charid, name = pname, money = money, job = job, grade = grade}
        else
            a = false 
        end
    elseif ConfigS.framework == "vorp" then 
        if not VorpCore.getUser(src) then
            a = false
            return a
        end
        local Character = VorpCore.getUser(src).getUsedCharacter
        if not Character.job then 
            a = false
            return a
        end
        local job =  Character.job
        local identifier = Character.identifier
        local charid = Character.charIdentifier
        local fn = Character.firstname
        local ln = Character.lastname
        local name = (fn or Character.charIdentifier).." "..(ln or Character.identifier)
        local pname = name
        local money =  Character.money
        a = {identifier = identifier, charid = charid, name = pname, money = money, job = job, grade = Character.jobGrade}
    elseif ConfigS.framework == "qbr" or ConfigS.framework == "qbr2" or ConfigS.framework == "rsg" then 
        local User 
        if  ConfigS.framework == "qbr" then
            User = exports[qc]:GetPlayer(src)
        elseif ConfigS.framework == "qbr2" then 
            User = QRCore.Functions.GetPlayer(src)
        elseif ConfigS.framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(src)
        end
        if User?.PlayerData?.job?.name then 
            local job =  User.PlayerData.job.name
            local identifier = User.PlayerData.license
            local charid = User.PlayerData.cid
            local pname = User.PlayerData.charinfo.firstname.." "..User.PlayerData.charinfo.lastname
            local money = User.PlayerData.money.cash
            a = {identifier = identifier, charid = charid, name = pname, money = money, job = job, grade = User.PlayerData.job.grade.level}
        else
            a = false
        end
    end
    return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
function GetRDMItem(src, item)
    local itemD = nil 
    if ConfigS.framework == "redemrp" then
        itemD = data.getItem(src, item)
    elseif ConfigS.framework == "redemrp-reboot" then
        itemD = data.getItem(src, item)
    elseif ConfigS.framework == "vorp" then
        itemD = {src, item}
    elseif ConfigS.framework == "qbr" or ConfigS.framework == "qbr2" or ConfigS.framework == "rsg" then 
        itemD = {src, item}
    end
    return itemD
end
--------------------------------------------------------------------------------------------------------------------------------------------
function GetRDMItemCount(item)
    if ConfigS.framework == "redemrp" then
        return item.ItemAmount
    elseif ConfigS.framework == "redemrp-reboot" then
        return item.ItemAmount
    elseif ConfigS.framework == "vorp" then
        return VorpInv.getItemCount(item[1], item[2])
    elseif ConfigS.framework == "qbr" or ConfigS.framework == "qbr2" or ConfigS.framework == "rsg" then 
        local count
        local User 
        if  ConfigS.framework == "qbr" then
            User = exports[qc]:GetPlayer(item[1])
        elseif ConfigS.framework == "rsg" then 
            User = RSGCore.Functions.GetPlayer(item[1])
        else
            User = QRCore.Functions.GetPlayer(item[1])
        end
        local hasItem = User.Functions.GetItemByName(item[2])
        if hasItem and hasItem.amount > 0 then 
            count = hasItem.amount
        end
        return count
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function RegisterRDMItemUsage(itemdata, id)
    if ConfigS.framework == "redemrp" then 
        RegisterServerEvent("RegisterUsableItem:"..itemdata.item, function(source)
            local _source = source
            TriggerEvent("ricx_legendarymaps:check_use", _source, id)
        end)
    elseif ConfigS.framework == "redemrp-reboot" then
        RegisterServerEvent("RegisterUsableItem:"..itemdata.item, function(source)
            local _source = source
            TriggerEvent("ricx_legendarymaps:check_use", _source, id)
        end)
    elseif ConfigS.framework == "vorp" then 
        CreateThread(function()
            Citizen.Wait(100)
            VorpInv.RegisterUsableItem(itemdata.item, function(data)
                local _source = data.source 
                TriggerEvent("ricx_legendarymaps:check_use", _source, id)
                VorpInv.CloseInv(_source)
            end)
            return
        end)
    elseif ConfigS.framework == "qbr" or ConfigS.framework == "qbr2" or ConfigS.framework == "rsg" then 
        if ConfigS.framework == "qbr" then 
            exports['qbr-core']:CreateUseableItem(itemdata.item, function(source, item)
                local _source = source
                TriggerEvent("ricx_legendarymaps:check_use", _source, id)
            end)
        elseif ConfigS.framework == "rsg" then 
            RSGCore.Functions.CreateUseableItem(itemdata.item, function(source)
                local _source = source
                TriggerEvent("ricx_legendarymaps:check_use", _source, id)
            end)
        else
            QRCore.Functions.CreateUseableItem(itemdata.item, function(source, item)
                local _source = source
                TriggerEvent("ricx_legendarymaps:check_use", _source, id)
            end)
        end
    end
end
