Donate_Command:
    type: command
    name: donate
    debug: false
    description: Gives you the donate link.
    usage: /donate
    permission: behrry.essentials.donate
    script:
        #@ Check Args
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        
        #@ Print Donate Link
        - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://www.paypal.com/paypalme2/BearRiley|blue]>"
        - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>P<&b><&n>ay<&3><&n>P<&b><&n>al"
        - define URL "https://www.paypal.com/paypalme2/BearRiley"
        - narrate <proc[msgUrl].context[<def[Hover]>|<def[Text]>|<def[URL]>]>