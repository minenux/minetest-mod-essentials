-- god mode
if enable_damage then
    core.register_privilege("god", {
        description = "Can use /god command",
        give_to_singleplayer = false,
    })
end

core.register_privilege("vip", {
    description = "Can use vip commands",
    give_to_singleplayer = false,
})

core.register_privilege("mute", {
    description = "Can mute/unmute players.",
    give_to_singleplayer = false,
})