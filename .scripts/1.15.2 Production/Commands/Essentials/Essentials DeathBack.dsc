# | ███████████████████████████████████████████████████████████
# % ██    DeathBack / DBack - similar to /Back, but returns you
# % ██    to your death location alternatively.
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | Add a click button to opt teleporting back to a dangerous location
deathback_Command:
    type: command
    name: deathback
    debug: false
    description: Returns you back your death location.
    permission: behrry.essentials.dback
    usage: /deathback
    aliases:
        - dback
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly

    # @ ██ [  Check if player has death-back ] ██
        - if !<player.has_flag[Behrry.Essentials.Teleport.DeathBack]>:
            - narrate format:Colorize_Red "No death location to return to."
            - stop
        
    # @ ██ [  Teleport Player ] ██
        - narrate format:Colorize_Green "Returning to death location."
        - flag <player> behrry.essentials.teleport.back:<player.location>
        - teleport <player> <player.flag[Behrry.Essentials.Teleport.DeathBack].as_location>
