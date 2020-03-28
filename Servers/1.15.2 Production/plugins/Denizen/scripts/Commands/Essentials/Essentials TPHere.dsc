TPHere_Command:
    type: command
    name: tphere
    debug: false
    description: Requests a player to teleport to you.
    usage: /tphere <&lt>Player<&gt> (Cancel)
    permission: behrry.essentials.tphere
    aliases:
        - tpahere
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].include[Everyone]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].include[Everyone].filter[starts_with[<context.args.get[1]>]]>
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[1]||null> == null || <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check if requesting Everyone ] ██
        - if <context.args.get[1]> == everyone:
            - foreach <server.list_online_players.exclude[<player>]> as:User:
            # @ ██ [  Reroute command for each player ] ██
                - execute as_player "tphere <[User].name>"
            - stop
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly

    # @ ██ [  Check if User is Player ] ██
        - if <[User]> == <player>:
            - narrate format:colorize_yellow "Nothing interesting happens."
            - stop

    # @ ██ [  Check second Arg ] ██
        - if <context.args.get[2]||null> != null:
        # @ ██ [  Check if canceling request ] ██
            - if <context.args.get[2]||null> != Cancel:
                - inject Command_Syntax Instantly
            - else:
            # @ ██ [  Check if player has request open ] ██
                - if <[User].has_flag[behrry.essentials.teleport.request]>:
                    - if <[User].flag[behrry.essentials.teleport.request].parse[before[/]].contains[<player>]>:
                        - narrate targets:<[User]>|<player> "<proc[Colorize].context[Teleport request cancelled.|green]>"
                        - define KeyValue <[User].flag[behrry.essentials.teleport.request].map_get[<player>]>
                        - flag <[User]> behrry.essentials.teleport.request:<-:<player>/<[KeyValue]>
                        - stop
                    - else:
                        - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                        - stop
                - else:
                    - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                    - stop

    # @ ██ [  Check if User is still queued a request ] ██
        - if <[User].has_flag[behrry.essentials.teleport.request]>:
            - if <[User].flag[behrry.essentials.teleport.request].parse[before[/]].contains[<player>]>:
                - narrate format:Colorize_Red "Teleport request still pending."
                - stop

    # @ ██ [  Format Buttons ] ██
        - define HoverA "<proc[Colorize].context[Teleport To:|Green]><&nl><proc[User_Display_Simple].context[<player>]>"
        - define DisplayA "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
        - define CommandA "tpaccept <player.name>"
        - define Accept <proc[MsgCmd].context[<def[hoverA]>|<def[displayA]>|<def[commandA]>]>
    
        - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
        - define DisplayB "<&c>[<&4><&chr[2716]><&c>]"
        - define CommandB "tpdecline <player.name>"
        - define Decline <proc[MsgCmd].context[<def[hoverB]>|<def[displayB]>|<def[commandB]>]>
    
        - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
        - define DisplayC "<&c>[<&4><&chr[2716]><&c>]"
        - define CommandC "tphere <[User].name> Cancel"
        - define Cancel <proc[MsgCmd].context[<def[hoverC]>|<def[displayC]>|<def[commandC]>]>
    
    # @ ██ [  Adjust Flags ] ██
        - flag <[User]> behrry.essentials.teleport.request:->:<player>/<player.location> duration:3m

    # @ ██ [  Print to Players ] ██
        - narrate targets:<[User]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[sent a Teleport Request.|green]>"
        - narrate targets:<player> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <proc[User_Display_Simple].context[<[User]>]><&2>."