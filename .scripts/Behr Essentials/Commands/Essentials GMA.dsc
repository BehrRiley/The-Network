gma_Command:
    type: command
    name: gma
    debug: false
    description: Adjusts your gamemode to Adventure Mode.
    admindescription: Adjusts another player's or your own gamemode to Adventure Mode
    usage: /gma
    adminusage: /gma (Player)
    permission: Behr.Essentials.GMA
    adminpermission: Behr.Essentials.GMA.Others
    tab complete:
        - if <player.has_flag[Behr.Essentials.GMA.Others]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check if specifying Player ] ██
        - if <context.args.is_empty>:
            - define User <player>
        - else:
        # @ ██ [  Check if player is a moderator ] ██
            - inject Admin_Verification
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly

    # @ ██ [  Check User's Gamemode ] ██
        - if <[User].gamemode> == Adventure:
            - if <[User]> == <player>:
                - narrate "<proc[Colorize].context[You are already in Adventure Mode.|red]>"
            - else:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already in Adventure Mode.|red]>"
        - else:
            - if <[User]> != <player>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context['s Gamemode changed to:|red]> <&e>Adventure"
            - narrate targets:<[User]> "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Adventure"
            - adjust <[User]> gamemode:Adventure
