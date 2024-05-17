if essentials.add_privs then
    core.register_privilege("rename_player", {
        description = "Can rename self or someone else",
        give_to_singleplayer = false,
    })
    core.register_privilege("rename_item", {
        description = "Can rename items",
        give_to_singleplayer = false,
    })
    core.register_privilege("god_mode", {
        description = "Can be hurted by someone",
        give_to_singleplayer = false,
    })
    core.register_privilege("colored_nickname", {
        description = "Can color nicknames",
        give_to_singleplayer = false,
    })
    core.register_privilege("broadcast", {
        description = "Can annonce all the server",
        give_to_singleplayer = false,
    })
    core.register_privilege("speed", {
        description = "Can be fast or slow",
        give_to_singleplayer = false,
    })
    core.register_privilege("heal", {
        description = "Can heal yourself or someone",
        give_to_singleplayer = false,
    })
    core.register_privilege("kill", {
        description = "Can kill anyone",
        give_to_singleplayer = false,
    })
    core.register_privilege("get_pos", {
        description = "Can get position of player",
        give_to_singleplayer = true,
    })
    core.register_privilege("seed", {
        description = "Can use see th seed of world",
        give_to_singleplayer = true,
    })
    if not essentials.biome then
        core.register_privilege("biome", {
            description = "Can see current biome info",
            give_to_singleplayer = true,
        })
    end
end