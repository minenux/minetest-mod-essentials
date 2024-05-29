local enable_damage = core.settings:get_bool("enable_damage")
local speeds = {}

local function containsValue(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

minetest.register_chatcommand("ip", {
    params = "<name>",
    description = "Show the IP of a player.",
    privs = {server = true},
    func = function(name, param)
        if not containsValue(essentials.trusted_ip_users, name) then
            minetest.chat_send_player(name, core.colorize("red", "You are not of trusted administrator!"))
            minetest.sound_play("error", name)
            show_ip_info(name)
            return
        end
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

if essentials.add_privs then
    minetest.register_chatcommand("broadcast", {
        params = "<message>",
        description = "Send GLOBAL message in chat.",
        privs = {broadcast = true},
        func = function(name, param)
            if param == "" then
                core.chat_send_player(name, core.colorize("red", "Message cannot be empty!"))
                minetest.sound_play("error", name)
                return
            end
            if minetest.check_player_privs(name, {server=true}) then
                core.chat_send_all(core.colorize("#0006FF", "[Announcement] ")..core.colorize("#00FFC6", param))
            else
                core.chat_send_all(core.colorize("#0006FF", "[Announcement] ")..core.colorize("#00FFC6", param).." "..core.colorize("#82909D", string.format("(Announced by %s)", name)))
            end
            for _, player in ipairs(minetest.get_connected_players()) do
                minetest.sound_play("broadcast", player:get_player_name())
            end
        end,
    })
else
    minetest.register_chatcommand("broadcast", {
        params = "<message>",
        description = "Send GLOBAL message in chat.",
        privs = {bring = true},
        func = function(name, param)
            if param == "" then
                core.chat_send_player(name, core.colorize("red", "Message cannot be empty!"))
                minetest.sound_play("error", name)
                return
            end
            if minetest.check_player_privs(name, {server=true}) then
                core.chat_send_all(core.colorize("#0006FF", "[Announcement] ")..core.colorize("#00FFC6", param))
            else
                core.chat_send_all(core.colorize("#0006FF", "[Announcement] ")..core.colorize("#00FFC6", param).." "..core.colorize("#82909D", string.format("(Announced by %s)", name)))
            end
            for _, player in ipairs(minetest.get_connected_players()) do
                minetest.sound_play("broadcast", player:get_player_name())
            end
        end,
    })
end

local function isNumber(num)
    local value = tonumber(num)
    return (type(value) == "number" and math.floor(value) ~= value) or (type(value) == "number" and math.floor(value) == value)
end

if essentials.add_privs then
    minetest.register_chatcommand("speed", {
        params = "<speed> [<player>]",
        description = "Sets a speed for an any player. (Standart speed is 1)",
        privs = {speed = true},
        func = function(name, param)
            local speed = string.match(param, "([^ ]+)")
            local oname = string.match(param, speed.." (.+)")
            --core.chat_send_all(dump(speed).." "..dump(oname))
            if speed == nil then
                core.chat_send_player(name, string.format("Your speed now is %s.", 1))
                minetest.sound_play("done", name)
                minetest.get_player_by_name(name):set_physics_override({
                    speed = 1
                })
                return
            end
            if oname == nil then
                core.chat_send_player(name, string.format("Your speed now is %s.", speed))
                minetest.sound_play("done", name)
                minetest.get_player_by_name(name):set_physics_override({
                    speed = tonumber(speed)
                })
            else
                if minetest.get_player_by_name(oname) == nil then
                    core.chat_send_player(name, core.colorize("red", "Please, specify an online player."))
                    minetest.sound_play("error", name)
                    return
                end
                core.chat_send_player(name, string.format("Speed of player %s now is %s.", oname, speed))
                minetest.sound_play("done", name)
                minetest.sound_play("done", oname)
                if essentials.changed_by then
                    minetest.chat_send_player(oname, string.format("Now your speed is %s from player %s.", speed, name))
                end
                minetest.get_player_by_name(oname):set_physics_override({
                    speed = tonumber(speed)
                })
            end
        end,
    })
else
    minetest.register_chatcommand("speed", {
        params = "<speed> [<player>]",
        description = "Sets a speed for an any player. (Standart speed is 1)",
        privs = {rollback = true},
        func = function(name, param)
            local speed = string.match(param, "([^ ]+)")
            local oname = string.match(param, speed.." (.+)")
            --core.chat_send_all(dump(speed).." "..dump(oname))
            if speed == nil then
                core.chat_send_player(name, string.format("Your speed now is %s.", 1))
                minetest.sound_play("done", name)
                minetest.get_player_by_name(name):set_physics_override({
                    speed = 1
                })
                return
            end
            if oname == nil then
                core.chat_send_player(name, string.format("Your speed now is %s.", speed))
                minetest.sound_play("done", name)
                minetest.get_player_by_name(name):set_physics_override({
                    speed = tonumber(speed)
                })
            else
                if minetest.get_player_by_name(oname) == nil then
                    core.chat_send_player(name, core.colorize("red", "Please, specify an online player."))
                    minetest.sound_play("error", name)
                    return
                end
                core.chat_send_player(name, string.format("Speed of player %s now is %s.", oname, speed))
                minetest.sound_play("done", name)
                minetest.sound_play("done", oname)
                if essentials.changed_by then
                    minetest.chat_send_player(oname, string.format("Now your speed is %s from player %s.", speed, name))
                end
                minetest.get_player_by_name(oname):set_physics_override({
                    speed = tonumber(speed)
                })
            end
        end,
    })
end

if essentials.add_privs then
    if essentials.biome then
        minetest.register_chatcommand("biome", {
            params = "[<info_name>]",
            description = "Shows the current biome information you are in.",
            func = function(name, param)
                local pos = minetest.get_player_by_name(name):get_pos()
                if not minetest.has_feature("object_use_texture_alpha") then
                    core.chat_send_player(name, core.colorize("red", "Biome info cannot retrieve, server engine does not support the command!"))
                    minetest.sound_play("error", name)
                    minetest.log("error","[essentials] server mineitest engine too old, biome data not supported!, upgrade server")
                end
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
    else
        minetest.register_chatcommand("biome", {
            params = "<info_name>",
            privs = {biome = true},
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
    end
else
    minetest.register_chatcommand("biome", {
        params = "[<info_name>]",
        privs = {},
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
end

--minetest.get_mapgen_object
if essentials.add_privs then
    if essentials.seed then
        minetest.register_chatcommand("seed", {
            description = "Shows the seed of mapgen.",
            func = function(name, param)
                core.chat_send_player(name, "Seed: ["..core.colorize("#00ff00", minetest.get_mapgen_setting("seed")).."]")
            end,
        })
    else
        minetest.register_chatcommand("seed", {
            privs = {seed = true},
            description = "Shows the seed of mapgen.",
            func = function(name, param)
                core.chat_send_player(name, "Seed: ["..core.colorize("#00ff00", minetest.get_mapgen_setting("seed")).."]")
            end,
        })
    end
else
    if essentials.seed then
        minetest.register_chatcommand("seed", {
            description = "Shows the seed of mapgen.",
            func = function(name, param)
                core.chat_send_player(name, "Seed: ["..core.colorize("#00ff00", minetest.get_mapgen_setting("seed")).."]")
            end,
        })
    else
        minetest.register_chatcommand("seed", {
            privs = {rollback = true},
            description = "Shows the seed of mapgen.",
            func = function(name, param)
                core.chat_send_player(name, "Seed: ["..core.colorize("#00ff00", minetest.get_mapgen_setting("seed")).."]")
            end,
        })
    end
end

-- god mode
function god_mode_switch(name, param)
    if enable_damage then
        local player
        if param == "" then
            player = minetest.get_player_by_name(name)
        else
            player = minetest.get_player_by_name(param)
        end
        if player == nil then
            core.chat_send_player(name, core.colorize("red", string.format("Player %s not found.", param)))
            minetest.sound_play("error", name)
            return
        end
        local ag = player:get_armor_groups()
        if not ag["immortal"] then
            ag["immortal"] = 1
            if param == "" then
                core.chat_send_player(name, core.colorize("yellow", "God mode enabled"))
                minetest.sound_play("god_enabled", name)
            else
                core.chat_send_player(name, string.format("God mode enabled for %s.", param))
                core.chat_send_player(param, string.format("For you enabled god mode from %s.", name))
                minetest.sound_play("god_enabled", param)
                minetest.sound_play("done", name)
            end
        else
            ag["immortal"] = nil
            if param == "" then
                core.chat_send_player(name, core.colorize("yellow", "God mode disabled"))
                minetest.sound_play("god_disabled", name)
            else
                core.chat_send_player(name, string.format("God mode disabled for %s.", param))
                core.chat_send_player(param, string.format("For you god mode has been disabled by %s", name))
                minetest.sound_play("god_disabled", param)
                minetest.sound_play("done", name)
            end
        end
        player:set_armor_groups(ag)
    else
        core.chat_send_player(name, core.colorize("red", "\"enable_damage\" is disabled!"))
        minetest.sound_play("error", name)
    end
end

if essentials.add_privs then
    minetest.register_chatcommand("god", {
        params = "[<name>]",
        description = "Enable/Disabe the god mode.",
        privs = {god_mode = true},
        func = god_mode_switch
    })
else
    minetest.register_chatcommand("god", {
        params = "[<name>]",
        description = "Enable/Disabe the god mode.",
        privs = {noclip = true},
        func = god_mode_switch
    })
end
-- end

minetest.register_chatcommand("ban_menu", {
    description = "Open the ban menu.",
    privs = {ban = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", "You cannot ban in single mode!"))
            minetest.sound_play("error", name)
            return
        end
        show_ban_menu(name)
    end
})

minetest.register_chatcommand("kick_menu", {
    description = "Open the kick menu.",
    privs = {kick = true},
    func = function(name, param)
        if core.is_singleplayer() then
            minetest.chat_send_player(name, core.colorize("red", "You cannot kick in single mode!"))
            minetest.sound_play("error", name)
            return
        end
        show_kick_menu(name)
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

if essentials.add_privs then
    minetest.register_chatcommand("rename_me", {
        description = "Shows the rename menu.",
        privs = {rename_player = true},
        func = function(name, param)
            show_rename_menu(name)
        end
    })
else
    minetest.register_chatcommand("rename_me", {
        description = "Shows the rename menu.",
        privs = {kick = true},
        func = function(name, param)
            show_rename_menu(name)
        end
    })
end
]]--

if essentials.add_privs then
    minetest.register_chatcommand("getpos", {
        params = "<name>",
        description = "Allows the player to find out the position of another player.",
        privs = {get_pos = true},
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
            end
            local pos = player:get_pos();
            local round_pos = vector.round(pos);
            minetest.chat_send_player(name, "Position of ".. param .." is ".. round_pos.x .." ".. round_pos.y .." ".. round_pos.z)
            minetest.sound_play("done", name)
        end,
    })
else
    minetest.register_chatcommand("getpos", {
        params = "<name>",
        description = "Allows the player to find out the position of another player.",
        privs = {teleport = true},
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
            end
            local pos = player:get_pos();
            local round_pos = vector.round(pos);
            minetest.chat_send_player(name, "Position of ".. param .." is ".. round_pos.x .." ".. round_pos.y .." ".. round_pos.z)
            minetest.sound_play("done", name)
        end,
    })
end

if essentials.add_privs then
    minetest.register_chatcommand("rename_item", {
        description = "Hold item in hand and open this menu for renaming it.",
        privs = {rename_item = true},
        func = function(name, param)
            show_renameitem_menu(name)
        end
    })
else
    minetest.register_chatcommand("rename_item", {
        description = "Hold item in hand and open this menu for renaming it.",
        privs = {basic_privs = true},
        func = function(name, param)
            show_renameitem_menu(name)
        end
    })
end

if essentials.add_privs then
    minetest.register_chatcommand("color", {
        description = "Shows menu for coloring nickname.",
        privs = {colored_nickname = true},
        func = function(name, param)
            show_color_menu(name)
        end
    })
else
    minetest.register_chatcommand("color", {
        description = "Shows menu for coloring nickname.",
        privs = {kick = true},
        func = function(name, param)
            show_color_menu(name)
        end
    })
end

if essentials.add_privs then
    minetest.register_chatcommand("kill", {
        params = "[<name>]",
        description = ("Kill anyone with command."),
        privs = {kill = true},
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
                        core.chat_send_player(param, string.format("You has been killed by %s.", name))
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
else
    minetest.register_chatcommand("kill", {
        params = "[<name>]",
        description = ("Kill anyone with command."),
        privs = {protection_bypass = true},
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
                        core.chat_send_player(param, string.format("You has been killed by %s.", name))
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
end

if essentials.add_privs then
    minetest.register_chatcommand("heal", {
        params = "[<name>]",
        description = ("Heals full health for a player."),
        privs = {heal = true},
        func = function(name, param)
            if param == "" or param == nil then
                minetest.get_player_by_name(name):set_hp(minetest.PLAYER_MAX_HP_DEFAULT)
                core.chat_send_player(name, "Healed to the possible max health.")
            else
                if minetest.get_player_by_name(param) == nil then
                    core.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
                    minetest.sound_play("error", name)
                    return
                end
                minetest.get_player_by_name(param):set_hp(minetest.PLAYER_MAX_HP_DEFAULT)
                core.chat_send_player(name, string.format("Player %s healed to the %s health.", param, minetest.get_player_by_name(param):get_hp()))
                if essentials.changed_by then
                    core.chat_send_player(param, string.format("You has been fully healed by %s.", name))
                end
            end
        end,
    })
else
    minetest.register_chatcommand("heal", {
        params = "[<name>]",
        description = ("Heals full health for a player."),
        privs = {rollback = true},
        func = function(name, param)
            if param == "" or param == nil then
                minetest.get_player_by_name(name):set_hp(minetest.PLAYER_MAX_HP_DEFAULT)
                core.chat_send_player(name, "Healed to the possible max health.")
            else
                if minetest.get_player_by_name(param) == nil then
                    core.chat_send_player(name, core.colorize("red", "Player ".. param .." not found!"))
                    minetest.sound_play("error", name)
                    return
                end
                minetest.get_player_by_name(param):set_hp(minetest.PLAYER_MAX_HP_DEFAULT)
                core.chat_send_player(name, string.format("Player %s healed to the %s health.", param, minetest.get_player_by_name(param):get_hp()))
                if essentials.changed_by then
                    core.chat_send_player(param, string.format("You has been fully healed by %s.", name))
                end
            end
        end,
    })
end

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