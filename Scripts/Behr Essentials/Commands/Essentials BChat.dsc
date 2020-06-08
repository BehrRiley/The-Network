bchat_Command:
    type: command
    name: bchat
    debug: false
    description: Enables or disables bchat
    permission: Behr.Essentials.BChat
    usage: /bchat ((on/off)/(Message))/<&lt>Message<&gt>
    aliases:
        - b
    chat:
        - define Targets <server.list_online_players.filter[has_permission[Behr.Essentials.BChat]]>
        - define Prefix <&e>{▲}<&6>-<&e><player.display_name.strip_color><&6><&co>
        - narrate targets:<[Targets]> "<[Prefix]> <&7><context.raw_args.parse_color>"
    script:
    # @ ██ [  Check Args ] ██
        - if <list[On|off].contains[<context.args.get[1]||null>]> || <context.args.get[1]||null> == null:
            - if <context.args.size> == 1:
                - define Arg <context.args.get[1]||null>
                - define ModeFlag Behr.Essentials.BChat
                - define ModeName ▲chat
                - inject Activation_Arg Instantly
            - else:
                - inject locally Chat Instantly
        - else if <context.args.size> > 1:
            - inject locally Chat Instantly
        - else:
            - inject locally Chat Instantly

