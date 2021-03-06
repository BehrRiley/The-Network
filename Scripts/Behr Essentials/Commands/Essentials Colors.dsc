Colors_Command:
    type: command
    name: colors
    debug: false
    description: Lists the colors in a click-menu
    usage: /colors
    permission: Behr.Essentials.Colors
    script:
    # @ ██ [ Verify args ] ██
        - if !<context.args.is_empty>:
            - Inject Command_Syntax Instantly
            
    # @ ██ [ Create color lists ] ██
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
                
    # @ ██ [ Create format lists ] ██
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
        
    # @ ██ [ Narrate ] ██
        - narrate "<&2>+<element[<&a>Shift-Click To Insert].pad_left[28].with[-]><&2>-----+"
        - repeat 5:
            - narrate "<&sp><&sp><[List<[Value]>].separated_by[<&sp><&sp>]>"
        - narrate "<&8>[<&7>Note<&8>]<&7>: Color before Formats!<&nl><&2>+<element[].pad_left[22].with[-]><&2>-----+"

#$  -------------   ------------------------
#$                  Repository Shared Script
#-  -------------   ----------------------------
#$  Demo:           https://streamable.com/mvoll
#$  Link:           https://one.denizenscript.com/haste/66499
#$  Forum:          https://forum.denizenscript.com/viewtopic.php?f=9&t=228
#-  Last Updated:   2020-03-25 --------------------------------------------
#@CColors_Command:
#@    type: command
#@    name: ccolors
#@    debug: false
#@    description: Lists the colors in a click-menu
#@    usage: /ccolors
#@    script:
#%    # @ ██ [  Verify args ] ██
#^        - if <context.args.size> != 0:
#^            - narrate "<&c>Invalid usage! Just type<&2>: <&6>/<&e>ccolors"
#^            - stop
#^
#%    # @ ██ [  Create color lists ] ██
#^        - define Colors <list[&0|&1|&2|&3|&4|&5|&6|&7|&8|&9|&a|&b|&c|&d|&e|&f]>
#^        - foreach <list[1|2]> as:Line:
#^            - define Math1 <[Loop_Index].add[<[Loop_Index].sub[1].mul[7]>]>
#^            - define Math2 <[Loop_Index].add[<[Loop_Index].sub[1].mul[8]>].add[7]>
#^            - foreach <[Colors].get[<[Math1]>].to[<[Math2]>]> as:Color:
#^                - define Hover "<&a>Shift<&2>-<&a>Click to Insert<&2>:<&nl><[Color].parse_color>This Color!"
#^                - define Text "<[Color].parse_color><[Color]>"
#^                - define Insert "<[Color]>"
#^                - define Key<[Loop_Index]> "<&hover[<[Hover]>]><&insertion[<[Insert]>]><[Text]><&end_insertion><&end_hover>"
#^                - define List<[Line]>:->:<[Key<[Loop_Index]>]>
#^
#%    # @ ██ [  Create format lists ] ██
#^        - define formats "<List[&k/tacos|&l/Bold|&M/Strike|&r/ Reset|&o/Italic|&n/Underline]>"
#^        - foreach <list[3|4|5]> as:line:
#^            - define Math1 <[Loop_Index].mul[2].sub[1]>
#^            - define Math2 <[Loop_Index].mul[2]>
#^            - foreach <[Formats].get[<[Math1]>].to[<[Math2]>]> as:Format:
#^                - define Hover "<&a>Shift<&2>-<&a>Click to Insert<&2>:<&nl><&e><[Format].before[/].parse_color><[Format].after[/]>!"
#^                - define Text "<[Format].before[/].parse_color><[Format].after[/]><&sp><&sp><&sp>"
#^                - define Insert "<[Format].before[/]>"
#^                - define Key<[Loop_Index]> "<&hover[<[Hover]>]><&insertion[<[Insert]>]><[Text]><&end_insertion><&end_hover>"
#^                - define List<[Line]>:->:<[Key<[Loop_Index]>]>
#^
#%    # @ ██ [  Narrate ] ██
#^        - narrate "<&2>+<element[<&a>Shift-Click To Insert].pad_left[28].with[-]><&2>-----+"
#^        - repeat 5:
#^            - narrate "<&sp><&sp><[List<[Value]>].separated_by[<&sp><&sp>]>"
#^        - narrate "<&8>[<&7>Note<&8>]<&7>: Color before Formats!<&nl><&2>+<element[].pad_left[22].with[-]><&2>-----+"
