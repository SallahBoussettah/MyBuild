
fx_version "cerulean"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
games {"rdr3"}
lua54 "yes"

escrow_ignore {
	'config.lua', 
}

files {'not.js'}

client_scripts {
    'not.js',
    'config.lua',
    'client.lua'
}


server_scripts {
    'config.lua',
    'server.lua',
}
dependency '/assetpacks'
dependency '/assetpacks-redm'