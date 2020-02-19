# | ███████████████████████████████████████████████████████████
# % ██    /gms - gamemode Survival command
# | ██
# % ██  [ Command ] ██
gms_Command:
    type: command
    name: gms
    debug: false
    description: Adjusts your gamemode to Survival Mode.
    admindescription: Adjusts another players or your own gamemode to Survival Mode
    usage: /gms
    adminusage: /gms (Player)
    permission: behrry.essentials.gms
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - if !<player.has_Flag[behrry.essentials.tabofflinemode]>:
                - if <context.args.size||0> == 0:
                    - determine <server.list_online_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
            - else:
                - if <context.args.size||0> == 0:
                    - determine <server.list_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]||null> == null:
            - define User <player>
        - else:
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.get[1]>
                - inject Player_Verification Instantly
            - else:
                - inject Admin_Permission_Denied Instantly

        - if <[User].gamemode> == Survival:
            - if <[User]> == <player>:
                - narrate targets:<player> "<proc[Colorize].context[You are already in Survival Mode.|red]>"
            - else:
                - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already in Survival Mode.|red]>"
        - else:
            - if <[User]> != <player>:
                - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context['s Gamemode changed to:|red]> <&e>Survival"
            - else:
                - narrate targets:<[User]> "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Survival"
            - adjust <[User]> gamemode:Survival
