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
        - if <context.args.size||0> < 2:
            - inject Command_Syntax Instantly

        - define User <context.args.get[1]>
        - inject Player_Verification Instantly
        - if <[User]> == <player>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

        - flag <[User]> behrry.chat.lastreply:<player.name>
        - define Message <context.raw_args.after[<context.args.get[1]><&sp>].parse_color><&r>
        - narrate targets:<player>  "<&7>[<&8><[User].name><&7>]<&1> <&chr[00ab]> <&9><[Message]>"
        - narrate targets:<[User]>  "<&7>[<&8><player.name><&7>]<&1> <&chr[00bb]> <&9><[Message]>"

Reply_Command:
    type: command
    name: r
    debug: false
    description: Replies to the last player who messaged you.
    usage: /r <&lt>Message<&gt>
    permission: behrry.essentials.reply
    aliases:
        - reply
    script:
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]||null> != null:
            - if <player.has_flag[behrry.chat.lastreply]>:
                - define User <player.flag[behrry.chat.lastreply]>
                - inject Player_Verification Instantly
            - else:
                - narrate format:Colorize_Red "Nobody to respond to."
                - stop
        - define Message <context.raw_args.parse_color>
        - narrate targets:<player>  "<&7>[<&8><[User].name><&7>] <&1><&chr[00ab]> <&9><[Message]>"
        - narrate targets:<[User]>  "<&7>[<&8><player.name><&7>] <&1><&chr[00bb]> <&9><[Message]>"
