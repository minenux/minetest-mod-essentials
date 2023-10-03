local have_unified_inventory = minetest.get_modpath("unified_inventory")
local FORMNAME = "essentials:ban_menu"

if have_unified_inventory then
    unified_inventory.register_button("ban_menu", {
        type = "image",
        image = "unified_inventory_ban.png",
        tooltip = "Ban menu",
        action = function(player)
            local name = player:get_player_name()
		    if minetest.check_player_privs(name, {ban=true}) then
                show_ban_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege 'ban'!")
            end
        end
    })

    unified_inventory.register_button("kick_menu", {
        type = "image",
        image = "unified_inventory_kick.png",
        tooltip = "Kick menu",
        action = function(player)
            local name = player:get_player_name()
		    if minetest.check_player_privs(name, {kick=true}) then
                show_kick_menu(name)
            else
                core.chat_send_player(name, "You dont have privilege 'kick'!")
            end
        end
    })

    --unified_inventory.register_button("mute_menu", {
    --    type = "image",
    --    image = "unified_inventory_mute.png",
    --    tooltip = "Mute menu",
    --    action = function(player)
    --        local name = player:get_player_name()
	--	    if minetest.check_player_privs(name, {mute=true}) then
    --            show_mute_menu(name)
    --        else
    --            core.chat_send_player(name, "You dont have privilege 'mute'!")
    --        end
    --    end
    --})
end