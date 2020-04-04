Player_Sitting:
    type: world
    debug: false
    events:
        on player right clicks *stairs with air:
            - if <player.has_flag[Behrry.Essentials.Sitting]> || <context.location.material.half> == TOP || <player.world.name> != Creative:
                - stop
            - choose <context.location.material.direction>:
                - case NORTH:
                    - spawn <context.location.add[0.5,-1.2,0.6]> armor_stand[visible=false;collidable=false;gravity=false] save:armor
                    - look <entry[armor].spawned_entity> <context.location.add[0.5,0,1]>
                - case SOUTH:
                    - spawn <context.location.add[0.5,-1.2,0.4]> armor_stand[visible=false;collidable=false;gravity=false] save:armor
                    - look <entry[armor].spawned_entity> <context.location.add[0.5,0,-1]>
                - case WEST:
                    - spawn <context.location.add[0.6,-1.2,0.5]> armor_stand[visible=false;collidable=false;gravity=false] save:armor
                    - look <entry[armor].spawned_entity> <context.location.add[1,0,0.5]>
                - case EAST:
                    - spawn <context.location.add[0.4,-1.2,0.5]> armor_stand[visible=false;collidable=false;gravity=false] save:armor
                    - look <entry[armor].spawned_entity> <context.location.add[-1,0,0.5]>
            - flag player Behrry.Essentials.Sitting
            - mount <player>|<entry[armor].spawned_entity>
        on player steers armor_stand flagged:Behrry.Essentials.Sitting:
            - if <context.dismount>:
                - teleport <player.location.add[0,1.5,0]>
                - remove <context.entity>
                - flag player Behrry.Essentials.Sitting:!
