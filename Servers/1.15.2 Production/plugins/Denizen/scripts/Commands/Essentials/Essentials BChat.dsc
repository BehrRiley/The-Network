bchat_Command:
    type: command
    name: bchat
    debug: false
    description: Enables or disables bchat
    permission: behrry.essentials.bchat
    usage: /bchat ((on/off)/(Message))/<&lt>Message<&gt>
    tab complete:
        - define Arg1 <list[on|off]>
        - inject OneArg_Command_Tabcomplete Instantly
    aliases:
        - b
    chat:
        - define Targets <server.list_online_players.filter[has_permission[behrry.essentials.bchat]]>
        - define Prefix "<&e>{▲}<&6>-<&e><player.display_name.strip_color><&6>:"
        - narrate targets:<[Targets]> "<[Prefix]> <&7><context.raw_args.parse_color>"
    script:
    # @ ██ [  Check Args ] ██
        - if <list[On|off].contains[<context.args.get[1]>]> || <context.args.get[1]||null> == null:
            - if <context.args.get[2]||null> == null:
                - define Arg <context.args.get[1]||null>
                - define ModeFlag "behrry.essentials.bchat"
                - define ModeName "▲chat"
                - inject Activation_Arg Instantly
            - else:
                - inject locally Chat Instantly
        - else if <context.args.get[2]||null> != null:
            - inject locally Chat Instantly
        - else:
            - inject locally Chat Instantly

#BChat_Handler:
#    type: world
#    events:
#        on player chats:
#            - if <player.has_flag[behrry.essentials.bchat]>:
#                - define Targets <server.list_online_players.filter[has_permission[behrry.essentials.bchat]]>
#                - define Prefix "<&e>{▲}<&6>-<&e><player.display_name.strip_color><&6>:"
#                - narrate targets:<[Targets]> "<[Prefix]> <context.message.parse_color>"
