fx_version 'adamant'

game 'gta5'

description 'ESX Property'

version 'legacy'

shared_script '@es_extended/imports.lua'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
	'instance',
	'cron',
}
