# | ███████████████████████████████████████████████████████████
# % ██    /invsee - see a player's current inventory
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██
inventorysee_Command:
    type: command
    name: inventorysee
    debug: false
    description: Views another player's inventory
    usage: /inventorysee <&lt>Player<&gt>
    permission: behrry.essentials.inventorysee
    aliases:
      - invsee
      - inv
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
        - if <context.args.get[1]||null> == null || <context.args.get[2]||null> != null:
            - inject Command_syntax instantly
        - define User <context.args.get[1]>
        - inject Player_Verification_Offline Instantly
        - if <[User]> != <player>:
            - inventory open d:<[User].inventory>
            - narrate "<&2>O<&a>pening <proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s inventory.|green]>"
        - else:
            - define Reason "You cannot edit your own inventory."
            - Inject Command_Error
