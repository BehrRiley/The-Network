# | ███████████████████████████████████████████████████████████
# % ██    /gmsp - gamemode spectator command
# | ██
# % ██  [ Command ] ██
Hat_Command:
    type: command
    name: hat
    debug: true
    description: Places a held item as a hat
    usage: /hat
    permission: behrry.essentials.hat
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - if <player.item_in_hand.material.name> == air:
            - narrate format:Colorize_Red "No item in hand."
            - stop
        - if <player.equipment.helmet.material.name> != air:
            - narrate format:Colorize_Red "You must remove your current hat first."
            - stop
        - equip <player> head:<player.item_in_hand.with[quantity=1]>
        - take iteminhand quantity:1
