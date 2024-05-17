local FORMNAME = "essentials:ip_command"

function show_ip_info(name)
	local formspec = "formspec_version[6]"..
        "size[10.5,4.5]"..
        "textarea[0.6,0.45;9.2,5.7;;;If you want to use /ip command, you must send a mail to the next address:\n\n"..core.colorize("blue", "SkyBuilderOFFICAL@yandex.ru").."\n\nAnd your message must have that text:\n\n\"I want to use a /ip command for Essentials mod in Minetest.\"\n\"Add a nickname \'Player\' in trusted ip users\"\n\nIf you will accepted, creator will put you in list of trusted ip users and you will can use /ip command]"
	minetest.show_formspec(name, FORMNAME, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= FORMNAME then
		return
	end
	return
end)