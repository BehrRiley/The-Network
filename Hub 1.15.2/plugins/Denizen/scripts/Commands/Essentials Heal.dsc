# | ███████████████████████████████████████████████████████████
# % ██    /gmsp - gamemode spectator command
# | ██
# % ██  [ Command ] ██
Heal_Command:
    type: command
    name: heal
    debug: false
    description: Heals a player
    usage: /heal
    permission: behrry.essentials.heal
    script:
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]||null> == null:
            - heal <player>
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification
            - heal <[User]>