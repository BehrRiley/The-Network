MsgHover:
    type: procedure
    debug: false
    definitions: Hover|Text
    script:
    # - <proc[MsgCmd].context[<[Hover]>|<[Text]>]>
        - determine <&hover[<[Hover].unescaped>]><[Text].unescaped><&end_hover>

MsgCmd:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
    # - <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>]><[Text].unescaped><&end_click><&end_hover>

MsgChat:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
    # - <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - determine <&hover[<[Hover].unescaped>]><&click[<[Command]>]><[Text].unescaped><&end_click><&end_hover>

MsgHint:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
    # - <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>].type[suggest_command]><[Text].unescaped><&end_click><&end_hover>

MsgURL:
    type: procedure
    debug: false
    definitions: Hover|Text|URL
    script:
    # - <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[URL]>]>
        - determine <&hover[<[Hover].unescaped>]><&click[<[URL]>].type[OPEN_URL]><[Text].unescaped><&end_click><&end_hover>

# % ██  [ Usage ] - define Hover "Text in hoverbox"
# % ██  [       ] - define Text "Text in chat"
# % ██  [       ] - define Insert "Text inserted into chat"
# % ██  [       ] - narrate "<proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>"
MsgHoverIns:
    type: procedure
    debug: false
    definitions: Hover|Text|Insert
    script:
    # - <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Insertion]>]>
        - determine <&hover[<[Hover].unescaped>]><&insertion[<[Insert].unescaped>]><[Text].unescaped><&end_insertion><&end_hover>

MsgCmdIns:
    type: procedure
    debug: false
    definitions: Hover|Text|Command|Insert
    script:
    # - <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>|<[Insertion]>]>
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>]><&insertion[<[Insert].unescaped>]><[Text].unescaped><&end_insertion><&end_click><&end_hover>

MsgHintIns:
    type: procedure
    debug: false
    definitions: Hover|Text|Command|Insert
    script:
    # - <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>|<[Insertion]>]>
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>].type[suggest_command]><&insertion[<[Insert].unescaped>]><[Text].unescaped><&end_insertion><&end_click><&end_hover>

Colorize_Green:
    type: format
    debug: false
    format: <proc[Colorize].context[<text>|green]>
Colorize_Yellow:
    type: format
    debug: false
    format: <proc[Colorize].context[<text>|yellow]>
Colorize_Red:
    type: format
    debug: false
    format: <proc[Colorize].context[<text>|red]>
