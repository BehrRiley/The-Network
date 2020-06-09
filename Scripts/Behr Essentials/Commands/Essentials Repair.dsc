Repair_Command:
    type: command
    name: Repair
    debug: false
    description: Repairs an item you're holding.
    admindescription: Repairs a held item or all items in an inventory.
    usage: /repair
    adminusage: /repair
    permission: Behr.Essentials.Repair
    adminpermission: Behr.Essentials.Repair.All
    tab complete:
        - if <player.has_permission[Behr.Essentials.Repair]>:
            - define Args <list[All]>
            - inject OneArg_Command_Tabcomplete
    script:
    # @ ██ [ Check for args ] ██
        - if !<context.args.is_empty>:
            # @ ██ [ Run as Moderator ] ██
            - inject Admin_Verification
            - if <context.args.size> > 1:
                - inject Command_Syntax Instantly
            
        # @ ██ [ Check if All ] ██
            - if <context.args.get[1]> == all:
                - foreach <player.inventory.list_contents> as:Item:
                    - if !<[Item].repairable>:
                        - foreach next
                    - if <[item].durability> == 0:
                        - foreach next
                    - inventory adjust slot:<[Loop_Index]> durability:0
                    - define Count:++
            - if <[Count]> == 0:
                - narrate format:colorize_yellow "No items to repair."
            - else:
                - narrate "<proc[Colorize].context[Items Repaired:|green]> <&e><[Count]>"
        
        # @ ██ [ Run as Self ] ██
        - else:
            # $ ██ [ To-Do: Determine Different based on Sponsor Levels ] ██
            ##@ Check if player has flags
            #- if !<player.has_flag[Behr.Essentials.Repair.Limit]>:
            #    - flag player Behr.Essentials.RepairLimit:3
            #- if !<player.has_Flag[Behr.Essentials.Repair.Cooldown]>:
            #    - flag player Behr.Essentials.RepairLimit:0

            ##@ Check Flags
            #- if <player.flag[Behr.Essentials.Repair.Cooldown]||0> > <player.flag[Behr.Essentials.Repair.Limit]>:
            #    - narrate "Repair Limit Cooldown"
            #    - stop
            
            #@ Check Item
            - if <player.item_in_hand.max_durability||null> == null:
                - define Reason "Item cannot be repaired."
                - inject Command_Error
            
            #@ Repair Item
            - define Item <player.item_in_hand>
            - take iteminhand
            - give <[Item].with[durability=0]>
            