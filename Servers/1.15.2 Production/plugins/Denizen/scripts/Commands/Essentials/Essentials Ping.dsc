Ping_Command:
    type: command
    name: ping
    debug: false
    description: shows yours, or another player's ping
    usage: /ping (player)
    permission: behrry.essentials.ping
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check if specifying another User ] ██
        - if <context.args.get[1]||null> == null:
            - narrate "<proc[Colorize].context[Current Ping:|green]> <&e><Player.ping>"
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly
            - narrate "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Current Ping:|green]> <&e><[User].ping>"