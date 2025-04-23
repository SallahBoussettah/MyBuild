fx_version 'adamant' 
game 'rdr3' 

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
-- Kaynak bilgileri
author 'DevPOGUE'
description 'Store and Bank Robbery system'
version '1.1.0'

lua54 'yes'

escrow_ignore {
    'config.lua',
    'README.md',
    'LICENSE'
}

shared_scripts {
    'config.lua' 
}


server_scripts {
    'server/server.lua'
}

client_scripts {
    'client/client.lua' 
}

dependencies {
    'vorp_core', 
    'progressBars'
}

dependency '/assetpacks'
dependency '/assetpacks-redm'