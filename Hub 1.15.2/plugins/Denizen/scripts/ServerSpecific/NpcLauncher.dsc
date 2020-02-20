task:
    type: task
    script:
        - define Wait 1t
        - modifyblock l@57,67,191,bees air
        - wait <[Wait]>
        - modifyblock l@57,66,191,bees sticky_piston[direction=UP]
        - wait <[wait]>
        - modifyblock l@57,66,192,bees redstone_block
        - wait <[wait]>
        - modifyblock l@57,66,192,bees air
        - wait <[wait]>
        - modifyblock l@57,66,191,bees air
        - wait <[wait]>
        - modifyblock l@57,65,191,bees sticky_piston[direction=UP]
        - wait <[wait]>
        - modifyblock l@57,65,192,bees redstone_block
        - wait <[wait]>
        - modifyblock l@57,65,192,bees air
        - wait <[wait]>
        - modifyblock l@57,65,191,bees air
        - wait <[wait]>

        #- modifyblock l@57,66,189,bees redstone_block
        #- wait <[wait]>

        - wait <[wait]>
        - modifyblock l@57,64,191,bees sticky_piston[direction=UP]
        - wait <[wait]>
        - modifyblock l@57,64,192,bees redstone_block
        - wait <[wait]>
        - modifyblock l@57,64,192,bees air
        - wait <[wait]>
        - modifyblock l@57,64,191,bees air
        - wait <[wait]>
        
        - wait <[wait]>
        - modifyblock l@57,63,191,bees sticky_piston[direction=UP]
        - wait <[wait]>
        - modifyblock l@57,63,192,bees redstone_block
        - wait <[wait]>
        - modifyblock l@57,63,192,bees air
        - wait <[wait]>
        - modifyblock l@57,63,191,bees air
        - wait <[wait]>
        
        - create player Bob l@57.5,66,191.5,10,90,bees save:Bobs
        - wait <[wait]>
        - wait <[wait]>
        - wait <[wait]>
        - define Bobs <entry[Bob].spawned_entities.get[1]>
        - adjust <Bob> velocity:l@0,1,0,bees
        - wait <[wait]>

        - modifyblock l@57,63,191,bees m@piston[direction=UP]
        - wait <[wait]>
        - modifyblock l@57,63,192,bees m@redstone_block
        - wait <[wait]>
        - modifyblock l@57,63,192,bees stone
        - wait <[wait]>
        - modifyblock l@57,63,191,bees stone

        - wait <[wait]>
        - modifyblock l@57,64,191,bees m@piston[direction=UP]
        - wait <[wait]>
        - modifyblock l@57,64,192,bees m@redstone_block
        - wait <[wait]>
        - modifyblock l@57,64,192,bees stone
        - wait <[wait]>
        - modifyblock l@57,64,191,bees stone
        - wait <[wait]>

        #- wait <[wait]>
        #- modifyblock l@57,66,189,bees stone
        #- wait <[wait]>

        - wait <[wait]>
        - modifyblock l@57,65,191,bees piston[direction=UP]
        - wait <[wait]>
        - modifyblock l@57,65,192,bees redstone_block
        - wait <[wait]>
        - modifyblock l@57,65,192,bees stone
        - wait <[wait]>
        - modifyblock l@57,65,191,bees stone
        - wait <[wait]>

        - wait <[wait]>
        - modifyblock l@57,66,191,bees piston[direction=UP]
        - wait <[wait]>
        - modifyblock l@57,66,192,bees redstone_block
        - wait 1s
        - modifyblock l@57,66,192,bees stone
        - wait <[wait]>
        - modifyblock l@57,66,191,bees stone
        - wait <[wait]>
        - modifyblock l@57,67,192,bees stone
        - wait <[wait]>
        - modifyblock l@57,67,191,bees air
        - wait <[wait]>
        - modifyblock l@57,67,191,bees stone

