data = {}
local VorpCore
local VorpInv
local QBRItems
local QRCore
local qc
local RSGCore
if Config.framework == "redemrp" then
    TriggerEvent("redemrp_inventory:getData",function(call)
        data = call
    end)
elseif Config.framework == "redemrp-reboot" then
    TriggerEvent("redemrp_inventory:getData",function(call)
        data = call
    end)
    RedEM = exports["redem_roleplay"]:RedEM()
elseif Config.framework == "vorp" then 
    TriggerEvent("getCore",function(core)
        VorpCore = core
    end)
    
    VorpInv = exports.vorp_inventory:vorp_inventoryApi()
elseif Config.framework == "qbr" then 
    qc = "qbr-core"
    QBRItems = exports[qc]:GetItems()
elseif Config.framework == "qbr2" then 
    qc = "qr-core"
    QRCore = exports[qc]:GetCoreObject()
elseif Config.framework == "rsg" then 
    qc = "rsg-core"
    RSGCore = exports[qc]:GetCoreObject()
end
--------------------------------------------------------------------------------------------------------------------------------------------
function GetRDMPlayer(src)
    local a = nil 
    if Config.framework == "redemrp" then
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
    elseif Config.framework == "redemrp-reboot" then 
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
    elseif Config.framework == "vorp" then 
        local Character = VorpCore.getUser(src).getUsedCharacter
        local job =  Character.job
        local identifier = Character.identifier
        local charid = Character.charIdentifier
        local name = Character.firstname.." "..Character.lastname
        local money =  Character.money
        local grade = Character.jobGrade
        a = {identifier = identifier, charid = charid, name = pname, money = money, job = job, grade = grade}
    elseif Config.framework == "qbr" or Config.framework == "qbr2" or Config.framework == "rsg" then  
        local User 
        if  Config.framework == "qbr" then
            User = exports[qc]:GetPlayer(src)
        elseif Config.framework == "rsg" then  
            User = RSGCore.Functions.GetPlayer(src)
        else
            User = QRCore.Functions.GetPlayer(src)
        end
        local job =  User.PlayerData.job
        local identifier = User.PlayerData.license
        local charid = User.PlayerData.cid
        local name = User.PlayerData.charinfo.firstname.." "..User.PlayerData.charinfo.lastname
        local money = User.PlayerData.money.cash
        a = {identifier = identifier, charid = charid, name = pname, money = money, job = job.name, grade = job.grade.level}
    end
    return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
function SetRDMPlayerJob(src, job)
    if Config.framework == "redemrp" then
        TriggerEvent('redemrp:getPlayerFromId', src, function(user)
            if user then 
                user.setJob(job.id)
                user.getJobgrade(job.grade)
            end
        end)
        Wait(200)
    elseif Config.framework == "redemrp-reboot" then
            local Player = RedEM.GetPlayer(src)
            Player.SetJob(job.id)
            Player.SetJobGrade(job.grade)
    elseif Config.framework == "vorp" then
        local Character = VorpCore.getUser(src).getUsedCharacter
        Character.setJob(job.id)
        Character.setJobGrade(job.grade)
    elseif Config.framework == "qbr" or Config.framework == "qbr2" or Config.framework == "rsg" then  
        local User 
        if  Config.framework == "qbr" then
            User = exports[qc]:GetPlayer(src)
        elseif Config.framework == "rsg" then  
            User = RSGCore.Functions.GetPlayer(src)
        else
            User = QRCore.Functions.GetPlayer(src)
        end
        User.Functions.SetJob(job.id, job.grade)
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function RedMSQL(dat)
    local a = nil
    local params = {
        id2 = dat.identifier,
        id3 = dat.charid, 
    }
    local t = "SELECT * FROM ricx_jobs WHERE identifier=@id2 AND charid=@id3"
    if dat.id then 
        params.id = dat.id
        t = "SELECT * FROM ricx_jobs WHERE identifier=@id2 AND charid=@id3 AND id=@id"
    end

    if Config.framework == "redemrp" then 
        MySQL.Async.fetchAll(t, params, function(result)
            if result[1] then
                a = result
            else
                a = false
            end
        end)
    elseif Config.framework == "redemrp-reboot" then 
        if dat.id then 
            t = "SELECT * FROM ricx_jobs WHERE identifier=? AND charid=? AND id=?"
            MySQL.query(t, {dat.identifier, dat.charid, dat.id}, function(result)
                if result[1] then
                    a = result
                else
                    a = false
                end
            end)
        else
            t = "SELECT * FROM ricx_jobs WHERE identifier=? AND charid=?"
            MySQL.query(t, {dat.identifier, dat.charid}, function(result)
                if result[1] then
                    a = result
                else
                    a = false
                end
            end)
        end
    elseif Config.framework == "vorp" then 
        exports.ghmattimysql:execute(t, params, function(result)
            if result[1] then
                a = result
            else
                a = false
            end
        end)
    elseif Config.framework == "qbr" or Config.framework == "qbr2" or Config.framework == "rsg" then 
        MySQL.query(t, params, function(result)
            if result[1] then
                a = result
            else
                a = false
            end
        end)
    end
    while a == nil do 
        Wait(100)
    end
    return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
function RedMSQL2()
    local a = nil
    if Config.framework == "redemrp" then 
        MySQL.Async.fetchAll("SELECT * FROM ricx_jobs", {}, function(result)
            if result[1] then
                a = result
            else
                a = false
            end
        end)
    elseif Config.framework == "redemrp-reboot" then 
        MySQL.query("SELECT * FROM ricx_jobs", {}, function(result)
            if result[1] then
                a = result
            else
                a = false
            end
        end)
    elseif Config.framework == "vorp" then 
        exports.ghmattimysql:execute("SELECT * FROM ricx_jobs", {}, function(result)
            if result[1] then
                a = result
            else
                a = false
            end
        end)
    elseif Config.framework == "qbr" or Config.framework == "qbr2" or Config.framework == "rsg" then 
        MySQL.query("SELECT * FROM ricx_jobs", {}, function(result)
            if result[1] then
                a = result
            else
                a = false
            end
        end)
    end
    while a == nil do 
        Wait(100)
    end
    return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
function RedMSQL_Update(dat, save)
    if Config.framework == "redemrp" then 
        MySQL.Async.execute("UPDATE ricx_jobs SET data=@data WHERE identifier=@id2 AND charid=@id3", {id2 = dat.identifier, id3 = dat.charid, data = save}, function(done)
        end)
    elseif Config.framework == "redemrp-reboot" then 
        MySQL.update("UPDATE ricx_jobs SET data=? WHERE identifier=? AND charid=?", {save, dat.identifier, dat.charid}, function(done)
        end)
    elseif Config.framework == "vorp" then 
        exports.ghmattimysql:execute("UPDATE ricx_jobs SET data=@data WHERE identifier=@id2 AND charid=@id3", {id2 = dat.identifier, id3 = dat.charid, data = save}, function(done)
        end)
    elseif Config.framework == "qbr" or Config.framework == "qbr2" or Config.framework == "rsg" then 
        MySQL.update("UPDATE ricx_jobs SET data=@data WHERE identifier=@id2 AND charid=@id3", {id2 = dat.identifier, id3 = dat.charid, data = save})
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function RedMSQL_Insert(dat, save)
    if Config.framework == "redemrp" then 
        MySQL.Async.execute("INSERT INTO ricx_jobs (identifier, charid, data) VALUES (@identifier, @charid, @data)",  {identifier = dat.identifier, charid = dat.charid, data = save}, function(result)
        end)
    elseif Config.framework == "redemrp-reboot" then 
        MySQL.insert("INSERT INTO ricx_jobs (identifier, charid, data) VALUES (?,?,?)",  {dat.identifier, dat.charid, save}, function(result)
        end)
    elseif Config.framework == "vorp" then 
        exports.ghmattimysql:execute("INSERT INTO ricx_jobs (identifier, charid, data) VALUES (@identifier, @charid, @data)",  {identifier = dat.identifier, charid = dat.charid, data = save}, function(done)
        end)
    elseif Config.framework == "qbr" or Config.framework == "qbr2" or Config.framework == "rsg" then  
        MySQL.insert("INSERT INTO ricx_jobs (identifier, charid, data) VALUES (@identifier, @charid, @data)",  {identifier = dat.identifier, charid = dat.charid, data = save})
    end
end
--------------------------------------------------------------------------------------------------------------------------------------------