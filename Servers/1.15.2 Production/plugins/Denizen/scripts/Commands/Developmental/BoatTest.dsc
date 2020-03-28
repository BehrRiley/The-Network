# $ ██ [  Red         ] ██
# $ ██ [              ] ██
# - ██ [  Orange      ] ██
# - ██ [              ] ██
# ^ ██ [  Yellow      ] ██
# ^ ██ [              ] ██
# @ ██ [  Green       ] ██
# @ ██ [              ] ██
# % ██ [  Cyan        ] ██
# % ██ [              ] ██
#   ██ [  Gray        ] ██
#   ██ [              ] ██
TestBoats:
    type: task
    debug: false
    script:
    #  -- Boat One ---- Ducky ------------------ -- @#
        - define P11 <location[46,31,85,Creative]>
        - define P12 <location[40,25,79,Creative]>
        #- define Boat1 <cuboid[<[B11].sub[1,1,1]>|<[B12].add[1,1,1]>]>
    #  -- Boat Two ---- The King --------------- -- @#
        - define P21 <location[46,31,95,Creative]>
        - define P22 <location[40,25,89,Creative]>
    #  -- Boat Three -- Gayrey ----------------- -- @#
        - define P31 <location[56,31,95,Creative]>
        - define P32 <location[50,25,89,Creative]>
    #  -- Boat Four ---- The Shroud ------------ -- @#
        - define P41 <location[56,31,85,Creative]>
        - define P42 <location[50,25,79,Creative]>
    #  -- Boat Five ---- Doug Dimmadomes House - -- @#
        - define P51 <location[66,31,85,Creative]>
        - define P52 <location[60,25,79,Creative]>
    #  -- Boat Six  ---- Fast ------------------ -- @#
        - define P61 <location[76,31,85,Creative]>
        - define P62 <location[70,25,79,Creative]>
    #  -- Boat Seven --- Peter Griffin --------- -- @#
        - define P71 <location[66,31,95,Creative]>
        - define P72 <location[60,25,89,Creative]>
    #  -- Boat Eight ---  ---------------------- -- @#
        - define P81 <location[76,31,95,Creative]>
        - define P82 <location[70,25,89,Creative]>
    #  -- Boat Test ---  ----------------------- -- @#
        - define P91 <location[76,31,95,Creative]>
        - define P92 <location[70,25,89,Creative]>
        #@ Define Boats
        - repeat 9:
            - define Boat<[Value]> <cuboid[<location[<[P<[Value]>1]>].sub[1,1,1]>|<location[<[P<[Value]>2]>].add[1,1,1]>]>

TestAttach:
    type: task
    debug: true
    script:
        - define Loc <player.location.cursor_on.add[0,2,0]>
        - spawn Boat <[Loc].center.sub[0,1.5,0]> save:boat
        - spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Loc].center.sub[0,0.5,0]> save:shulker1
        - spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Loc].center.sub[-1,0.5,0]> save:shulker2
        - spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Loc].center.sub[-2,0.5,0]> save:shulker3
        - adjust <entry[shulker1].spawned_entity> attach_to:<entry[boat].spawned_entity>
        - adjust <entry[shulker2].spawned_entity> attach_to:<entry[boat].spawned_entity>|<location[1,0,0]>
        - adjust <entry[shulker3].spawned_entity> attach_to:<entry[boat].spawned_entity>|<location[2,0,0]>

Boaty:
    type: task
    debug: true
    script:
        - remove <player.location.find.entities[boat|armor_stand|shulker|falling_block].within[15]>
        #@ -- Flags and Definitions --------- -- @#
        - define StartLoc <location[12,25,89,Creative]>
        - inject TestBoats Instantly
        - flag server Test:!
        - flag player Boat:!
        - remove <player.location.find.entities[boat|armor_stand|shulker|falling_block].within[25]>
        #@ -- ------------------------------- -- @#
        #@ -- Spawn Entities ---------------- -- @#
        - foreach <[Boat2].blocks.filter[material.name.is[!=].to[air]]> as:block:
            #-Set the Blocks
            - define Offset <[Block].sub[<[Boat1].min>]>
            - define loc <[StartLoc].add[<[Offset]>]>
            - modifyblock <[Loc]> <[Block].material>

            #- Seat-Check
            - if <[Block].material.name> == iron_trapdoor:
                - define Seat true
            - else:
                - define Seat false

            #-Spawn the entities
            - spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Loc].center.sub[0,0.5,0]> save:sh
            - spawn armor_stand[is_small=true;gravity=false;visible=false;invulnerable=true] <[Loc].center.sub[0,0.5,0]> save:as
            - define sh <entry[sh].spawned_entities.first>
            - define as <entry[as].spawned_entities.first>
            - if <[Seat]>:
                - mount <player>|<[sh]>|<[as]> <[Loc].center.sub[0,0.5,0]>
            - else:
                - mount <[sh]>|<[as]> <[Loc].center.sub[0,0.5,0]>
            - execute as_server "displayer <[sh].uuid> falling_block <[Loc].material.name>" silent

            #-Remove the Block
            - modifyblock <[Loc]> air
            
            - flag player Boat:|:<[as]>









        #- spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Block].center.sub[0,0.5,0]> save:s
        #- spawn armor_stand[is_small=true;visible=false;invulnerable=true] <[Block].center.sub[0,0.5,0]> save:as
        ##- define AS <entry[as].spawned_entities.first>
        #- define B <entry[b].spawned_entities.first>
        #- define S <entry[s].spawned_entities.first>
        #- mount <[S]>|<[B]> <[Block].center.sub[0,0.5,0]>
        #- execute as_server "displayer <[S].uuid> falling_block red_concrete_powder" silent
#
        #- spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Block].center.sub[0,0.5,0]> save:s
        #- define S2 <entry[s].spawned_entities.first>
        #- adjust <[S]> attach_to:<[S2]>|<location[1,0,0,Creative]>
        #- execute as_server "displayer <[S2].uuid> falling_block blue_concrete_powder" silent
#
        #- spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Block].center.sub[0,0.5,0]> save:s
        #- define S3 <entry[s].spawned_entities.first>
        #- adjust <[S2]> attach_to:<[S3]>|<location[1,0,0,Creative]>
        #- execute as_server "displayer <[S3].uuid> falling_block blue_concrete_powder" silent
        ##@ -- ------------------------------- -- @#
        #- flag player boaty.b:<[B]> duration:1h
        #- flag player boaty.b:<[B2]> duration:1h
#


    FallTest:
        - wait 5s
        - foreach <[Cuboid]> as:Block:
            - spawn armor_stand[visible=false;gravity=false;marker=true] <[Block].center.sub[0,0.5,0]> save:as
            - spawn shulker[has_ai=false;silent=true;invulnerable=true] <[Block]> save:s
            - mount <entry[s].spawned_entities.first>|<entry[as].spawned_entities.first> <[Block].center.sub[0,0.5,0]>
            - execute as_server "displayer <entry[s].spawned_entities.first.uuid> falling_block <[Block].material.name>" silent
            - modifyblock <[Block]> air
            - flag server test:|:<entry[as].spawned_entities.first>
        - wait 2s
        - repeat 250:
            - foreach <server.flag[test]> as:stand:
                - adjust <[stand]> move:0,-0.02,0
            - wait 1t
        - wait 3s
        - remove <player.location.find.entities[armor_stand|shulker|falling_block].within[15]>
Boaty_Shitty_Handlers:
    type: world
    debug: false
    events:
        on player steers shulker:
        #@ World Check
            - if <player.world.name> != Creative:
                - stop

        #@ Flag Check
            - if !<Player.has_flag[boaty.b]>:
                - stop

        #@ Check and Adjust Cooldowns
            - flag player test.TickCooldown:--
            - if <player.has_flag[test.TickCooldown]>:
                - if <player.flag[test.TickCooldown]> > 0:
                    - flag player test.Forward:+:<context.forward>
                    - flag player test.Sideways:+:<context.sideways>
                    - if <context.dismount>:
                        - determine cancelled
                    - stop
            - flag player test.TickCooldown:1

        #@ Check for Speed Throttle
            - if <context.dismount>:
                - define dividing <element[64].div[2]>
                - determine passively cancelled
            - else:
                - define dividing 64


        #@ Define directions
            - define forward <context.forward.add[<player.flag[test.Forward]||0>].div[<[dividing]>]>
            - define sideways <context.sideways.add[<player.flag[test.Sideways]||0>].div[<[dividing]>]>
            - define looking <player.location.direction.vector.sub[0,<player.location.direction.vector.y>,0]>
            - define velocity <[looking].mul[<[forward]>].add[<[looking].rotate_around_y[<element[90].to_radians>].mul[<[sideways]>]>]>
            
            - flag player test.Forward:0
            - flag player test.Sideways:0

            - define length <[velocity].vector_length>
            - flag server test.TotalDistance:+:<[length]>

            - foreach <player.flag[Boat]>:
                - define Entity <[value].as_entity>
                - if <[length]> > 0.01:
                    - adjust <[Entity]> move:<[Entity].velocity.add[<[velocity]>]>





        on player steers chicken:
        #@ World Check
            - if <player.world.name> == Creative:

        #@ Check if Jumping
                - if <context.jump>:
                    - flag player RideAllTheChickens.ShouldJump:true
        
        #@ Reduce CDs
                - flag player RideAllTheChickens.JumpCooldown:--
                - flag player RideAllTheChickens.TickCooldown:--

        #@ Check and Adjust Cooldowns
                - if <player.has_flag[RideAllTheChickens.TickCooldown]>:
                    - if <player.flag[RideAllTheChickens.TickCooldown]> > 0:
                        - flag player RideAllTheChickens.Forward:+:<context.forward>
                        - flag player RideAllTheChickens.Sideways:+:<context.sideways>
                        - if <context.dismount>:
                            - determine cancelled
                        - stop
                - flag player RideAllTheChickens.TickCooldown:1

        #@ Check if grounded
                - if <context.entity.is_on_ground>:
                    - define dividing 8
                - else:
                    - define dividing 16

        #@ Check if trying to dismount
                - if <context.dismount>:
                    - define dividing <def[dividing].div[10]>
                    - determine passively cancelled

        #@ Define directions
                - define forward <context.forward.add[<player.flag[RideAllTheChickens.Forward]||0>].div[<def[dividing]>]>
                - define sideways <context.sideways.add[<player.flag[RideAllTheChickens.Sideways]||0>].div[<def[dividing]>]>
                - define looking <player.location.direction.vector.sub[0,<player.location.direction.vector.y>,0]>
                - define velocity <def[looking].mul[<def[forward]>].add[<def[looking].rotate_around_y[<el@90.to_radians>].mul[<def[sideways]>]>]>
                - flag player RideAllTheChickens.Forward:0
                - flag player RideAllTheChickens.Sideways:0
                - if <player.flag[RideAllTheChickens.ShouldJump]||false>:
                #-<context.entity.is_on_ground> && 
                    - if <player.flag[RideAllTheChickens.JumpCooldown]||0> <= 0:
                        - define velocity <def[velocity].add[0,0.1,0]>
                        #- flag player RideAllTheChickens.JumpCooldown:10
                    - flag player RideAllTheChickens.ShouldJump:false
                - define length <def[velocity].vector_length>
                - if <def[length]> > 0.01:
                    - look <context.entity> <context.entity.location.add[<def[velocity]>]>
                    - adjust <context.entity> velocity:<context.entity.velocity.add[<def[velocity]>]>
                - flag server RideAllTheChickens.TotalDistance:+:<def[length]>

Boaty_Tester:
    type: command
    debug: true
    name: Boaty
    description: n/a
    permission: test
    aliases:
        - e
    script:
        - if <context.args.get[1]||null> == null:
            - run Boaty
            - stop
        - choose <context.args.get[1]>:
            - case ClearFlag:
                - flag server Test:!