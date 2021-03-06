Discord_Command:
    type: command
    name: discord
    debug: false
    description: Gives you the discord link.
    usage: /discord
    permission: Behr.Essentials.Discord
    script:
    # @ ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax Instantly
        
    # @ ██ [ Print Discord Link ] ██
        - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://discord.gg/MjXemPr|blue]>"
        - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&b>┤ <&3><&n>D<&b><&n>iscord"
        - define URL "https://discord.gg/MjXemPr"
        - narrate <proc[msgUrl].context[<def[Hover]>|<def[Text]>|<def[URL]>]>
