fx_version "adamant"
games {"rdr3"}

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Salah'
description 'Safe Zone system for VORP framework'
version '1.0.0'

client_scripts {
    "config.lua",
    "client.lua"
}

shared_scripts {
    'config.lua'
}

files {
    'html/*',
}

ui_page 'html/index.html'

dependencies {
    'vorp_core'
}