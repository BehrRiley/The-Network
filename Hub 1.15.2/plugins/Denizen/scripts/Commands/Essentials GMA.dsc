# | ███████████████████████████████████████████████████████████
# % ██    /gma - gamemode adventure command
# | ██
# % ██  [ Command ] ██
GMA_Command:
    type: command
    name: gma
    debug: false
    description: Adjusts your gamemode to Adventure Mode.
    admindescription: Adjusts another player's or your own gamemode to Adventure Mode
    usage: /gma
    adminusage: /gma (Player)
    permission: behrry.essentials.gma
    adminpermission: behrry.essentials.gma.others
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
        - if <context.args.get[2]||null> == null:
            - if <context.args.get[1]||null> == null:
                - if <player.gamemode> == adventure:
                    - narrate "<proc[Colorize].context[You are already in Adventure Mode.|red]>"
                - else:
                    - narrate "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Adventure"
                    - adjust <player> gamemode:adventure
            - else:
                - if <player.has_flag[Moderation]>:
                    - define User <context.args.get[1]>
                    - inject Player_Verification
                    - if <[User].gamemode> == adventure:
                        - narrate "<[User].name.display]> <proc[Colorize].context[is already in Adventure Mode.|red]>"
                    - else:
                        - narrate targets:<player> "<&e><[User].name><&2>'<&a>s <proc[Colorize].context[gamemode changed to:|green]> <&e>Adventure"
                        - narrate targets:<[User]> "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Adventure"
                        - adjust <[User]> gamemode:adventure
                - else:
                    - inject Admin_Permission_Denied Instantly
        - else:
            - if <context.args.get[3]||null> == null:
                - if <server.flag[behrry.essentials.gamemoderequest.creative.open]>:
            - else:
                - inject Command_Syntax Instantly


# | ███████████████████████████████████████████████████████████
# % ██    /gmr gamemode (open/close)/(true/false)/(on/off)
# | ██
# % ██  [ Command ] ██
GMR_Command:
    type: command
    name: gmr
    debug: false
    description: turns on or off gamemode requesting for the specific gamemode
    usage: /gmr <&lt>Gamemode<&gt> (On/Off) (Time)
    permission: behrry.essentials.gmr
    tab complete:
        - define Arg1 <list[Adventure|Creative|Survival|Spectator]>
        - define Arg2 <list[On|Off]>
        - define Arg3 <list[S|M|H]>
        #/command█
        - if <context.args.size||0> == 0:
            - determine <[Arg1]>
        #/command█X
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg1].filter[starts_with[<context.args.get[1]>]]>
        #/command█X█
        - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg2]>
        #/command█X█X
        - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg2].filter[starts_with[<context.args.get[1]>]]>
        #/command█X█X█
        - else if <context.args.size> == 2 && <context.raw_args.ends_with[<&sp>]>:
            - determine "#"
        #/command█x█x█x
        - else if <context.args.size> == 3 && !<context.raw_args.ends_with[<&sp>]>:
            - if <context.args.get[3].is_integer>:
                - stop
            - else:
                - determine <[Arg3]>
    script:
        #-!!!!!!!!!!!!!!!!!!INCOMPLETE AAAAAAAAA!!!!!!!!!!!!!!!!!!-#
        # - argcheck !4  /c [1] [2] [3] [?]
        - if <context.args.get[4]||null> != null:
            - inject Command_Syntax Instantly
        # - argcheck 1 - Gamemode   /c [?]
        - if <context.args.get[1]||null> != null:
            - if <list[Adventure|Creative|Survival|Spectator].contains[<context.args.get[1]>]>:
                - define Gamemode <context.args.get[1]>
            - else:
                - inject Command_Syntax Instantly
        - else:
            - inject Command_Syntax Instantly
            
        # - argcheck 2 - Toggle or time?   /c [1] [?]
        - if <context.args.get[2]||null> != null:
            - if <list[Open|Close|True|False|On|Off].contains[<context.args.get[2]>]>:
                - choose <context.args.get[2]>:
                    - case Open|True|On
                        - define Toggle TRUE
                    - case Close|False|Off
                        - define Toggle FALSE
            - else:
                - inject Command_Syntax Instantly
                - define Measurement <context.args.get[3].char_at[<context.args.get[3].length>]>
                - define Duration <context.args.get[3].before[<[Measurement]>]>:
                - if <[Duration].is_integer> && <list[S|M|H].contains[<[Measurement]>]>:
                    - define Time <duration[<[Duration]><[Measurement]>]>
                - else:
                    - Inject Command_Syntax Instantly
                    
        # - argcheck 3 - time
        - if <context.args.get[3]||null> != null:
            - define Measurement <context.args.get[3].char_at[<context.args.get[3].length>]>
            - define Duration <context.args.get[3].before[<[Measurement]>]>:
            - if <[Duration].is_integer> && <list[S|M|H].contains[<[Measurement]>]>:
                - define Time <duration[<[Duration]><[Measurement]>]>

        - else:
            - if <server.has_flag[behrry.essentials.gamemoderequest.<[Gamemode]>.open]>:
                - define Toggle FALSE
            - else:
                - define Toggle TRUE

