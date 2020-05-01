Colorize:
    type: procedure
    debug: false
    definitions: string|color
    script:
        - choose <[Color]>:
            - case "Blue":
                - define 1 <&3>
                - define 2 <&b>
            - case "BlueInverted":
                - define 1 <&b>
                - define 2 <&3>
            - case "Green":
                - define 1 <&2>
                - define 2 <&a>
            - case "Red":
                - define 1 <&4>
                - define 2 <&c>
            - case "Purple":
                - define 1 <&5>
                - define 2 <&d>
            - case "Yellow":
                - define 1 <&6>
                - define 2 <&e>
            - case "Gray":
                - define 1 <&8>
                - define 2 <&7>

        # - First-Letter-Case
        - foreach <[String].unescaped.replace[&pipe].with[<&chr[6969]>].split[<&sp>]>:
            - define String1 <[1]><[value].split[].get[1]>
            - if <[value].split[].size> == 1:
                - define String2 <[2]>
            - else:
                - define String2 <[2]><[value].split[].get[2].to[99].separated_by[]>
            - define Text:->:<[String1]><[String2]>
        # - Separate
        - define Text <[Text].separated_by[<&sp>]>
        #$REGEX
        #| wow, why did i do this
        #- define Regex (<element[!@#$%^&*(),.:;'"{}].split[].after[li@]>)
        - define Text <[Text].replace[regex:(<&lt>|<&gt>|\.|,|\#|\$|\^|\&|\*|'|`|-|_|/|\{|\}|\(|\)|\<&lb>|@|:|;|\<&rb>)].with[<[1]>$1<[2]>].replace[<&chr[6969]>].with[|]>
        ## - Brackets
        #- define Text <[Text].replace[<&lb>].with[<[1]><&lb><[2]>].replace[<&rb>].with[<[1]><&rb><[2]>]>
        ## - Braces
        #- define Text <[Text].replace[{].with[<[1]>{<[2]>].replace[}].with[<[1]>}<[2]>]>
        ## - Parentheses
        #- define Text <[Text].replace[(].with[<[1]>(<[2]>].replace[)].with[<[1]>)<[2]>]>
        ## - Carrots
        #- define Text <[Text].replace[<&gt>].with[<[1]><&gt><[2]>].replace[<&lt>].with[<[1]><&lt><[2]>]>
        ## - Periods & Comma
        #- define Text <[Text].replace[.].with[<[1]>.<[2]>].replace[,].with[<[1]>,<[2]>]>
        ## - Exclamation & Colons
        #- define Text <[Text].replace[!].with[<[1]>!<[2]>].replace[<&co>].with[<[1]><&co><[2]>]>
        ## - Forward and Backward Slash
        #- define Text <[Text].replace[/].with[<[1]>/<[2]>].replace[<&bs>].with[<[1]><&bs><[2]>]>
        - Determine <[Text]>


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