# | ███████████████████████████████████████████████████████████
# % ██    /groundclean - returns you to where you teleported from
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script, create out of combat bypass | cooldown | Bypass monsters near
groundclean_Command:
    type: command
    name: groundclean
    debug: false
    description: Cleans the ground of dropped items.
    usage: /groundclean
    permission: behrry.essentials.groundclean
    aliases:
        - cleanground
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - define Entities <player.location.find.entities[DROPPED_ITEM].within[250]>
        - remove <[Entities]>
        - narrate "<proc[Colorize].context[Removed:|green]><&e> <[Entities].size> entities"