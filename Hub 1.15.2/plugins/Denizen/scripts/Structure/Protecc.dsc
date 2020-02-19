Protecc_Handler:
    type: world
    debug: true
    events:
        on player right clicks with ProteccStick:
            - flag <player> Protecc.RightMarker:<context.location>
        on player left clicks with ProteccStick:
            - flag <player> Protecc.LeftMarker:<context.location>
        on player enters notable cuboid:
            - narrate "<context.from> returns the block location moved from."
            - narrate "<context.to> returns the block location moved to."
            - narrate "<context.cuboids> returns a list of cuboids entered/exited (when no cuboid is specified in the event name)."
            - narrate "<context.cause> returns the cause of the event. Can be: WALK, WORLD_CHANGE, JOIN, LEAVE, TELEPORT, VEHICLE"
        on player exits notable cuboid:
            - narrate "<context.from> returns the block location moved from."
            - narrate "<context.to> returns the block location moved to."
            - narrate "<context.cuboids> returns a list of cuboids entered/exited (when no cuboid is specified in the event name)."
            - narrate "<context.cause> returns the cause of the event. Can be: WALK, WORLD_CHANGE, JOIN, LEAVE, TELEPORT, VEHICLE"
        on player changes sign:
            - narrate "<context.location> returns the LocationTag of the sign."
            - narrate "<context.new> returns the new sign text as a ListTag."
            - narrate "<context.old> returns the old sign text as a ListTag."
            - narrate "<context.material> returns the MaterialTag of the sign."
