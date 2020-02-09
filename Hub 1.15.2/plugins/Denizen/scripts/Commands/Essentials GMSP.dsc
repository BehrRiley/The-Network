# | ███████████████████████████████████████████████████████████
# % ██    /gmsp - gamemode spectator command
# | ██
# % ██  [ Command ] ██
GMSP_Command:
    type: command
    name: gmsp
    debug: false
    description: Adjusts your gamemode to Spectator Mode.
    admindescription: Adjusts another player's or your own gamemode to Spectator Mode
    usage: /gmsp
    adminusage: /gmsp (Player)
    permission: behrry.essentials.gmsp
    adminpermission: behrry.essentials.gmsp.others
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - if !<player.has_Flag[behrry.essentials.tabofflinemode]>:
                - if <context.args.size||0> == 0:
                    - determine <server.list_online_players.parse[name]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
            - else:
                - if <context.args.size||0> == 0:
                    - determine <server.list_players.parse[name]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly

        - if <context.args.get[1]||null> == null:
            - if <player.gamemode> == Spectator:
                - narrate "<proc[Colorize].context[You are already in Spectator Mode.|red]>"
            - else:
                - narrate "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Spectator"
                - adjust <player> gamemode:Spectator
        - else:
            - if <player.has_flag[Moderation]>:
                - define User <context.args.get[1]>
                - inject Player_Verification
                - if <[User].gamemode> == Spectator:
                    - narrate "<[User].name.display]> <proc[Colorize].context[is already in Spectator Mode.|red]>"
                - else:
                    - narrate targets:<player> "<&e><[User].name><&2>'<&a>s <proc[Colorize].context[gamemode changed to:|green]> <&e>Spectator"
                    - narrate targets:<[User]> "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Spectator"
                    - adjust <[User]> gamemode:Spectator
            - else:
                - inject Admin_Permission_Denied Instantly