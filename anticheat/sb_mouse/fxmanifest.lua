fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'Salah'
description 'Standalone mouse spam protection system for RedM'

client_scripts {
    'client/mouse.lua'
}

server_scripts {
    'server/mouse.lua'
}

shared_scripts {
    'config.lua'
}

version '1.0.0' 