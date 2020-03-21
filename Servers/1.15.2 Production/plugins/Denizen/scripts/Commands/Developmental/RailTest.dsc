testingevent:
    type: world
    debug: false
    events:
        on player enters minecart:
            - define Vehicle <context.vehicle>
            - adjust <[Vehicle]> speed:1.1
            #- while <player.vehicle||null> == <[Vehicle]>:
            #    - if <[Vehicle].velocity> == <location[0,0,0,<[Vehicle].world.name>]>:
            #        - wait 1s
            #        - while next
            #    - define Vx <[Vehicle].velocity.mul[10]>
            #    - define Check <[Vehicle].location.points_between[<[Vehicle].location.add[<[Vx]>]>].distance[1].filter[material.name.contains_any[Rail]].size>
            #    - if <[Check]> > 10:
            #        - adjust <[Vehicle]> move:<[Vx]>
            #    - wait 10t
