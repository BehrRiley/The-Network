Production_Handler:
    type: world
    debug: false
    events:
        on player clicks with wooden_axe:
            - if <player.has_permission[worldedit]>:
                - determine passively cancelled
        on player clicks with World_Edit_Selector:
            - determine passively cancelled
            #$ Fake it until you make it
            - define Loc <player.location.cursor_on[256]>
            - if <[Loc].material.name> == air:
                - narrate format:Colorize_Red "Block Out of Range"
                - stop
            - if <context.click_type.contains[left]>:
                - execute as_op "/hpos1" silent
                - define LocText "<&2>[<&a>Selection 1<&2>] <&6>[<&e><[Loc].x><&6>, <&e><[Loc].y><&6>, <&e><[Loc].z><&6>]"
            - else if <context.click_type.contains[right]>:
                - execute as_op "/hpos2" silent
                - define LocText "<&2>[<&a>Selection 2<&2>] <&6>[<&e><[Loc].x><&6>, <&e><[Loc].y><&6>, <&e><[Loc].z><&6>]"
            - else:
                - stop
            - if <player.we_selection||null> != null:
                #- define Distance <player.we_selection.min.points_between[<player.we_selection.max>].distance[1].size>

                #@ manually create the size with math
                - define math1x <player.we_selection.min.x>
                - define math2x <player.we_selection.max.x>
                - define math1z <player.we_selection.min.z>
                - define math2z <player.we_selection.max.z>
                - define math1y <player.we_selection.min.y>
                - define math2y <player.we_selection.max.y>
                - define math4 <[math2x].sub[<[math1x]>].add[1].mul[<[math2z].sub[<[math1z]>].add[1]>].mul[<[math2y].sub[<[math1y]>].add[1]>]>

                - if <[math4]> > 150000:
                    - define Size "<&6>[<&c>Real Big<&6>]"
                - else:
                    - define Size <&6>[<&e><[math4].format_number><&6>]
                - if <[Loc].material.after[<&lb>].length> > 1:
                    - define MechanismList <[Loc].material.after[<&lb>].before[<&rb>].split[;]>
                    - define Mechanisms "<&nl><&3>[<&b>Mechanisms<&3>]<&e><&nl><&a>[<&e><[MechanismList].separated_by[<&a><&rb><&nl><&a><&lb><&e>]><&a>]"
                - define Text "<[LocText]> <[Size]>"
                - define Hover "<&3>[<&b>Material<&3>] <&e><[Loc].material.name><[Mechanisms].replace[<&pipe>].with[<&a><&pipe><&e>]||>"
                - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
            - else:
                - narrate <[LocText]>