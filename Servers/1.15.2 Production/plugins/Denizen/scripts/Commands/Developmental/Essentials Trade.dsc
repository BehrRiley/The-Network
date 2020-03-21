Trade_Command:
    type: command
    name: trade
    debug: true
    description: Trades with a player
    usage: /trade <&lt>Player<&gt> <&lt>Accept/Decline<&gt>
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

        - define SoftMenu <list[air|air|air|air|blank|air|air|air|air|air|air|air|air|emerald_block|air|air|air|air|air|air|air|air|redstone_block|air|air|air|air|air|air|air|air|blank|air|air|air|air]>
        - repeat 18:
            - define softmenu:|:<item[blank]>
        - note as:<[Inventory1]> <inventory[generic[size=54;contents=<[SoftMenu]>]]>
        - note as:<[Inventory2]> <inventory[generic[size=54;contents=<[SoftMenu]>]]>
        #-D@Inv[👍]
        - inventory open d:<[Inventory1]>
        - inventory open d:<[Inventory2]> player:<[Target]>

Trade_Handler:
    type: world
    debug: true
    LeftinvSlots: 1|2|3|4|10|11|12|13|19|20|21|22|28|29|30|31
    RightInvSlots: 6|7|8|9|15|16|17|18|24|25|26|27|33|34|35|36
    events:
        on player right clicks player:
            - if <player.is_sneaking>:
                - run Trade_Command path:script

        on player clicks in *PlayerTradeInventory*:
            - define Target <player[<context.inventory.notable_name.after[_]>]>
            #- define TargetInv <inventory[<[Target]>PlayerTradeInventory_<Player.uuid>]>
            - define TargetInv <player[<[Target]>].open_inventory>

            - if <script.yaml_key[RightInvSlots].as_list.contains[<context.raw_slot>]>:
                - determine cancelled

            #@ Return to this to re-implement shift-clicking
            - if <context.click.contains[shift]>:
                - determine cancelled

            #@
            - if <script.yaml_key[LeftinvSlots].as_list.contains[<context.raw_slot>]>:
                - define NewSlot <context.slot.add[5]>
                - choose <context.action>:
                    #@ Pickup Actions
                    - case "pickup_one":
                        - define Item <context.item.with[quantity=1]>
                        #- inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    - case "pickup_some":
                        #- define item <context.item.with[quantity=]>
                        - determine cancelled
                    - case "pickup_half":
                        - define Item <context.item.with[quantity=<context.item.quantity.div[2].round_up>]>
                        #- inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    - case "pickup_all":
                        - define Item <context.item>
                        - inventory set d:<[TargetInv]> o:air slot:<[NewSlot]>

                    #@ Place Actions
                    - case "place_one":
                        - define Item <context.cursor_item.with[quantity=1]>
                        #- inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    - case "place_some":
                        #- define item <context.item.with[quantity=]>
                        - determine cancelled
                    - case "place_half":
                        - define Item <context.cursor_item.with[quantity=<context.cursor_item.quantity.div[2].round_down>]>
                        #- inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>
                    - case "place_all":
                        - define Item <context.cursor_item>
                        - inventory set d:<[TargetInv]> o:<[Item]> slot:<[NewSlot]>

                    #@ Misc Options
                    #- case "clone_stack":
                    #- case "collect_to_cursor":
                    #- case "drop_one_slot"
                    #- case "drop_one_cursor"
                    #- case "drop_all_cursor":
                    #- case "drop_all_slot":
                    #- case "HOTBAR_MOVE_AND_READD"
                    #- case "HOTBAR_SWAP"
                    #- case "MOVE_TO_OTHER_INVENTORY"
                    #- case "SWAP_WITH_CURSOR"
                    #- case "UNKNOWN"
                    - case default:
                        - determine cancelled



                - else if <context.action.contains[place]>:

        on player drags in *PlayerTradeInventory*:
            - if <script.yaml_key[RightInvSlots].as_list.contains_any[<context.raw_slots>]>:
                - determine cancelled

        on player closes *PlayerTradeInventory*:
            - if <player.has_flag[behrry.essentials.tradededup]>:
                - stop
            - define target <player[<context.inventory.notable_name.after[_]>]>

            - flag <[Target]> behrry.essentials.tradededup duration:1t
            - inventory close player:<[Target]>
            - narrate format:Colorize_Red "Cancelled the trade."
            - narrate targets:<[Target]> format:Colorize_Red "<[Target].name> cancelled the trade."

#MobInventory_Handler:
#    type: world
#    events:
#        on player
#