# | ███████████████████████████████████████████████████████████
# % ██    /invsee - see a player's current inventory
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | 
inventorysee_Command:
    type: command
    name: inventorysee
    debug: false
    description: Views another player's inventory
    aliases:
      - invsee
      - inv
    usage: /inventorysee <&lt>Player<&gt>
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - if !<player.has_flag[behrry.essentials.tabofflinemode]>:
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
        - if <context.args.get[1]||null> == null || <context.args.get[2]||null> != null:
            - inject Command_syntax instantly
        - define User <context.args.get[1]>
        - inject Player_Verification_Offline Instantly
        - if <[User]> != <player>:
            - inventory open d:<[User].inventory>
            - narrate "<&2>O<&a>pening <proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s inventory.|green]>"
        - else:
            - define Reason "You cannot edit your own inventory."
            - Inject Command_Error
