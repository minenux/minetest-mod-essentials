local have_spawn_command = minetest.get_modpath("spawn_command")
local enable_damage = core.settings:get_bool("enable_damage")

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
            minetest.sound_play("error", name)
        end
    end
    minetest.register_chatcommand("setspawn", {
        params = "<X>,<Y>,<Z>",
        description = "Sets a spawn point. (BETA)",
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
			minetest.chat_send_player(name, "Your IP address is ".. minetest.get_player_ip(name))
			return
        end
        if minetest.get_player_by_name(param) == nil then
			minetest.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
            minetest.sound_play("error", name)
			return
		end
		minetest.chat_send_player(name, "IP address of ".. param .." is ".. minetest.get_player_ip(param))
        
    end,
})

minetest.register_chatcommand("broadcast", {
    params = "<message>",
    description = "Send GLOBAL message in chat.",
    privs = {server = true},
    func = function(name, param)
        if param == "" then
            core.chat_send_player(name, core.colorize("red", "Message cannot be empty!"))
            minetest.sound_play("error", name)
        else
            core.chat_send_all(core.colorize("#00FFC6", param))
            minetest.sound_play("broadcast")
        end
    end,
})

minetest.register_chatcommand("biome", {
    params = "<info_name>",
    description = "Shows the current biome information you are in.",
    func = function(name, param)
        local pos = minetest.get_player_by_name(name):get_pos()
        local biomeinfo = minetest.get_biome_data(pos)
        local biome = minetest.get_biome_name(biomeinfo.biome)
        if param == "" then
            core.chat_send_player(name, "Biome: \"".. biome .."\"")
        else
            if minetest.check_player_privs(name, {server=true}) then
                if param == "heat" then
                    core.chat_send_player(name, "\"".. biome .."\": ".. biomeinfo.heat)
                elseif param == "humidity" then
                    core.chat_send_player(name, "\"".. biome .."\": ".. biomeinfo.humidity)
                else
                    core.chat_send_player(name, core.colorize("red", "You specialized wrong information name!"))
                    minetest.sound_play("error", name)
                end
            else
                core.chat_send_player(name, core.colorize("red", "You cant check more information without privelege!"))
                minetest.sound_play("error", name)
            end
        end
    end,
})

--minetest.get_mapgen_object
if essentials.seed then
    minetest.register_chatcommand("seed", {
        description = "Shows the seed of mapgen.",
        func = function(name, param)
            core.chat_send_player(name, "Seed: ["..core.colorize("#00ff00", minetest.get_mapgen_setting("seed")).."]")
        end,
    })
else
    minetest.register_chatcommand("seed", {
        privs = {server = true},
        description = "Shows the seed of mapgen.",
        func = function(name, param)
            core.chat_send_player(name, "Seed: ["..core.colorize("#00ff00", minetest.get_mapgen_setting("seed")).."]")
        end,
    })
end

-- god mode
function god_mode_switch(name, param)
    if enable_damage then
        local player = minetest.get_player_by_name(name)
        local ag = player:get_armor_groups()
        if not ag["immortal"] then
            ag["immortal"] = 1
            core.chat_send_player(name, "God mode enabled")
            minetest.sound_play("god_enabled", name)
        else
            ag["immortal"] = nil
            core.chat_send_player(name, "God mode disabled")
            minetest.sound_play("god_disabled", name)
        end
        player:set_armor_groups(ag)
    else
        core.chat_send_player(name, core.colorize("red", "\"enable_damage\" is disabled!"))
        minetest.sound_play("error", name)
    end
end

minetest.register_chatcommand("god", {
    description = "Enable/Disabe the god mode.",
    privs = {god_mode = true},
    func = god_mode_switch
})
-- end

minetest.register_chatcommand("ban_menu", {
    description = "Open the ban menu.",
    privs = {ban = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", "You cannot ban in single mode!"))
            minetest.sound_play("error", name)
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
            minetest.sound_play("error", name)
        else
            show_kick_menu(name)
        end
    end
})

--[[
minetest.register_chatcommand("mute_menu", {
   description = "Open the mute menu.",
   privs = {mute = true},
   func = function(name, param)
       if core.is_singleplayer() then
           minetest.chat_send_player(name, core.colorize("red", "You cannot mute in single mode!"))
       else
           show_mute_menu(name)
       end
   end
})
]]--

minetest.register_chatcommand("getpos", {
    params = "<name>",
    description = "Allows the player to find out the position of another player.",
    privs = {server = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(param);
		if param == "" then
			minetest.chat_send_player(name, core.colorize("red", "Player name cannot be empty!"))
            minetest.sound_play("error", name)
			return
        elseif minetest.get_player_by_name(param) == nil then
			minetest.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
            minetest.sound_play("error", name)
			return
		else
            local pos = player:get_pos();
            local round_pos = vector.round(pos);
		    minetest.chat_send_player(name, "Position of ".. param .." is ".. round_pos.x .." ".. round_pos.y .." ".. round_pos.z)
            
        end
    end,
})

minetest.register_chatcommand("rename_me", {
	description = "Show the rename menu.",
	privs = {rename_player = true},
	func = function(name, param)
        show_rename_menu(name)
	end
})

minetest.register_chatcommand("rename_item", {
	description = "Hold item in hand and open this menu for renaming it.",
	privs = {rename_item = true},
	func = function(name, param)
        show_renameitem_menu(name)
	end
})

minetest.register_chatcommand("color", {
	description = "Shows menu for coloring nickname.",
	privs = {colored_nickname = true},
	func = function(name, param)
        show_color_menu(name)
	end
})

minetest.register_chatcommand("set_color", {
    params = "<name>",
	description = "Sets a color for nickname of any player.",
	privs = {server = true},
	func = function(name, param)
        if not param then
            minetest.chat_send_player(name, core.colorize("red", "Please, specify an nickname of player."))
            return
        end
        if minetest.get_player_by_name(param) == nil then
            minetest.chat_send_player(name, core.colorize("red", "Thats player offline or doesnt exist!"))
        else
            minetest.get_player_by_name(othername):set_properties({
                nametag = "*".. new_name,
                nametag_color = "#AAAAAA"
            })
        end
	end
})

minetest.register_chatcommand("kill", {
    params = "<name>",
	description = ("Kill anyone with command."),
    privs = {server = true},
    func = function(name, param)
        if minetest.settings:get_bool("enable_damage") then
            if param == "" or param == nil then
                minetest.get_player_by_name(name):set_hp(0)
            else
                if minetest.get_player_by_name(param) == nil then
                    core.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
                    minetest.sound_play("error", name)
                    return
                end
                minetest.get_player_by_name(param):set_hp(0)
                core.chat_send_player(name, "You killed "..param..".")
                if essentials.killed_by then
                    core.chat_send_player(param, string.format("You has been killed by administrator %s.", name))
                end
            end
        else
            local player = minetest.get_player_by_name(name)
            if param then
                player = minetest.get_player_by_name(param)
                if minetest.get_player_by_name(param) == nil then
                    core.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
                    minetest.sound_play("error", name)
                    return
                end
                if essentials.killed_by then
                    core.chat_send_player(param, string.format("You has been respawned by %s.", name))
                end
            end
            for _, callback in pairs(minetest.registered_on_respawnplayers) do
                if callback(player) then
                    return true
                end
            end
            return false, "No static_spawnpoint defined"
        end
    end,
})


--[[
minetest.register_chatcommand("v", {
    params = "<name>",
    description = "Make player invisible",
    privs = {server = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(param)
        if param == "" then
            if invisibility[name] then
                invisible(name, false)
                minetest.chat_send_player(name, "Now you are visible!")
                
            elseif not invisibility[name] then
                invisible(name, true)
                minetest.chat_send_player(name, core.colorize("#AAAAAA", "Now you are invisible!"))
                
            end
        elseif not player then
            minetest.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
            minetest.sound_play("error", name)
        else
            if invisibility[param] then
                invisible(param, false)
                minetest.chat_send_player(name, "Now player ".. param .." are visible!")
                minetest.chat_send_player(player, "Now you visible from ".. name .."!")
                
                minetest.sound_play("done", player)
            elseif not invisibility[param] then
                invisible(param, true)
                minetest.chat_send_player(name, core.colorize("#AAAAAA", "Now player ".. param .." are invisible!"))
                minetest.chat_send_player(name, core.colorize("#AAAAAA", "Now you are invisible from ".. name .."!"))
                
                minetest.sound_play("done", player)
            end
        end
    end
})
]]--