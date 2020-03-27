Trade_Command:
    type: command
    name: trade
    debug: false
    description: Trades with a player
    usage: /trade (<&lt>Player<&gt> <&lt>Accept/Decline<&gt>)
    permission: behrry.essentials.trade
    script:
        #@ Check args
        - if <context.args.get[1]||null> == null:
            - if !<player.target.is_player||false>:
                - narrate format:colorize_red "Target is not a player."
                - stop
            - else:
                - define Target <player.target>
        - else if <context.args.size||0> != 2:
            - inject Command_Syntax Instantly

        - define Inventory1 <player.uuid>PlayerTradeInventory_<[Target].uuid>
        - define Inventory2 <[Target].uuid>PlayerTradeInventory_<player.uuid>

        - define SoftMenu <list[air|air|air|air|blank|air|air|air|air|air|air|air|air|accept_button|air|air|air|air|air|air|air|air|decline_button|air|air|air|air|air|air|air|air|blank|air|air|air|air]>
        - repeat 9:
            - define softmenu:|:<item[blank]>
        - note as:<[Inventory1]> <inventory[generic[size=45;contents=<[SoftMenu]>]]>
        - note as:<[Inventory2]> <inventory[generic[size=45;contents=<[SoftMenu]>]]>

        - inventory open d:<[Inventory1]>
        - inventory open d:<[Inventory2]> player:<[Target]>

Trade_Handler:
    type: world
    debug: false
    LeftinvSlots: 1|2|3|4|10|11|12|13|19|20|21|22|28|29|30|31
    RightInvSlots: 6|7|8|9|15|16|17|18|24|25|26|27|33|34|35|36
    BlankSlots: 37|38|39|40|41|32|42|43|44|45|5
    events:
        on player right clicks player:
            - if !<player.has_permission[test]>:
                - stop
            - if <player.is_sneaking>:
                - run Trade_Command path:script

        on player clicks in *PlayerTradeInventory*:
        #@ Define Definitions
            - define Target <player[<context.inventory.notable_name.after[_]>]>
            - define TargetInv <player[<[Target]>].open_inventory>
            - define LeftInv <script.yaml_key[LeftInvSlots].as_list>
            - define RightInv <script.yaml_key[RightInvSlots].as_list>
            - define i1 <context.item>
            - define i2 <context.cursor_item>
            - define NewSlot <context.slot.add[5]>
        
        #@ Check if clicking in other player's trade window
            - if <[RightInv].contains[<context.raw_slot>]>:
                - determine cancelled

        #@ Adjust Items within the player's trade window
            - if <script.yaml_key[LeftinvSlots].as_list.contains[<context.raw_slot>]>:
                #- item1 in inv
                #- item2 in hand
        #@ Check if the player accepted already
                - if <player.has_flag[behrry.essentials.trade.acceptedphase1]>:
                    - inject Locally AcceptIntercept
                - if <player.has_flag[behrry.essentials.trade.acceptedwaiting1]>:
                    - determine cancelled
        #@ Determine Click Actions
                - choose <context.action>:
        #@ Pickup Actions
                    - case "pickup_one":
                        - define Item <[i1].with[quantity=1]>
                        #- inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    - case "pickup_some":
                        #- define item <[i1].with[quantity=]>
                        - determine cancelled
                    - case "pickup_half":
                        - define Item <[i1].with[quantity=<[i1].quantity.div[2].round_up>]>
                        #- inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    - case "pickup_all":
                        - inventory set d:<[TargetInv]> o:air slot:<[NewSlot]>

        #@ Place Actions
                    - case "place_one":
                        - if <[i1].material.name> == <[i2].material.name>:
                            - define Item <[i2].with[quantity=<[i1].quantity.add[1]>]>
                        - else:
                            - define Item <[i2].with[quantity=1]>
                        - inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    - case "place_some":
                        #- define item <[i1].with[quantity=]>
                        - determine cancelled
                    - case "place_half":
                        - define Item <[i2].with[quantity=<[i2].quantity.div[2].round_down>]>
                        #- inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    - case "place_all":
                        - define Item <[i2]>
                        - inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    
        #@ Shift Key
                    - case "MOVE_TO_OTHER_INVENTORY":
                        - inventory set d:<[TargetInv]> o:air slot:<[NewSlot]>

        #@ Misc Options
                    - case "SWAP_WITH_CURSOR":
                        - adjust <player> item_on_cursor: <[i1]>
                        - inventory set d:<[TargetInv]> o:<[i2]> slot:<[NewSlot]>
                    - case "HOTBAR_SWAP":
                        - inventory set d:<[TargetInv]> o:<[i1]> slot:<[NewSlot]>
                    #- case "HOTBAR_MOVE_AND_READD":
                    #    - inventory set d:<[TargetInv]> o:<[i1]> slot:<[NewSlot]>
                    #- case "clone_stack":
                    #- case "collect_to_cursor":
                    - case "drop_one_slot":
                        - determine cancelled
                    - case "drop_one_cursor":
                        - determine cancelled
                    - case "drop_all_cursor":
                        - determine cancelled
                    - case "drop_all_slot":
                        - determine cancelled
                    #- case "UNKNOWN":
                    - case default:
                        - determine cancelled
        #@ Moving items from the player inventory
            - else:
                - Choose <context.action>:
                    - case "MOVE_TO_OTHER_INVENTORY":
                        - if <context.inventory.slot[<[LeftInv]>].parse[material.name].contains[air]>:
                            - determine passively cancelled
                            - define AirPocket <[LeftInv].get[<context.inventory.slot[<[LeftInv]>].parse[material.name].find[air]>]>
                            - inventory set d:<player.inventory> o:air slot:<context.slot>
                            - inventory set d:<context.inventory> o:<[i1]> slot:<[AirPocket]>
                            - inventory set d:<[TargetInv]> o:<[i1]> slot:<[AirPocket].add[5]>
                        - else:
                            - determine cancelled

            - inject InvDebugPrint instantly
            #@ Return to this to re-implement shift-clicking
            #- else if <context.click.contains[shift]>:
            #    - determine cancelled
        on player drops item:
            - if <player.has_flag[behrry.essentials.trade.cursorprotect]>:
                - determine passively cancelled
        on player drags in *PlayerTradeInventory*:
        #@ Define Definitions
            - define Target <player[<context.inventory.notable_name.after[_]>]>
            - define TargetInv <player[<[Target]>].open_inventory>
            - define LeftInv <script.yaml_key[LeftInvSlots].as_list>
            - define RightInv <script.yaml_key[RightInvSlots].as_list>
            - define i1 <context.item>
            - define NewSlots <context.slots.parse[add[5]]>

        #@ Check if other player has accepted already
            - if <player.has_flag[behrry.essentials.trade.acceptedphase1]>:
                - inject Locally AcceptIntercept
        #@ Check if player has accepted already
            - if <player.has_flag[behrry.essentials.trade.acceptedwaiting1]>:
                - Determine cancelled

        #@ Check if player clicked in the other player's trade window
            - if <[RightInv].contains_any[<context.raw_slots>]>:
                - determine cancelled
            
        #@ Check if player clicked in their trade window
            - if <[LeftInv].contains_any[<context.raw_slots>]>:
                #@ Dragging single quantity items
                - if <context.slots.size> == 1:
                    - inventory set d:<[TargetInv]> o:<[i1]> slot:<[NewSlots].get[1]>
                
                #- Check if left or right click
                #@ Dragging even quantity items -:LEFT:-
                - if <[i1].quantity.mod[2]> == <[NewSlots].size.mod[2]>:
                    - foreach <[NewSlots]> as:NewSlot:
                        - inventory set d:<[TargetInv]> o:<[i1].with[quantity=<[i1].quantity.div[<[NewSlots].size>]>]> slot:<[NewSlot]>
                - else:
                    - foreach <[NewSlots]> as:NewSlot:
                        - inventory set d:<[TargetInv]> o:<[i1].with[quantity=<[i1].quantity.sub[1].div[<[NewSlots].size>]>]> slot:<[NewSlot]>
            - inject InvDebugPrint2 instantly

        on player closes *PlayerTradeInventory*:
        #@ Define other player
            - define target <player[<context.inventory.notable_name.after[_]>]>

        #@ Prevent item dropping while on cursor
            - if <player.item_on_cursor.material.name> != air:
                - flag player behrry.essentials.trade.cursorprotect duration:1t
        #@ Remove flags
            - define Flags <list[acceptedphase1|acceptedwaiting1]>:
            - foreach <list[<Player>|<[Target]>]> as:Player:
                - foreach <[Flags]> as:Flag:
                    - if <player.has_flag[behrry.essentials.trade.<[Flag]>]>:
                        - flag <[Player]> behrry.essentials.trade.<[Flag]>:!
        #@ Check for duplicate
            - if <player.has_flag[behrry.essentials.trade.dedup]>:
                - stop

        #@ Define definitions
            - define target <player[<context.inventory.notable_name.after[_]>]>
            - define LeftInvSlots <script.yaml_key[LeftInvSlots].as_list>
            - define RightInvSlots <script.yaml_key[RightInvSlots].as_list>
            - define Inventory1 <player.uuid>PlayerTradeInventory_<[Target].uuid>
            - define Inventory2 <[Target].uuid>PlayerTradeInventory_<player.uuid>
            #- define PlayerInvC <player.open_inventory.slot[<[LeftInvSlots]>].exclude[<item[air]>].filter[script.name.starts_with[CONFIRM_BLANK].not]>
            #- define TargetInvC <player[<[Target]>].open_inventory.slot[<[LeftInvSlots]>].exclude[<item[air]>].filter[script.name.starts_with[CONFIRM_BLANK].not]>
            - define PlayerLoot <inventory[<[Inventory1]>].slot[<[LeftInvSlots]>]>
            - define TargetLoot <inventory[<[Inventory2]>].slot[<[LeftInvSlots]>]>

        #@ Adjust items
            - foreach <[PlayerLoot]> as:Loot:
                - if !<[Loot].script.name.contains[BLANK]||false> && <[Loot].material.name> != Air:
                    - give <[Loot]>
            - foreach <[TargetLoot]> as:Loot:
                - if !<[Loot].script.name.contains[BLANK]||false> && <[Loot].material.name> != Air:
                    - give <[Loot]> player:<[Target]>
            #- give <[PlayerInvC]>
            #- give <[TargetInvC]> player:<player[<[Target]>]>
            - flag <[Target]> behrry.essentials.trade.dedup duration:1t
            - inventory close player:<[Target]>
            - narrate format:Colorize_Red "Cancelled the trade."
            - narrate targets:<[Target]> format:Colorize_Red "<[Target].name> cancelled the trade."
        on player clicks Accept_Button in *PlayerTradeInventory*:
        #@ Define definitions
            - determine passively cancelled
            - define target <player[<context.inventory.notable_name.after[_]>]>
            - define LeftInvSlots <script.yaml_key[LeftInvSlots].as_list>
            - define RightInvSlots <script.yaml_key[RightInvSlots].as_list>
            - define Inventory1 <player.uuid>PlayerTradeInventory_<[Target].uuid>
            - define Inventory2 <[Target].uuid>PlayerTradeInventory_<player.uuid>
            #-.filter[script.name.starts_with[CONFIRM_BLANK].not]
            - define PlayerLoot <inventory[<[Inventory1]>].slot[<[RightInvSlots]>]>
            - define TargetLoot <inventory[<[Inventory2]>].slot[<[RightInvSlots]>]>
            - define BlankSlots <script.yaml_key[BlankSlots].as_list.exclude[5|32]>
            - flag player behrry.essentials.trade.acceptedwaiting1

        #@ Fun Flare while waiting
            - if <player.has_flag[behrry.essentials.trade.acceptedwaiting1]>:
                - foreach <[BlankSlots]> as:Slot:
                    - define RandomColor <list[red|orange|yellow|lime|light_blue|purple].random>
                    - inventory set d:<[Inventory1]> o:<item[<[RandomColor]>_stained_glass_pane].with[script=CONFIRM_BLANK0]> slot:<[Slot]>
                    - inventory set d:<[Inventory2]> o:<item[<[RandomColor]>_stained_glass_pane].with[script=CONFIRM_BLANK0]> slot:<[Slot]>
                    - wait 1t
                    - define RandomColor <list[red|orange|yellow|lime|light_blue|purple].random>
                    - inventory set d:<[Inventory1]> o:<item[<[RandomColor]>_stained_glass_pane].with[script=CONFIRM_BLANK0]> slot:<[Slot]>
                    - inventory set d:<[Inventory2]> o:<item[<[RandomColor]>_stained_glass_pane].with[script=CONFIRM_BLANK0]> slot:<[Slot]>
                    - wait 1t
                    - inventory set d:<[Inventory1]> o:<item[Confirm_Blank1]> slot:<[Slot]>
                    - inventory set d:<[Inventory2]> o:<item[Confirm_Blank1]> slot:<[Slot]>
                    - inventory update
            - else:
        #@ Check if the other player already accepted
                - if <[Target].has_flag[behrry.essentials.trade.acceptedwaiting1]>:
                    - inject Locally AcceptTrade Instantly
                    - stop
        #@ Add Flags and Define Definitions
                - flag player behrry.essentials.trade.acceptedwaiting1
                - flag player behrry.essentials.trade.acceptedphase1
                - flag <[Target]> behrry.essentials.trade.acceptedphase1
                
        #@ Flare locking the banner green
            - foreach <[BlankSlots]> as:Slot:
                - inventory set d:<[Inventory1]> o:<item[Confirm_Blank1]> slot:<[Slot]>
                - inventory set d:<[Inventory2]> o:<item[Confirm_Blank1]> slot:<[Slot]>
                - inventory update
                - if <[Loop_Index].mod[5]> != 0:
                    - wait 2t
            - foreach <context.inventory.slot[<[LeftInvSlots]>]> as:Item:
                - if <[Item].material.name> == air:
                    - inventory set d:<[Inventory1]> o:<item[Confirm_Blank0]> slot:<[LeftInvSlots].get[<[Loop_Index]>]>
                    
        #@ Lock the accepting player's inventory
            - foreach <context.inventory.slot[<[LeftInvSlots]>]> as:Item:
                - if <[Item].material.name> == air:
                    - inventory set d:<inventory[<[Inventory1]>]> o:<item[Confirm_Blank0]> slot:<[LeftInvSlots].get[<[Loop_Index]>]>
        #@ Show the other player the locked inventory
            - foreach <inventory[<[Inventory2]>].slot[<[RightInvSlots]>]> as:Item:
                - if <[Item].material.name> == air:
                    - inventory set d:<inventory[<[Inventory2]>]> o:<item[Confirm_Blank0]> slot:<[RightInvSlots].get[<[Loop_Index]>]>

        on player clicks Decline_Button in *PlayerTradeInventory*:
            - inventory close
        on player clicks Confirm_Blank* in *PlayerTradeInventory*:
            - determine cancelled
        


    AcceptIntercept:
    #@ Flag & Define Definitions
        - flag <[Target]> behrry.essentials.trade.acceptedwaiting1:!
        - flag <player> behrry.essentials.trade.acceptedphase1:!
        - flag <[Target]> behrry.essentials.trade.acceptedphase1:!
        - define Inventory1 <player.uuid>PlayerTradeInventory_<[Target].uuid>
        - define Inventory2 <[Target].uuid>PlayerTradeInventory_<player.uuid>
        - define BlankSlots <script.yaml_key[BlankSlots].as_list>
        - define LeftInvSlots <script.yaml_key[LeftInvSlots].as_list>
        - define RightInvSlots <script.yaml_key[RightInvSlots].as_list>
        
    #@ Run the banner flare green
        - foreach <[BlankSlots]> as:Slot:
            - inventory set d:<[Inventory1]> o:<item[Confirm_Blank0]> slot:<[Slot]>
            - inventory set d:<[Inventory2]> o:<item[Confirm_Blank0]> slot:<[Slot]>
            - if <[Loop_Index]> == 1:
                - wait 2t
            - if <[Loop_Index].mod[5]> != 0:
                - wait 2t
            - inventory set d:<[Inventory1]> o:<item[Blank]> slot:<[Slot]>
            - inventory set d:<[Inventory2]> o:<item[Blank]> slot:<[Slot]>
            - inventory update

    #@ Remove the lock from the other player
        - foreach <inventory[<[Inventory1]>].slot[<[RightInvSlots]>].reverse> as:Item:
            - if <[Item].script.name.contains[BLANK]||false>:
                - inventory set d:<inventory[<[Inventory1]>]> o:air slot:<[RightInvSlots].reverse.get[<[Loop_Index]>]>
                - if <[Loop_index].mod[3]> == 0:
                    - wait 1t
        - foreach <inventory[<[Inventory2]>].slot[<[LeftInvSlots]>]> as:Item:
            - if <[Item].script.name.contains[BLANK]||false>:
                - inventory set d:<inventory[<[Inventory2]>]> o:air slot:<[LeftInvSlots].get[<[Loop_Index]>]>
                - if <[Loop_index].mod[3]> == 0:
                    - wait 1t

    AcceptTrade:
            - foreach <[PlayerLoot]> as:Loot:
                - if !<[Loot].script.name.contains[BLANK]||false> && <[Loot].material.name> != Air:
                    - give <[Loot]>
            - foreach <[TargetLoot]> as:Loot:
                - if !<[Loot].script.name.contains[BLANK]||false> && <[Loot].material.name> != Air:
                    - give <[Loot]> player:<[Target]>
            #- give <[PlayerLoot]>
            #- give <[TargetLoot]> player:<[Target]>
            - flag player behrry.essentials.trade.dedup duration:1t
            - flag <[Target]> behrry.essentials.trade.dedup duration:1t
            - inventory close
            - inventory close player:<[Target]>
            - narrate format:Colorize_Green "Trade complete!"
            - narrate targets:<[Target]> format:Colorize_Green "Trade complete!"



        
InvDebugPrint:
    type: task
    debug: false
    script:
        - announce to_console format:Colorize_Red "Event: On Player CLICKS In Inventory"
        - announce to_console "<proc[Colorize].context["<&gt>context.item<&gt>|Yellow]><&4><&lt>[<&c>i1<&4>]<&gt> <&a>~ <&a><context.item||INVALID> <&3>returns the ItemTag the player has clicked on."
        - announce to_console "<proc[Colorize].context["<&gt>context.inventory<&gt>|Yellow]> <&a>~ <&a><context.inventory||INVALID> <&3>returns the InventoryTag (the 'top' inventory, regardless of which slot was clicked)."
        - announce to_console "<proc[Colorize].context["<&gt>context.clicked_inventory<&gt>|Yellow]> <&a>~ <&a><context.clicked_inventory||INVALID> <&3>returns the InventoryTag that was clicked in."
        - announce to_console "<proc[Colorize].context["<&gt>context.cursor_item<&gt>|Yellow]><&4><&lt>[<&c>i2<&4>]<&gt> <&a>~ <&a><context.cursor_item||INVALID> <&3>returns the item the Player is clicking with."
        - announce to_console "<proc[Colorize].context["<&gt>context.click<&gt>|Yellow]> <&a>~ <&a><context.click||INVALID> <&3>returns an ElementTag with the name of the click type. Click type list: http://bit.ly/2IjY198"
        - announce to_console "<proc[Colorize].context["<&gt>context.slot_type<&gt>|Yellow]> <&a>~ <&a><context.slot_type||INVALID> <&3>returns an ElementTag with the name of the slot type that was clicked."
        - announce to_console "<proc[Colorize].context["<&gt>context.slot<&gt>|Yellow]> <&a>~ <&a><context.slot||INVALID> <&3>returns an ElementTag with the number of the slot that was clicked."
        - announce to_console "<proc[Colorize].context["<&gt>context.raw_slot<&gt>|Yellow]> <&a>~ <&a><context.raw_slot||INVALID> <&3>returns an ElementTag with the raw number of the slot that was clicked."
        - announce to_console "<proc[Colorize].context["<&gt>context.is_shift_click<&gt>|Yellow]> <&a>~ <&a><context.is_shift_click||INVALID> <&3>returns true if 'shift' was used while clicking."
        - announce to_console "<proc[Colorize].context["<&gt>context.action<&gt>|Yellow]> <&a>~ <&a><context.action||INVALID> <&3>returns the inventory_action. See !language Inventory Actions."
        - announce to_console "<proc[Colorize].context["<&gt>context.hotbar_button<&gt>|Yellow]> <&a>~ <&a><context.hotbar_button||INVALID> <&3>returns an ElementTag of the button pressed as a number, or 0 if no number button was pressed."
        - announce to_console "<&c>-------------------"
InvDebugPrint2:
    type: task
    debug: false
    script:
        - announce to_console format:Colorize_Red "Event: On Player DRAGS In Inventory"
        - announce to_console "<proc[Colorize].context[<&gt>context.item<&lt>|yellow]> <&a>~<context.item||INVALID> <&3>returns the ItemTag the player has dragged.
        - announce to_console "<proc[Colorize].context[<&gt>context.inventory<&lt>|yellow]> <&a>~<context.inventory||INVALID> <&3>returns the InventoryTag (the 'top' inventory, regardless of which slot was clicked).
        - announce to_console "<proc[Colorize].context[<&gt>context.clicked_inventory<&lt>|yellow]> <&a>~<context.clicked_inventory||INVALID> <&3>returns the InventoryTag that was clicked in.
        - announce to_console "<proc[Colorize].context[<&gt>context.slots<&lt>|yellow]> <&a>~<context.slots||INVALID> <&3>returns a ListTag of the slot numbers dragged through.
        - announce to_console "<proc[Colorize].context[<&gt>context.raw_slots<&lt>|yellow]> <&a>~<context.raw_slots||INVALID> <&3>returns a ListTag of the raw slot numbers dragged through.