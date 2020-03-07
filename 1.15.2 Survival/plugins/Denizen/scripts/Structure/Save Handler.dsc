Save_Handler:
    type: world
    debug: false
    events:
        on system time minutely every:15:
            - if <server.list_online_players.size> == 0:
                - flag server behrry.essentials.save.playertrack:!
            - else:
                - execute as_server save-all