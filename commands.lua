local have_spawn_command = minetest.get_modpath("spawn_command")
local enable_damage = core.settings:get_bool("enable_damage")
local hide_names = {}

minetest.register_chatcommand("about_essentials", {
    description = "About the 'essentials' mod.",
    func = function(name, param)
        show_about(name)
    end
})

-- 'spawn_command' mod
if have_spawn_command then
    function set_the_spawn(name, param)
		local p = {}
        local posmessage = {x = 0, y = 0, z = 0}
        local player = minetest.get_player_by_name(name);
        local pos = player:get_pos();
        local static_spawnpoint = minetest.setting_get_pos("static_spawnpoint");
        local spawn_pos = vector.round(spawn_command.pos);
        p.x, p.y, p.z = string.match(param, "^([%d.~-]+)[, ] *([%d.~-]+)[, ] *([%d.~-]+)$");
		p = core.parse_coordinates(p.x, p.y, p.z, pos);

        if player == nil then
            return false
        end

		if p and p.x and p.y and p.z then
            spawn_command.pos = {x = p.x, y = p.y, z = p.z};
            static_spawnpoint = {x = p.x, y = p.y, z = p.z};
            posmessage = {x = p.x, y = p.y, z = p.z};
            minetest.chat_send_player(name, core.colorize("#00FF06", "Spawn sets successful at ".. posmessage.x .." ".. posmessage.y .." ".. posmessage.z .."!"))
        elseif param == "" then
            spawn_pos = vector.round(pos);
            spawn_command.pos = spawn_pos;
            static_spawnpoint = spawnpos;
            minetest.chat_send_player(name, core.colorize("#00FF06", "Spawn sets successful at ".. spawn_pos.x .." ".. spawn_pos.y .." ".. spawn_pos.z .."!"))
        else
            minetest.chat_send_player(name, core.colorize("red", "Wrong position!"))
        end
    end
minetest.register_chatcommand("setspawn", {
    params = "<X>,<Y>,<Z>",
    description = "Sets a spawn point.",
    privs = {server = true},
    func = set_the_spawn,
})
end
-- end

minetest.register_chatcommand("ip", {
    params = "<name>",
    description = "Show the IP of a player.",
    privs = {server = true},
    func = function(name, param)
		if param == "" then
			minetest.chat_send_player(name, "Your IP of is ".. minetest.get_player_ip(name))
			return
        end
        if minetest.get_player_by_name(param) == nil then
			minetest.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
			return
		end
		minetest.chat_send_player(name, "IP of ".. param .." is ".. minetest.get_player_ip(param))
    end,
})

minetest.register_chatcommand("broadcast", {
    params = "<message>",
    description = "Send GLOBAL message in chat.",
    privs = {server = true},
    func = function(name, param)
        if param == "" then
            core.chat_send_player(name, core.colorize("red", "Message cannot be empty!"))
        else
            core.chat_send_all(core.colorize("#00FFC6", param))
        end
    end,
})

if enable_damage then
    function god_mode(name, param)
        local player = minetest.get_player_by_name(name)
        local ag = player:get_armor_groups()
        if not ag["immortal"] then
            ag["immortal"] = 1
            core.chat_send_player(name, "God mode enabled")
            minetest.sound_play("god_enabled", name)
        else
            ag["immortal"] = nil
            core.chat_send_player(name, "God mode diabled")
            minetest.sound_play("god_disabled", name)
        end
        player:set_armor_groups(ag)
    end

    minetest.register_chatcommand("god", {
        description = "Enable/Disabe the god mode.",
        privs = {god = true},
        func = god_mode
    })
end

minetest.register_chatcommand("ban_menu", {
    description = "Open the ban menu.",
    privs = {ban = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", "You cannot ban in single mode!"))
        else
            show_ban_menu(name)
        end
    end
})

minetest.register_chatcommand("kick_menu", {
    description = "Open the kick menu.",
    privs = {kick = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", "You cannot kick in single mode!"))
        else
            show_kick_menu(name)
        end
    end
})

--minetest.register_chatcommand("mute_menu", {
--    description = "Open the mute menu.",
--    privs = {mute = true},
--    func = function(name, param)
--        if core.is_singleplayer() then
--            minetest.chat_send_player(name, core.colorize("red", "You cannot mute in single mode!"))
--        else
--            show_mute_menu(name)
--        end
--    end
--})

minetest.register_chatcommand("getpos", {
    params = "<name>",
    description = "Allows the player to find out the position of another player.",
    privs = {vip = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(param);

		if param == "" then
			minetest.chat_send_player(name, core.colorize("red", "Player name cannot be empty!"))
			return
        elseif minetest.get_player_by_name(param) == nil then
			minetest.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
			return
		else
            local pos = player:get_pos();
            local round_pos = vector.round(pos);
		    minetest.chat_send_player(name, "Position of ".. param .." is ".. round_pos.x .." ".. round_pos.y .." ".. round_pos.z)
        end
    end,
})

minetest.register_chatcommand("rename_me", {
	params = "<new_name>",
	description = "Hide your real name and rename it on fake.",
	privs = {},
	func = function(name, param)
		hide_names[name] = param
	end
})

minetest.register_on_chat_message(function(name, message)
	local new_name = hide_names[name]
	if new_name then
		minetest.chat_send_all("<"..new_name.."> "..message)
		return true
	end
end)
