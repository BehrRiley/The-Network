bchat_Command:
    type: command
    name: bchat
    debug: false
    description: Enables ordisables bchat, or speaks through bchat
    permission: Behr.Essentials.BChat
    usage: /bchat ((on/off)/<&lt>Message<&gt>)
    aliases:
        - b
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.is_empty>:
            - run Activation_Arg def:Behr.Essentials.BChat|▲chat
        - else if <context.args.size> == 1 && <list[on|true|activate|off|false|deactivate].contains[<context.args.first>]>:
            - run Activation_Arg def:Behr.Essentials.BChat|▲chat|<context.args.first>
        - else:
            - define Targets <server.list_online_players.filter[has_permission[Behr.Essentials.BChat]]>
            - define Prefix <&e>{▲}<&6>-<&e><player.display_name.strip_color><&6><&co>
            - narrate targets:<[Targets]> "<[Prefix]> <&7><context.raw_args.parse_color>"
