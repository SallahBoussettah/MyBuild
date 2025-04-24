version '1.0.0'
author 'RS DEVELOPMENT'
description 'RSD MAPLOADER https://script.redstartrp.fr'
repository 'https://script.redstartrp.fr'

fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

shared_scripts {
    'config/*.lua',
}

client_scripts {
	'utils/*.lua',
	'client/*.lua'
}

server_scripts {
	'server/*.lua',
}

escrow_ignore {
    'config/*.lua',
	'utils/*.lua',
}


files {
    'data/**/*.xml',
}

rsd_maploader_map {
	--deletion
	'data/deletions/DELETION.xml',
	--maps
    'data/maps/TESTMAP.xml',
}

dependency '/assetpacks'
dependency '/assetpacks-redm'