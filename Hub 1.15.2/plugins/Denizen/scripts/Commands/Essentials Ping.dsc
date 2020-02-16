# | ███████████████████████████████████████████████████████████
# % ██    /ping - shows your ping
# | ██
# % ██  [ Command ] ██
Ping_Command:
    type: command
    name: ping
    debug: false
    description: shows yours, or another player's ping
    usage: /ping
    permission: behrry.essentials.ping
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_online_players.parse[name].exclude[<player.name>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]||null> == null:
            - narrate "<proc[Colorize].context[Current Ping:|green]> <&e><Player.ping>"
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly
            - narrate "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Current Ping:|green]> <&e><[User].ping>"