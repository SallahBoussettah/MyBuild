fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game 'rdr3'
lua54 'yes'
author 'RedM Guardian'

client_scripts {
    'client/client.lua',
    'client/detectors.lua',
    'client/input_monitor.lua',
    'client/network.lua',
    'client/idle.lua',
    'client/velocity.lua',
    'client/session.lua',
    'client/resource_monitor.lua',
    'client/commands_monitor.lua',
    'client/keybind_monitor.lua',
    'client/asset_validator.lua'
}

server_scripts {
    'server/server.lua',
    'server/webhook.lua',
    'server/network.lua',
    'server/sanitizer.lua',
    'server/database.lua',
    'server/detectors.lua',
    'server/versioning.lua',
    'server/idle.lua',
    'server/velocity.lua',
    'server/session.lua',
    'server/event_limiter.lua'
}

shared_scripts {
    'config.lua',
    'shared/api/filter.js',
    'shared/api/utility.lua'
}

version '1.0.0' 