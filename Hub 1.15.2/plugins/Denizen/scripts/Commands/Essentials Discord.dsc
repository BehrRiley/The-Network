Discord_Command:
    type: command
    name: discord
    debug: false
    description: Gives you the discord link.
    usage: /discord
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - else:
            - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://discord.gg/ypHfzkr|blue]>"
            - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>D<&b><&n>iscord"
            - define URL "https://discord.gg/ypHfzkr"
            - narrate <proc[msgUrl].context[<def[Hover]>|<def[Text]>|<def[URL]>]>