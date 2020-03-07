# | ███████████████████████████████████████████████████████████
# % ██     Essentials Main Structure
# | ██
# % ██    [ Chat Management ] ██
# $ ██    [ To-Do ]                     ██
Essentials:
    type: world
    debug: false
    events:
        on system time hourly:
            - execute as_server "acball 100"
        #on restart command:
        #    - bungeeexecute "send <bungee.server> MainHub"
        on player clicks block in:golden_shovel:
            #- if <context.location> == <location[29,64,197,Bees]>:
            - if <player.inventory.list_contents.parse[material.name].contains[golden_shovel]>:
                - stop
            - else:
                - give i@golden_shovel
                - execute as_op "claimbook <player.name>"
        on hanging breaks because obstruction:
                - determine cancelled
        on player right clicks Composter:
            - if <context.location.material.level> == 8 && <player.world.name> == Gielinor:
                - determine cancelled
        on player kicked:
            - if <context.reason> == "Illegal characters in chat":
                - determine cancelled
        on player dies:
            - flag player behrry.essentials.teleport.deathback:<player.location>
            - define key Behrry.Essentials.Cached_Inventories
            - define YamlSize <yaml[<player>].read[<[Key]>].size||0>
            - define UID <yaml[<player>].read[<[Key]>].get[<[YamlSize]>].before[Lasagna]||0>
            - if <[YamlSize]> > 9:
                - foreach <yaml[<player]>].read[<[Key]>].get[1].to[<[YamlSize].sub[9]>]>:
                    - yaml id:<player> set <[Key]>:<-:<[Value]>
            - yaml id:<player> set <[Key]>:->:<[UID].add[1]>Lasagna<player.inventory.list_contents>
            - yaml id:<player> savefile:data/pData/<player.uuid>.yml
        on player respawns:
            - if <player.flag[settings.essentials.bedspawn]||false> == true:
                - determine passively <player.bed_spawn>
            - else:
                - determine passively <player.world.spawn_location>
        on pl command:
            - determine passively fulfilled
            - narrate "Plguins (4): <&a>BehrEdit<&f>, <&a>BehrryEssentials<&f>, <&a>Citizens<&f>, <&a>Denizen<&f>"
        on resource pack status:
            #- narrate targets:<server.match_player[behr]> "<context.status>"
            - if <context.status> == accepted:
                - flag player Resource_Accepted duration:40s
            - if <context.status> == declined:
                - narrate "<&c>You must accept the resource pack. This does not affect textures - only moderation font specs."
                - wait 1s
                - narrate "<&c>Kicking in 25 seconds - please accept resource pack."
                - title "title:<&4>Warning" "subtitle:<&c>Please accept resource pack."
                - actionbar "<&4>This resource pack does not change game textures."
                - wait 5s
                - narrate "<&c>Tip: Edit Server > Server Resource Packs: ENABLED"
                - wait 20s
                - if !<server.has_flag[behrry.essentials.resourcecheckspam.<player>]>:
                    - flag server behrry.essentials.resourcecheckspam.<player> duration:1m
                    - announce format:Colorize_yellow "Player declined resource pack."
                - if <player.has_flag[Resource_Accepted]>:
                    - stop
                - kick <player> "reason:Must accept resource pack. This does not affect textures."
        on player changes gamemode:
            - if <player.has_flag[gamemode.inventory.changebypass]>:
                - flag player gamemode.inventory.changebypass:!
            - else:
                - flag player gamemode.inventory.<player.gamemode>:!|:<player.inventory.list_contents>
            - inventory clear
            - if <player.has_flag[gamemode.inventory.<context.gamemode>]>:
                - inventory set d:<player.inventory> o:<player.flag[gamemode.inventory.<context.gamemode>].as_list>
            - else:
                - flag player gamemode.inventory.<context.gamemode>:<player.inventory.list_contents>
        #on player damages player:
        #    - if <context.entity.gamemode||null> == creative:
        #        - if !<context.entity.has_flag[smacked]>:
        #            - define vector <context.entity.location.sub[<context.damager.location>].normalize.mul[0.5]>
        #            - adjust <context.entity> velocity:<def[vector].x>,0.4,<def[vector].z>
        #            - flag <context.entity> smacked duration:0.45s
        #        - playeffect effect:EXPLOSION_NORMAL at:<context.entity.location.add[0,1,0]> visibility:50 quantity:10 offset:0.5
        #        - playeffect effect:EXPLOSION_LARGE at:<context.entity.location.add[0,1,0]> visibility:50 quantity:1 offset:0.5