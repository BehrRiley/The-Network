Login_Handler:
    type: world
    debug: false
    events:
        on player logs in:
            - flag server behrry.essentials.save.playertrack:++
            #@ Displayname
            - wait 1s
            - if <player.has_flag[behrry.essentials.display_name]>:
                - adjust <player> display_name:<player.flag[behrry.essentials.display_name]>
            - if <player.in_group[Silent]>:
                - while !<player.groups.contains[Public]>:
                    - execute as_server "upc addgroup <player.name> Public"
                    - wait 5t
        on player quits:
            - flag player behrry.chat.lastreply:!