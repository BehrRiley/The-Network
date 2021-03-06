gmsp_Command:
    type: command
    name: gmsp
    debug: false
    description: Adjusts your gamemode to Spectator Mode.
    admindescription: Adjusts another player's or your own gamemode to Spectator Mode
    usage: /gmsp
    adminusage: /gmsp (Player)
    permission: Behr.Essentials.GMSP
    adminpermission: Behr.Essentials.GMSP.Others
    tab complete:
        - if <player.has_flag[Behr.Essentials.GMS.Others]>:
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
        - if <[User].gamemode> == Spectator:
            - if <[User]> == <player>:
                - narrate "<proc[Colorize].context[You are already in Spectator Mode.|red]>"
            - else:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already in Spectator Mode.|red]>"
        - else:
            - if <[User]> != <player>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context['s Gamemode changed to:|red]> <&e>Spectator"
            - narrate targets:<[User]> "<proc[Colorize].context[Gamemode changed to:|green]> <&e>Spectator"
            - adjust <[User]> gamemode:Spectator
