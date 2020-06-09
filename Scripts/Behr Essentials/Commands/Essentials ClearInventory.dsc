ClearInventory_Command:
    type: command
    name: clearinventory
    debug: false
    usage: /clearinventory
    description:
    admindescription: Clears yours, or another player's inventory
    permission: Behr.Essentials.ClearInventory
    adminpermission: Behr.Essentials.ClearInventory.Others
    aliases:
        - clearinv
        - invclear
    tab complete:
        - if <player.has_permission[Behr.Essentials.ClearInventory.Others]>:
            - define blacklist <player>
            - inject Online_Player_Tabcomplete
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly

    # @ ██ [  Check User ] ██
        - if <context.args.is_empty>:
            - define User <player>
        - else:
            - inject Admin_Verification
            - define User <context.args.get[1]>
            - inject Player_Verification
        
    # @ ██ [  Clear Inventory ] ██
        - if <[User]> != <player>:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Inventory Cleared.|green]>"
        - narrate targets:<[User]> format:Colorize_Green "Inventory Cleared."
        - inventory clear d:<[User].inventory>
