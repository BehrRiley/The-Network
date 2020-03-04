# | ███████████████████████████████████████████████████████████
# % ██    /gmsp - gamemode spectator command
# | ██
# % ██  [ Command ] ██
Hunger_Command:
    type: command
    name: hunger
    debug: false
    description: hungers a player
    usage: /hunger (player)
    permission: behrry.essentials.hunger
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]||null> == null:
            - define User <player>
            - define Arg <context.args.get[1]>
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification
            - define Arg <context.args.get[2]>
        
        - if !<[arg].is_integer>:
            - narrate format:Colorize_Red "Hunger must be a number."
            - stop
        - if <[arg]> > 20:
            - narrate format:Colorize_Red "Hunger must be less than 20."
            - stop
        - if <[arg]> < 0:
            - narrate format:Colorize_Red "Hunger must be between 0-20."
            - stop
        - if <[arg].contains[.]>:
            - narrate format:Colorize_Red "Hunger cannot be a decimal."
            - stop

        - adjust <[User]> food_level:<[Arg]>