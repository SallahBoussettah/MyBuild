fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'Salah'
description 'Standalone Discord webhook module for RedM anticheat systems'

server_scripts {
    'server/discord.lua'
}

shared_scripts {
    'config.lua'
}

exports {
    'sendToDiscord'
}

version '1.0.0' 