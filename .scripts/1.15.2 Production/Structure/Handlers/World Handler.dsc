World_Handler:
    type: task
    debug: false
    events:
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