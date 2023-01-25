fx_version 'cerulean'
games { 'gta5' }

shared_scripts {
	'@qb-core/shared/locale.lua',
	'config.lua',
    'lua/shared/sh_*.lua',
}

client_scripts {
	'config.lua',
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'lua/client/*.lua',
}

server_scripts {
	'config.lua',
    '@oxmysql/lib/MySQL.lua',
    'lua/server/*.lua',
}

server_exports {
    'AddTransaction',
    'GetTaxByType',
    'CalculateTax',
}

ui_page 'html/index.html'

files {
	'html/index.html',
    'html/app.js',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/css/*.css'
}
