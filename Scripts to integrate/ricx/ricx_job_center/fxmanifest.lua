
fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
games {"rdr3"}
lua54 "yes"

escrow_ignore {
	'config.lua',
    'events.lua',
    'fw_func.lua',
}

files {
    'not.js',
}

shared_scripts {
    'config.lua',
}

client_scripts {
    'client.lua',
    'events.lua',
    'not.js'
}


server_scripts {
    '@mysql-async/lib/MySQL.lua', --delete this line if you are using VORP, FOR QBR: '@oxmysql/lib/MySQL.lua', FOR REDEMRP: '@mysql-async/lib/MySQL.lua' | FOR REDEMRP-REBOOT: '@oxmysql/lib/MySQL.lua',
    'fw_func.lua',
    'server.lua',
}
server_export 'GetPlayerJobs'

--[[
    How to use at server side:
    local jobs = exports.ricx_job_center:GetPlayerJobs(identifier, charid)
    for i,v in pairs(jobs) do 
        print("job id: ", v.id)
    end
]]
dependency '/assetpacks'
dependency '/assetpacks-redm'