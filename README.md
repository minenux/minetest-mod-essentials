minetest-mod-essentials
=========================

Mod with many-many useful console commands and api functions!

Information
-----------

This mod attempts to be an improvement usefully essentials commands 
as a featured version of some other tools etc etc etc, 
**for more featured  check `governor` and `authrx` minenux versions mods** 
on the informations below!

![](screenshot.png)

## Technical info
-----------------

This mod must be named `essentials` and provides administrarion tools and 
procedures to manage server using a bunch of commands some already provided 
by other mods some already new but similar to other mods.

**Almost 99% of this commands are already provided in `governor` mod**, 
at minenux project, this mod is only for backguard and improved performance 
respect original; if you want more simple and faster, use `governor` mod!

**Ban, kick and mute features are already provided by MinenuX's auth redux** 
version mod, check it out at https://git.minetest.io/minenux/minetest-mod-auth_rx 
or also into codeberg at https://codeberg.org/minenux/minetest-mod-auth_rx

#### Configurations

| config param                 | type   |  value     | req | default/min/mx  | observations and examples        |
| ---------------------------- | ------ | ---------- | --- | --------------- | -------------------------------- |
| secure.http_mods             | string | essentials | yes | none set        | geoip,governing,essentials       |
| secure.trusted_mods          | string | essentials | yes | none set        | auth_rx,governingg,essentials    |
| essentials_additional_privileges | bool | true | no | true          | Enables extra refined privilegies for the commands, see privilege tables       |
| essentials_changed_by        | bool | true  | no  | true            | Allows to see if a player property whas altered (by) when was made by some admin |
| essentials_killed_by         | bool | true  | no  | true            | Allows to see who a player was killed (by) when was killed by some admin |
| essentials_biome             | bool | true  | no  | true            | Allows to see for anyone request biome infos, otherwise only admins allows |
| essentials_seed              | bool | false | no  | false           | Allows to see for anyone the seed of the world, otherwise only admins allows |
| essentials_ip_verified       | bool | true  | yes | true/singleplayer | On every join, if administrator verified ip user to only allows from those ip/name combination  |
| essentials_check_for_updates | bool | false | no  | false           | check raw data of git repo by check of version file content |

#### Commands and privilegies

| command & format       | mint/privs | Esse/privs |  description function   | observations            |
| ---------------------- | ---------- | ---------- | ----------------------- | ----------------------- |
| `/ip <name>`           | server     | server     | Show the IP of a player |  |
| `/broadcast <message>` | bring      | broadcast  | Send GLOBAL message in chat |  |
| `/speed <name>`        | rollback   | speed      | Sets a speed for an any player. |  |
| `/biome [<info_name>]` |            | biome/server | Shows the current(or provided name) biome info | If no assentials privs, any player wil be able, `biome/server` privilege will provide more info |
| `/seed`                | rollback   | seed       | Shows the seed number of the server world | If no assentials privs, any player wil be able, `biome` privilege works if confg params are set, otherwise admin only |
| `/god [<name>]`        | noclip     | god_mode   | Enable the god mode for current or given player | `enable_damage` enabled only of course |
| `/ban_menu`            | ban        | ban        | Open the ban menu | Requires GUI sfind/ui  |
| `/kick_menu`           | kick       | kick       | Open the kick menu | Requires GUI sfind/ui  |
| `/mute_menu`           | mute       | mute       | Open the mute menu | Requires GUI sfind/ui  |
| `/getpos <name>`       | teleport   | get_pos    | Allows the player to find out the position of another player |  |
| `/kill <name>`         | protection_bypass | kill  | Kill anyone with command. |  | Check `essentials_killed_by` |
| `/heal [<name>]`       | rollback   | heal       | Heals full health for a player. | Check `essentials_changed_by` |


## LICENSE

* MIT

Author and creator of the mod:

* Copyright (C) 2024 SkyBuilder1717 MIT

Contributors:

* Copyright (C) 2024 mckaygerhard

see [LICENSE](LICENSE) file.

Media:

* textures/*.png - Copyright (C) 2024 SkyBuilder1717
* sounds/*.png - Copyright (C) 2024 SkyBuilder1717
