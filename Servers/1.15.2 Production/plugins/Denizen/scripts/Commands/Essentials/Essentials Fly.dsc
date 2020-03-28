# | ███████████████████████████████████████████████████████████
# % ██    /fly - Grants flight
# | ██
# % ██  [ Command ] ██
Fly_Command:
    type: command
    name: fly
    debug: false
    description: Grants Flight
    usage: /fly (player) (on/off)
    permission: Behrry.Essentials.Fly
    tab complete:
        - inject Online_Player_Tabcomplete Instantly
    script:
        - if <context.args.size> > 2:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]||null> == null:
            - define User <player>
            - define Toggle <player.can_fly.not>
        - else:
            - if <list[On|Off].contains[<context.args.get[1]>]>:
                - if <context.args.get[2]||null> == null:
                    - define User <Player>
                    - if <context.args.get[1]> == on:
                        - define Toggle True
                    - else:
                        - define Toggle False
                - else:
                    - inject Command_Syntax Instantly
            - else:
                - define User <context.args.get[1]>
                - inject Player_Verification Instantly
                - if <context.args.get[2]||null> != null:
                    - if <list[On|Off].contains[<context.args.get[2]>]>:
                        - if <context.args.get[2]> == on:
                            - define Toggle True
                        - else:
                            - define Toggle False
                    - else:
                        - inject Command_Syntax Instantly
                - else:
                    - define Toggle <[User].can_fly.not>
        - if <[User].can_fly>:
            - if <[Toggle]> == False:
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Flight mode:|green]> <&e>Disabled"
                - narrate targets:<[User]> "<proc[Colorize].context[Flight mode:|green]> <&e>Disabled"
                - adjust <[User]> can_fly:false
            - else:
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Flight mode is already on.|yellow]>"
                - else:
                    - narrate targets:<[User]> "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - else:
            - if <[Toggle]> == True:
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Flight mode:|green]> <&e>Enabled"
                - narrate targets:<[User]> "<proc[Colorize].context[Flight mode:|green]> <&e>Enabled"
                - adjust <[User]> can_fly:true
            - else:
                - if <[User]> != <player>:
                    - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Flight mode is not on.|yellow]>"
                - else:
                    - narrate targets:<[User]> "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
