fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Salah'
description 'A script that restricts mining to specific zones on the map and adds mining stores'
version '1.1.0'

lua54 'yes'

escrow_ignore {
    'config/config.lua',
    'shared/buyItemsCFG.lua',
    'shared/sellItemsCFG.lua',
    'shared/language.lua',
    'README.md',
    'LICENSE',
}

shared_scripts {
    'config/config.lua',
    'shared/language.lua',
    'shared/buyItemsCFG.lua',
    'shared/sellItemsCFG.lua',
}

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

dependencies {
    'vorp_core',
    'vorp_inventory',
    'vorp_mining',
    'vorp_menu'
} 