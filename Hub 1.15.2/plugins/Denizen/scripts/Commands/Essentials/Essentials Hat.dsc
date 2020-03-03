# | ███████████████████████████████████████████████████████████
# % ██    /gmsp - gamemode spectator command
# | ██
# % ██  [ Command ] ██
Hat_Command:
    type: command
    name: hat
    debug: false
    description: Places a held item as a hat
    usage: /hat
    permission: behrry.essentials.hat
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - if <player.item_in_hand.material.name> == air:
            - narrate "<proc[Colorize].context[No item in hand.|red]>"
            - stop
        - if <player.equipment.helmet.material.name> != air:
            - narrate "<proc[Colorize].context[You must remove your current hat first.|red]>"
            - stop
        - equip <player> head:<player.item_in_hand.with[quantity=1]>
        - take <player.item_in_hand> quantity:1
