fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'Salah'
description 'Standalone weapons and health protection system for RedM'

client_scripts {
    'client/weapons.lua'
}

server_scripts {
    'server/weapons.lua'
}

shared_scripts {
    'config.lua'
}

version '1.0.0' 