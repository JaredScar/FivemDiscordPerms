resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_script 'client.lua'
server_script "server.lua"

ui_page "NUI/panel.html"

files {
	"NUI/panel.js",
	"NUI/panel.html",
	"NUI/panel.css",
	"NUI/Badger_Discord_API.png"
}

server_export 'GetDiscordIdentifier'