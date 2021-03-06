Heal_Command:
    type: command
    name: heal
    debug: false
    description: Heals a player
    usage: /heal (player)
    permission: Behr.Essentials.Heal
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
    # @ ██ [  Verify args ] ██
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check if self or player named ] ██
        - if <context.args.is_empty>:
            - define User <player>
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification
            - if <[User]> != <player>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was healed.|green]>"
        
    # @ ██ [  Heal Player ] ██
        - heal <[User]>
        - adjust <[User]> food_level:20
        - narrate targets:<[User]> format:Colorize_Green "You were healed."
