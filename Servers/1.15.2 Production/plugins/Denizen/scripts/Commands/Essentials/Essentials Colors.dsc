Colors_Command:
    type: command
    name: colors
    debug: false
    description: Lists the colors in a click-menu
    usage: /colors
    permission: behrry.essentials.colors
    script:
        #@ Verify args
        - if <context.args.get[1]||null> != null
            - Inject Command_Syntax Instantly
            
        #@ Create color lists
        - define Colors <list[&0|&1|&2|&3|&4|&5|&6|&7|&8|&9|&a|&b|&c|&d|&e|&f]>
        - foreach <list[1|2]> as:Line:
            - define Math1 <[Loop_Index].add[<[Loop_Index].sub[1].mul[7]>]>
            - define Math2 <[Loop_Index].add[<[Loop_Index].sub[1].mul[8]>].add[7]>
            - foreach <[Colors].get[<[Math1]>].to[<[Math2]>]> as:Color:
                - define Hover "<proc[Colorize].context[Shift-Click to Insert:|green]><&nl><[Color].parse_color>This Color!"
                - define Text "<[Color].parse_color><[Color]>"
                - define Insert "<[Color]>"
                - define Key<[Loop_Index]> "<proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>"
                - define List<[Line]>:->:<[Key<[Loop_Index]>]>
                
        #@ Create format lists
        - define formats "<List[&k/tacos|&l/Bold|&M/Strike|&r/ Reset|&o/Italic|&n/Underline]>"
        - foreach <list[3|4|5]> as:line:
            - define Math1 <[Loop_Index].mul[2].sub[1]>
            - define Math2 <[Loop_Index].mul[2]>
            - foreach <[Formats].get[<[Math1]>].to[<[Math2]>]> as:Format:
                - define Hover "<proc[Colorize].context[Shift-Click to Insert:|green]><&nl><&e><[Format].before[/].parse_color><[Format].after[/]>!"
                - define Text "<[Format].before[/].parse_color><[Format].after[/]><&sp><&sp><&sp>"
                - define Insert "<[Format].before[/]>"
                - define Key<[Loop_Index]> "<proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>"
                - define List<[Line]>:->:<[Key<[Loop_Index]>]>
        
        #@ Narrate
        - narrate "<&2>+<element[<&a>Shift-Click To Insert].pad_left[28].with[-]><&2>-----+"
        - repeat 5:
            - narrate "<&sp><&sp><[List<[Value]>].separated_by[<&sp><&sp>]>"
        - narrate "<&8>[<&7>Note<&8>]<&7>: Color before Formats!<&nl><&2>+<element[].pad_left[22].with[-]><&2>-----+"

#   script:
#       - if <context.args.get[1]||null> != null
#           - Inject Command_Syntax Instantly
#       - define Colors <list[&0|&1|&2|&3|&4|&5|&6|&7|&8|&9|&a|&b|&c|&d|&e|&f]>
#       - narrate "<&2>+<element[<&a>Shift-Click To Insert].pad_left[28].with[-]><&2>-----+"
#       - repeat 2:
#           - define Text<[value]> li@
#           - foreach <[Colors].get[<[value].add[<[value].sub[1].mul[7]>]>].to[<[value].add[<[value].sub[1].mul[8]>].add[7]>]> as:Color:
#               - define Text<[value]> '<[Text<[value]>].include[{"text":"<[Color].parse_color><[Color]>", "hoverEvent":{"action":"show_text","value":"<&a>Shift click to insert"},"insertion":"<[Color]>"},]>'
#           - execute as_op 'tellraw @p ["",<[Text<[value]>].separated_by[{"text":"<&sp><&sp>"},]>""]'
#
#       - define formats "<List[&k/tacos|&l/Bold|&M/Strike|&r/ Reset|&o/Italic|&n/Underline]>"
#       - repeat 3:
#           - define Text<[value].add[2]> li@
#           - foreach <[Formats].get[<[value].mul[2].sub[1]>].to[<[value].mul[2]>]> as:Format:
#               - define Text<[value].add[2]> '<[Text<[value].add[2]>].include[{"text":"<&r><[Format].split[/].get[1]> <[Format].replace[/].with[].parse_color><&r>", "hoverEvent":{"action":"show_text","value":"<&a>Shift click to insert"},"insertion":"<[Format].split[/].get[1]>"},]>'
#           - execute as_op 'tellraw @p ["",<[Text<[value].add[2]>].separated_by[{"text":"<&sp><&sp><&sp><&sp>"},]>""]'
#       - narrate "<&8>[<&7>Note<&8>]<&7>: Color before Formats!<&nl><&2>+<element[].pad_left[22].with[-]><&2>-----+"
