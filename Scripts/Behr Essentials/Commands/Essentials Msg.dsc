Message_Command:
    type: command
    name: msg
    debug: false
    description: Messages a player
    usage: /msg <&lt>Player<&gt> <&lt>Message<&gt>
    permission: Behr.Essentials.Msg
    aliases:
        - message
        - m
    tab complete:
        - define Blacklist <server.list_online_players.filter[has_flag[Behr.Moderation.Hide]].include[<Player>]>
        - inject Online_Player_Tabcomplete Instantly
    script:
        - if <context.args.size> < 2:
            - inject Command_Syntax Instantly

        - define User <context.args.get[1]>
        - inject Player_Verification Instantly
        - if <[User]> == <player>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

        - flag <[User]> Behr.Chat.LastReply:<player.name>
        - define Message <context.raw_args.after[<context.args.get[1]><&sp>].parse_color><&r>
        - narrate "<&7>[<&8><[User].name><&7>]<&1> <&chr[00ab]> <&9><[Message]>"
        - narrate "<&7>[<&8><player.name><&7>]<&1> <&chr[00bb]> <&9><[Message]>" targets:<[User]>

Reply_Command:
    type: command
    name: r
    debug: false
    description: Replies to the last player who messaged you.
    usage: /r <&lt>Message<&gt>
    permission: Behr.Essentials.Reply
    aliases:
        - reply
    script:
    # @ ██ [  Check for Empty Arg ] ██
        - if <context.args.is_empty>:
            - inject Command_Syntax Instantly

    # @ ██ [  Check if player has a return recip. ] ██
        - if <player.has_flag[Behr.Chat.LastReply]>:
            - define User <player.flag[Behr.Chat.LastReply]>
            - inject Player_Verification Instantly
        - else:
            - define reason "Nobody to respond to."
            - inject Command_error
        - define Message <context.raw_args.parse_color>
        - flag <[User]> Behr.Chat.LastReply:<player.name>
        - narrate "<&7>[<&8><[User].name><&7>] <&1><&l><&chr[00ab]>- <&9><[Message]>"
        - narrate "<&7>[<&8><player.name><&7>] <&1><&l>-<&chr[00bb]> <&9><[Message]>" targets:<[User]>
