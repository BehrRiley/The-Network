Dynmap_Command:
    type: command
    name: dynmap
    debug: false
    description: Gives you the dynmap link.
    usage: /dynmap
    permission: behrry.essentials.dynmap
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - else:
            - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://banditcraft.pro/dynmap|blue]>"
            - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>D<&b><&n>ynmap"
            - define URL "http://banditcraft.pro/dynmap/"
            - narrate <proc[msgUrl].context[<def[Hover]>|<def[Text]>|<def[URL]>]>