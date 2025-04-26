fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Salah'
description 'A script that restricts mining to specific zones on the map'
version '1.0.0'

shared_scripts {
    'config/config.lua',
}

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

dependencies {
    'vorp_core',
    'vorp_mining'
} 