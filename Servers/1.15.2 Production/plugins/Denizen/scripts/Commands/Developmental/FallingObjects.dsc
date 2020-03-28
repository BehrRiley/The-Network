#Fall_Test_Handler:
#    type: world
#    debug: true
#    events:

Fall_Test:
    type: task
    debug: false
    script:
        - flag server Test:!
        - define Cuboid <cuboid[<location[5,6,0,world]>|<location[-5,2,0,world]>].blocks>
        - foreach <[Cuboid]> as:Block:
            - modifyblock <[Block]> Glass
            #- <list[cobblestone|mossy_cobblestone|andesite|stone].random>
        - wait 5s
        - foreach <[Cuboid]> as:Block:
            - spawn armor_stand[visible=false;gravity=false;marker=true] <[Block].center.sub[0,0.5,0]> save:as
            - spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Block]> save:s
            - mount <entry[s].spawned_entities.first>|<entry[as].spawned_entities.first> <[Block].center.sub[0,0.5,0]>
            - execute as_server "displayer <entry[s].spawned_entities.first.uuid> falling_block <[Block].material.name>" silent
            
            - modifyblock <[Block]> barrier
            - define MaxHeight 6
            - flag server test:|:<entry[as].spawned_entities.first>
        - wait 2s
            - foreach <>
        - repeat 251:
            - foreach <server.flag[test]> as:stand:
                - if <[Loop_Index].mod[50]> == 0:
                    - modifyblock <cuboid[]>
                    - define Height:--
                - adjust <[stand]> move:0,-0.02,0
            - wait 1t
        - wait 3s
        - remove <player.location.find.entities[armor_stand|shulker|falling_block].within[15]>


Fall_Test_C:
    type: command
    debug: true
    name: falltest
    description: n/a
    permission: test
    aliases:
        - f
    script:
        - if <context.args.get[1]||null> == null:
            - run Fall_Test
            - stop
        - choose <context.args.get[1]>:
            - case ClearFlag:
                - flag server Test:!
            - case NarrateFlag:
                - narrate "<&a>* <&e><server.flag[Test].separated_by[<&a>* <&e><&nl>]>"
            - case ClearStands:
                - remove <player.location.find.entities[armor_stand|shulker|falling_block].within[15]>