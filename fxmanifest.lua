fx_version 'cerulean'
game 'gta5'

name 'main-radialmenu'
description 'Advanced ESX Radial Menu with ox_lib, ox_inventory, ox_target integration'
author 'Main-Scripts'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'locales/locale.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_inventory',
    'ox_target',
    'oxmysql'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'