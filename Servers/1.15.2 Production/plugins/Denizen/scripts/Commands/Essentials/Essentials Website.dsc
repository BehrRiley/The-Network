Website_Command:
    type: command
    name: website
    debug: false
    description: Gives you the website link.
    usage: /website
    permission: behrry.essentials.website
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - else:
            - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[http://banditcraft.pro/|blue]>"
            - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>D<&b><&n>anditCraft.pro"
            - define URL "http://banditcraft.pro"
            - narrate <proc[msgUrl].context[<def[Hover]>|<def[Text]>|<def[URL]>]>