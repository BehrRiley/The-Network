World_Handler:
    type: world
    debug: false
    events:
        on player places wither_skeleton_skull|tnt|bedrock|end_crystal|ender_chest:
            - if <player.gamemode> == Creative:
                - if <player.name> != Behr_Riley:
                    - determine cancelled
        on world command:
            - if <context.args.get[1]> == creative && <player.has_flag[Behrry.Moderation.CreativeBan]>:
                - narrate format:Colorize_Red "You are currently Creative-Banned."
                - determine cancelled
        on player changes world to creative:
            - if <player.has_flag[Behrry.Moderation.CreativeBan]>:
                - wait 1t
                - narrate format:Colorize_Red "You are currently Creative-Banned."
                - teleport <player> <location[0,200,0,world]>
            - if !<player.in_group[Moderation]>:
                - adjust <player> gamemode:Creative
        on player changes world to World:
            - if !<player.in_group[Moderation]>:
                - adjust <player> gamemode:Survival
        on server prestart:
            - createworld Hub
            - createworld Runescape50px1
            - createworld Creative