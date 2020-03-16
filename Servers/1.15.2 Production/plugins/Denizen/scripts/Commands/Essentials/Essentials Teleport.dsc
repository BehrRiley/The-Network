Teleport_Command:
    type: command
    name: teleport
    debug: false
    description: Teleports you to the first player, or the first player to the second.
    usage: /teleport <&lt>PlayerName<&gt>
    adminusage: /teleport <&lt>PlayerName<&gt> (<&lt>PlayerName<&gt>)*
    permission: behrry.essentials.teleport
    aliases:
        - tp
        - tpa
    script:
        #@ Check args
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly

        #@ Check player arg
        - define User <context.args.get[1]>
        - inject Player_Verification Instantly

        #@ Check for multi-player teleporting
        - if <context.args.get[2]||null> == null:
            #@ Check if trying to teleport to self
            - if <[User]> == <player>:
                - define reason "You cannot teleport to yourself."
                - inject Command_Error Instantly
            #@ Check if Moderator, bypass
            - if <player.in_group[Moderation]>:
                - flag <Player> behrry.essentials.teleport.back:<player.location>
                - teleport <player> <[User].location>
                - narrate "<proc[Colorize].context[You were teleported to:|green]> <&r><[User].display_name>"
            - else:
            #@ Check if player is still requested
                - if <[User].flag[behrry.essentials.teleport.request].parse[before[/]].contains[<Player>]||false>:
                    - narrate format:Colorize_Red "Teleport request still pending."
                    - stop

                - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><proc[User_Display_Simple].context[<player>]>"
                - define DisplayA "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
                - define CommandA "tpaccept <player.name>"
                - define Accept <proc[MsgCmd].context[<def[hoverA]>|<def[displayA]>|<def[commandA]>]>
            
                - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
                - define DisplayB "<&c>[<&4><&chr[2716]><&c>]"
                - define CommandB "tpdecline <player.name>"
                - define Decline <proc[MsgCmd].context[<def[hoverB]>|<def[displayB]>|<def[commandB]>]>
            
                - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
                - define DisplayC "<&c>[<&4><&chr[2716]><&c>]"
                - define CommandC "tp <[User].name> Cancel"
                - define Cancel <proc[MsgCmd].context[<def[hoverC]>|<def[displayC]>|<def[commandC]>]>
            
                - flag <[User]> behrry.essentials.teleport.requesttype:->:<player>/teleportto duration:3m
                - flag <[User]> behrry.essentials.teleport.request:->:<player>/<[User].location> duration:3m

                - narrate targets:<[User]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[is requesting to teleport to you.|green]>"
                - narrate targets:<player> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <proc[User_Display_Simple].context[<[User]>]><&2>."
        - else:
            #@ Check if canceling
            - if <context.args.get[2]||null> == Cancel:
                - if <[User].has_flag[behrry.essentials.teleport.request]>:
                    - if <[User].flag[behrry.essentials.teleport.request].parse[before[/]].contains[<player>]>:
                        - narrate targets:<[User]>|<player> Format:Colorize_Green "Teleport request cancelled."
                        - define KeyValue <[User].flag[behrry.essentials.teleport.request].map_get[<player>]>
                        - flag <[User]> behrry.essentials.teleport.request:<-:<player>/<[KeyValue]>
                        - stop
                    - else:
                        - narrate Format:Colorize_Red "No teleport request found."
                        - stop
                - else:
                    - narrate Format:Colorize_Red "No teleport request found."
                    - stop

                - if <[User].has_flag[behrry.essentials.teleport.request]>:
                    - if <[User].flag[behrry.essentials.teleport.request].parse[before[/]].contains[<player>]>:
                        - narrate Format:Colorize_Red "Teleport request still pending."
                        - stop


#######################################################################################################
            #@ Check if a moderator
            - if !<player.in_group[Moderation]>:
                - inject Admin_Permission_Denied Instantly

            #@ Teleport multiple people to last player
            - foreach <context.raw_args.split[<&sp>].get[1].to[<context.args.size.sub[1]>]> as:User:
                - inject Player_Verification
                - if <[PlayerList].contains[<[User]>]||false>:
                    - define reason "<proc[Player_Display_Simple].context[<[User]>]> was entered more than once."
                    - inject Command_Error Instantly
                - if <[User]> == <player>:
                    - define reason "You cannot teleport to yourself."
                    - inject Command_Error Instantly
                - define PlayerList:->:<[User]>
            - define User <context.args.last>
            - inject Player_Verification
            - foreach <[PlayerList]> as:Player:
                - flag <[Player]> behrry.essentials.teleport.back:<[player].location>
                - teleport <[Player]> <[User].location>
                - narrate targets:<[Player]> "<proc[Colorize].context[You were teleported to:|green]> <&r><[User].display_name>"
            - if <[PlayerList].size> > 1:
                - define WasWere were
            - else:
                - define WasWere was
            - narrate targets:<[User]> "<[PlayerList].parse[display_name].formatted> <&r><proc[Colorize].context[<[WasWere]> teleported to you.|green]>"
