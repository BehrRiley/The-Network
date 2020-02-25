Protecc_Handler:
    type: world
    debug: true
    reset:
        - flag player protecc.position.1:!
        - flag player protecc.position.2:!
        - flag player protecc.position:!
        - narrate "<proc[Colorize].context[Positions Reset.|yellow]>"
    events:
        on player shoots bow:
            - if <context.projectile.name> == SPECTRAL_ARROW && <player.inventory.contains[Protecco_Wando]>:
                - determine cancelled
        on player breaks block with Protecco_Wando:
            - determine passively cancelled
        on player clicks with Protecco_Wando:
            - determine passively cancelled

            #@ Open gui menu
            #- if <player.is_sneaking> && <context.click_type.contains_any[right]>:
            #  - inventory open d:in@BwandMenu
            #  - stop

            #@ Clear selection
            - if <player.is_sneaking> && <context.click_type.contains_any[left]>:
                - if <player.has_flag[protecc.clearwarning]>:
                    - inject locally Reset Instantly
                - else:
                    - flag player protecc.clearwarning duration:5s
                    - narrate "<proc[Colorize].context[shift+left-click again to clear positions.|yellow]>"
                - stop

            #@ Determine block location
            - define loc <context.location||<player.location.cursor_on>>
            
            #@ Determine left/right
            - if <context.click_type.contains_any[left]>:
                - define Pos 1
            - else if <context.click_type.contains_any[right]>:
                - define Pos 2

            #@ Check worlds
            - if <player.flag[protecc.position.1].as_location.world.name||<player.world.name>> != <player.world.name> || <player.flag[protecc.position.2].as_location.world.name||<player.world.name>> != <player.world.name>:
                - inject locally Reset Instantly

            #@ Determine flags
            - flag player protecc.position.<[Pos]>:<[Loc]>
            - define Pos1Flag <player.flag[protecc.position.1].as_location||<player.flag[protecc.position.2].as_location>>
            - define Pos2Flag <player.flag[protecc.position.2].as_location||<[Pos1Flag]>>
            - define cuboid <cuboid[<[Pos1Flag]>|<[Pos2Flag]>]>
            - flag player protecc.selection.cuboid:<[Cuboid]>

            #@ Determine formats
            - define Size <[Cuboid].blocks.size||0>
            - if <[Size]> > 0:
                - define PosFormat "<&6>[<&6>X:<&e><player.location.cursor_on.x.round_down>, <&6>Y:<&e><player.location.cursor_on.y.round_down>, <&6>Z:<&e><player.location.cursor_on.z.round_down><&6>] [<&e>S<&e>ize<&6>:<&e> <[Size]><&6>]"
            - else:
                - define PosFormat "<&6>[<&6>X:<&e><player.location.cursor_on.x.round_down>, <&6>Y:<&e><player.location.cursor_on.y.round_down>, <&6>Z:<&e><player.location.cursor_on.z.round_down><&6>]"
            
            #@ Highlight selection
            #- if <player.has_flag[protecc.position.1]> && <player.has_flag[protecc.position.2]>:
                #- if <[size]> < 1000000:
                    #- playeffect effect:flame at:<[cuboid].shell.parse[add[0.5,0.5,0.5]]> offset:0
                    #- playeffect effect:barrier at:<[cuboid].outline.parse[add[0.5,0.5,0.5]]> offset:0 visibility:250
            - narrate "<&6>P<&e>osition <&6>[<&e><[Pos]><&6>]<&e>: <[PosFormat]>"
            - run Protecc_Position_Task Instantly def:<context.click_type>|<[Loc]>

        #on player breaks block in:claims:
        #    - determine passively cancelled
        #    - narrate true
#claimcommandtest:
#    type: command
#    name: claimcommandtest
#    debug: true
#    permission: protecc.claim
#    script:
#        - if <player.name> != behr_riley:
#            - narrate "stahp, bad"
#            - stop
#
#        #@ determine cuboid
#        #- <cuboid[<player.flag[protecc.position.1].as_location||<player.flag[protecc.position.2]>]>
#        - define Pos1Flag <player.flag[protecc.position.1].as_location||<player.flag[protecc.position.2].as_location>>
#        - define Pos2Flag <player.flag[protecc.position.2].as_location||<[Pos1Flag]>>
#        - define cuboid <cuboid[<[Pos1Flag]>|<[Pos2Flag]>]>
#
#        #- note <[Cuboid]> as:Claims
#        - choose <context.args.get[1]>:
#            - case add:
#                - note <cuboid[Claims].add_member[<[Cuboid]>]> as:Claims
#            - case test:
#                - define Index <cuboid[Claims].get[<[Cuboid]>]>
#                - narrate <cuboid[Claims].remove_member[<[Index]>]>
#                - note <cuboid[Claims].remove_member[<[Index]>]> as:claims


Protecc_Position_Task:
    type: task
    debug: false
    definitions: ClickType|Loc
    script:
        - if <[ClickType].contains[left]>:
            - if <player.has_flag[protecc.selectionqueue.1]>:
                - if <queue.list.contains[<player.flag[protecc.selectionqueue.1].as_queue>]>:
                    - queue <player.flag[protecc.selectionqueue.1].as_queue> clear
            - flag player protecc.selectionqueue.1:<queue> duration:5s
            - flag player protecc.position.1:<[Loc]>
            - define Color 255,127,0
        - else:
            - if <player.has_flag[protecc.selectionqueue.2]>:
                - if <queue.list.contains[<player.flag[protecc.selectionqueue.2].as_queue>]>:
                    - queue <player.flag[protecc.selectionqueue.2].as_queue> clear
            - flag player protecc.selectionqueue.2:<queue> duration:5s
            - flag player protecc.position.2:<[Loc]>
            - define Color 0,127,255
        - repeat 25:
            - define L1 <list[0,0,0|0,0,0|0,0,0|1,0,1|1,0,1|1,0,1|0,0,1|1,0,0|0,1,0|0,1,0|1,1,1|1,1,1]>
            - define L2 <list[0,1,0|1,0,0|0,0,1|1,1,1|1,0,0|0,0,1|0,1,1|1,1,0|1,1,0|0,1,1|0,1,1|1,1,0]>
            - foreach <[L1]> as:1:
                - define 2 <[L2].get[<[loop_index]>]>
                - playeffect effect:redstone at:<[Loc].add[<[1]>].points_between[<[Loc].add[<[2]>]>].distance[<element[99.9].div[400]>]> offset:0 quantity:1 visibility:200 data:0 special_data:1|<[Color]>
            - wait 3t

Protecco_Wando:
    type: item
    debug: false
    material: spectral_arrow
    display name: <&6>P<&e>rotecco <&6>W<&e>ando
    mechanisms:
        unbreakable: true
        flags: HIDE_ALL
    lore:
        - <&a> Position 1<&co> Left Click
        - <&a> Position 2<&co> Right Click
    enchantments:
        - BINDING_CURSE