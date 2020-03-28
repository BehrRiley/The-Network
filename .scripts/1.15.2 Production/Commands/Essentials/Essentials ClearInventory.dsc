ClearInventory_Command:
    type: command
    name: clearinventory
    debug: false
    description: Clears yours, or another player's inventory
    usage: /clearinventory
    permission: behrry.essentials.clearinventory
    aliases:
        - clearinv
        - invclear
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_players.parse[name].exclude[<player.name>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly

    # @ ██ [  Check User ] ██
        - if <context.args.get[1]||null> == null:
            - define User <player>
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification
        
    # @ ██ [  Clear Inventory ] ██
        - if <[User]> != <player>:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Inventory Cleared.|green]>"
        - narrate targets:<[User]> format:Colorize_Green "Inventory Cleared."
        - inventory set d:<[User].inventory> o:<inventory[Blank_Inventory]>
