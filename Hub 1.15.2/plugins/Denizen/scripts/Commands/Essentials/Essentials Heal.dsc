# | ███████████████████████████████████████████████████████████
# % ██    /gmsp - gamemode spectator command
# | ██
# % ██  [ Command ] ██
Heal_Command:
    type: command
    name: heal
    debug: false
    description: Heals a player
    usage: /heal (player)
    permission: behrry.essentials.heal
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
        #@ Verify args
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        
        #@ Check if self or player named
        - if <context.args.get[1]||null> == null::
            - define User <player>
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[was healed.|green]>"
        - heal <[User]>
        - narrate targets:<[User]> format:Colorize_Green "You were healed."
