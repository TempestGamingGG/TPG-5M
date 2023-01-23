fx_version 'adamant'

game 'gta5'

author ''

description ''

client_scripts {
    'config.lua',
    'client.lua',
}

server_scripts {
    'config.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/responsive.css',
    'html/*.js',

    'html/img/*.png',
    'html/settings-img/*.png',
    'html/Radial-Mode/*.png',
    'html/Text-Mode/*.png',

    'html/Venice-Mode/*.png',
}


lua54 'yes'

escrow_ignore {
    'config.lua',

}