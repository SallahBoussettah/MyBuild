
fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
games {"rdr3"}
lua54 "yes"

escrow_ignore {
    'config.lua',
	'config_c.lua', 
}

files {
    'not.js',
}

shared_scripts {
    'config.lua',
    'config_c.lua',
}

client_scripts {
    'client.lua',
    'not.js'
}

server_scripts {
    'server.lua',
}
export 'CreateLocNotif' 

--HOW TO USE #1: exports.ricx_zone_notif:CreateLocNotif()
--HOW TO USE #2: exports.ricx_zone_notif:CreateLocNotif("Here can come text", "COLOR_RED") --text, color
dependency '/assetpacks'