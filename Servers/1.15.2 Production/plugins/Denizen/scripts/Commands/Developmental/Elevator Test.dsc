# $ Test
Elevator_Floor:
    type: task
    debug: false
    definitions: Height|FloorSelection
    script:
    #^- -- -- Main Definitions -------------- -- -#
        #@ -- Flags and Definitions --------- -- @#
        #% slow decent is .3, fast decent is .8
        - if <[Height]> > 0:
            - define Speed 0.08
        - else:
            - define Speed -0.08
        - define HeightMath <[Height].div[<[Speed]>]>
        #@ -- ------------------------------- -- @#
    #^- -- ---------------------------------- -- -#

    #^- -- -- Main Floor Door --------------- -- -#
        #@ -- Definitions ------------------- -- @#
        - define Door1 <cuboid[<location[52,24,65,Creative]>|<location[52,22,65,Creative]>]>
        - define Door2 <cuboid[<location[52,24,62,Creative]>|<location[52,22,62,Creative]>]>
        - define DoorWidth <[Door1].max.points_between[<[Door2].max>].distance[1]>
        - define DoorDistance <[DoorWidth].div[2]>
        #@ -- ------------------------------- -- @#
    #^- -- ---------------------------------- -- -#

    #^- -- -- Elevator Floor ---------------- -- -#
        #@ -- fix cuboid for player detection -- @#
        - define T1 <[FloorSelection].min.add[0.299,1,0.299]>
        - define T2 <[FloorSelection].max.add[0.699,1,0.699]>
        - define PlayerArea <cuboid[<[T1]>|<[T2]>]>
        #@ -- ------------------------------- -- @#

        #@ -- Check for player jams --------- -- @#
        - define J1 <[FloorSelection].min.add[0,2,0]>
        - define J2 <[FloorSelection].max.add[0,2,0]>
        - define JC <Cuboid[<[J1]>|<[J2]>]>
        - if <[JC].list_players.exclude[<[PlayerArea].list_players>].size> > 0:
            - narrate targets:<[P1].find.players.within[5]> format:Colorize_Red "Player-Jam in the ele!"
            - stop
        - define Players <[PlayerArea].list_players>
        #@ -- ------------------------------- -- @#
    #^- -- ---------------------------------- -- -#

        
        #@ -- Spawn Entities ---------------- -- @#
        - foreach <[Players]> as:Player:
            - spawn armor_stand[visible=false;gravity=false;marker=true] <[Player].location> save:as
            - mount <[Player]>|<entry[as].spawned_entities.first> <[Player].location>
            - define ArmorStands:|:<entry[as].spawned_entities.first>
            - define <[Player]>Loc <[Player].location.add[0,<[Height].add[0.1]>,0]>
        - foreach <[FloorSelection].blocks> as:Block:
            - spawn armor_stand[visible=false;gravity=false;marker=true] <[Block].center.sub[0,0.5,0]> save:as
            - spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Block]> save:s
            - mount <entry[s].spawned_entities.first>|<entry[as].spawned_entities.first> <[Block].center.sub[0,0.5,0]>
            - execute as_server "displayer <entry[s].spawned_entities.first.uuid> falling_block <[Block].material.name>" silent
            - define M<[Loop_Index]> <[Block].material.name>
            - modifyblock <[Block]> air
            - define ArmorStands:|:<entry[as].spawned_entities.first>
            - define Shulkers:|:<entry[s].spawned_entities.first>
        #@ -- ------------------------------- -- @#

        #@ -- Move Entities ----------------- -- @#
        - wait 1s
        - repeat <[HeightMath].abs>:
            - foreach <[ArmorStands]> as:stand:
                - adjust <[stand].as_entity> move:0,<[Speed]>,0
            - wait 1t
        #@ -- ------------------------------- -- @#
        
        #@ -- Apply New Floor --------------- -- @#
        - define N1 <[FloorSelection].min.add[0,<[Height]>,0]>
        - define N2 <[FloorSelection].max.add[0,<[Height]>,0]>
        - define NF <Cuboid[<[N1]>|<[N2]>]>
        - foreach <[NF].blocks> as:Block:
            - modifyblock <[Block]> <[M<[Loop_Index]>]>
        - wait 1s
        - foreach <[Players]> as:Player:
            - teleport <[Player]> <[<[Player]>Loc].with_yaw[<[player].location.yaw>].with_pitch[<[Player].location.pitch>]>
        #@ -- ------------------------------- -- @#


        #@ -- Remove Entities --------------- -- @#
        - foreach <[ArmorStands]> as:Stand:
            - remove <[stand].as_entity>
        - foreach <[Shulkers]> as:Shulker:
            - remove <[Shulker].as_entity>
        #@ -- ------------------------------- -- @#
        ##- pretest
        #- foreach <[FloorSelection].blocks> as:Block:
        #    - modifyblock <[Block]> yellow_wool
        #- wait 5s
        #- foreach <[NF].blocks> as:Block:
        #    - modifyblock <[Block]> air

elevator_handler:
    type: world
    events:
        on player clicks stone_button:
            - define Loc1 <context.location.simple>
            - choose <[Loc1]>:
                - case 54,23,64,Creative:
                    - define Height 11
                    - define ElevatorFloor <Cuboid[<location[54,21,64,Creative]>|<location[53,21,63,Creative]>]>
                    - run Elevator_Floor def:<[Height]>|<[ElevatorFloor]>
                - case 54,34,63,Creative:
                    - define Height -11
                    - define ElevatorFloor <Cuboid[<location[54,32,64,Creative]>|<location[53,32,63,Creative]>]>
                    - run Elevator_Floor def:<[Height]>|<[ElevatorFloor]>
                - case default:
                    - stop



Elevator_Tester:
    type: command
    debug: true
    name: elevator
    description: n/a
    permission: test
    aliases:
        - v
    script:
        - if <context.args.get[1]||null> == null:
            - run Elevator_Floor
            - stop
        - choose <context.args.get[1]>:
            - case ClearFlag:
                - flag server Test:!
            - case NarrateFlag:
                - narrate "<&a>* <&e><server.flag[Test].separated_by[<&a>* <&e><&nl>]>"
            - case ClearStands:
                - remove <player.location.find.entities[armor_stand|shulker|falling_block].within[15]>


