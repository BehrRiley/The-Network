Lighter:
    type: item
    debug: false
    material: blaze_rod
    display name: "<&6>L<&e>ighter"

Lighter_Handler:
    type: world
    debug: false
    events:
        on player right clicks with Lighter:
            - if <player.has_permission[Behrry.Essentials.Lighter]>:
                - define Loc <player.location.cursor_on>
                - flag server LighterChunks.<player.location.chunk.after[@]>:<[Loc]>
                - light <[Loc]> 15
