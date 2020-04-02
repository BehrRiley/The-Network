World_Handler:
    type: world
    debug: false
    events:
        on player places wither_skeleton_skull|tnt|bedrock|end_crystal:
            - if <player.gamemode> == Creative:
                - if <player.name> != Behr_Riley:
                    - determine cancelled
        on player changes world to creative:
            - if !<player.in_group[Moderation]>:
                - adjust <player> gamemode:Creative
        on player changes world to World:
            - if !<player.in_group[Moderation]>:
                - adjust <player> gamemode:Survival
        on server prestart:
            - createworld Hub
            - createworld Runescape50px1
            - createworld Creative
        #player changes world to Creative:
        #    #- if !<player.in_group[Moderator]>:
        #    - flag player behrry.essentials.teleport.worldbackgamemode:<player.gamemode>
        #    - adjust <player> gamemode:Creative
        #player changes world from Creative:
        #    #- if !<player.in_group[Moderator]>:
        #    - adjust <player> gamemode:<player.flag[behrry.essentials.teleport.worldback]||Survival>