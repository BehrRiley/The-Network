# | ███████████████████████████████████████████████████████████
# % ██    /msg - Message a player
# | ██
# % ██  [ Command ] ██
Message_Command:
    type: command
    name: msg
    debug: false
    description: Messages a player
    usage: /msg <&lt>Player<&gt> <&lt>Message<&gt>
    permission: behrry.essentials.msg
    aliases:
        - message
    tab complete:
        - inject Online_Player_Tabcomplete Instantly
    script:
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        - if <context.args.get[2]||null> != null:
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly
        - if <[User]> == <player>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

        - flag <[User]> behrry.chat.lastreply:<player>
        - define Message <context.raw_args.after[<context.args.get[1]><&sp>]><&r>
        - narrate targets:<player>  "<&7>[<&8><[User].name><&7>]<&9> <&chr[00ab]> <&9><[Message]>"
        - narrate targets:<[User]>  "<&7>[<&8><player.name><&7>]<&9> <&chr[00bb]> <&9><[Message]>"
Reply_Command:
    type: command
    name: msg
    debug: true
    description: Replies to the last player who messaged you.
    usage: /r <&lt>Message<&gt>
    permission: behrry.essentials.reply
    aliases:
        - r
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].include[Everyone]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].include[Everyone].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]||null> != null:
            - if <player.has_flag[behrry.chat.lastreply]>:
                - define User <player.flag[behrry.chat.lastreply]>
                - inject Player_Verification Instantly
        - define Message <context.raw_args>
        - narrate targets:<player>  "<&7>[<&8><[User].name><&7>] <&1><&chr[00ab]> <&9><[Message]>"
        - narrate targets:<[User]>  "<&7>[<&8><player.name><&7>] <&1><&chr[00bb]> <&9><[Message]>"