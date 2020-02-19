# | ███████████████████████████████████████████████████████████
# % ██    /tpdecline - Declines a teleport request
# | ██
# % ██  [ Command ] ██
TPDecline_Command:
    type: command
    name: tpdecline
    debug: true
    description: Declines a teleport request sent to you.
    usage: /tpdecline (<&lt>Player<&gt>)
    permission: behrry.essentials.tpdecline
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_online_players.parse[name].exclude[<player.name>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly

        - if <player.has_flag[behrry.essentials.teleport.request]>:
            - if <context.args.get[1]||null> == null:
                - define User <player.flag[behrry.essentials.teleport.request].get[1].before[/]>
                - define Loc <player.flag[behrry.essentials.teleport.request].get[1].after[/]>
            - else:
                - define User <context.args.get[1]>
                - inject Player_Verification_Offline Instantly
                - if <player.flag[behrry.essentials.teleport.request].parse[before[/]].contains[<[User]>]>:
                    - define Loc <player.flag[behrry.essentials.teleport.request].map_get[<[User]>]>
                - else:
                    - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                    - stop

            - flag <player> behrry.essentials.teleport.request:<-:<[User]>/<[Loc]>

            - narrate targets:<player> "<proc[Colorize].context[Teleport request declined.|green]>"
            - narrate targets:<[User]> "<proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[declined your teleport request.|green]>"
        - else:
            - narrate "<proc[Colorize].context[No teleport request found.|red]>"