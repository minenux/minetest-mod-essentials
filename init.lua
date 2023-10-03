local version = "0.0.1"
local stat_version = "ALPHA"
local modpath = minetest.get_modpath(minetest.get_current_modname())
local send_version = true
--local name = player:get_player_name()

-- connections
dofile(modpath.."/commands.lua")
--dofile(modpath.."/settings.lua")
dofile(modpath.."/priveleges.lua")
--dofile(modpath.."/watermark.lua")
dofile(modpath.."/unified_inventory.lua")
dofile(modpath.."/ui/ban_menu.lua")
dofile(modpath.."/ui/kick_menu.lua")
dofile(modpath.."/ui/mute_menu.lua")

minetest.log("action", "[Essentials] Mod initialised. Version: ".. version)

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()

    if send_version == true then
        minetest.chat_send_player(name, core.colorize("orange", "Essentials mod installed.").. " " ..core.colorize("#0050b3", "By Builder Mods STUDIO.").. " " ..core.colorize("green", "Version: ".. version .." ".. stat_version))
    elseif send_version == false then
        minetest.log("action", "[Essentials] send_version is false. Cant send the message")
    end
end)
