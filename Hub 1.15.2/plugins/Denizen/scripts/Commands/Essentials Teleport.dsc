teleport_Command:
    type: command
    name: teleport
    debug: false
    description: Teleports you to the first player, or the first player to the second.
    usage: /teleport <&lt>PlayerName<&gt> (<&lt>PlayerName<&gt>)*
    permission: behrry.essentials.teleport
    aliases:
        - tp
    script:
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        - if <context.args.get[2]||null> == null:
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly
            - if <[User]> == <player>:
                - define reason "You cannot teleport to yourself."
                - inject Command_Error Instantly
            - else:
                - teleport <player> <[User].location>
        - else:
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
                - teleport <[Player]> <[User].location>
                - narrate targets:<[Player]> "<proc[Colorize].context[You were teleported to:|green]> <&r><[User].name.display>"
            - if <[PlayerList].size> > 1:
                - define WasWere were
            - else:
                - define WasWere was
            - narrate targets:<[User]> "<[PlayerList].parse[name.display].formatted> <&r><proc[Colorize].context[<[WasWere]> teleported to you.|green]>"
