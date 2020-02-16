# | ███████████████████████████████████████████████████████████
# % ██    /seen - Shows you a when a player was last online.
# | ██
# % ██  [ Command ] ██
Seen_Command:
    type: command
    name: seen
    debug: false
    description: Shows you a when a player was last online.
    usage: /seen <&lt>Player<&gt>
    permission: behrry.essentials.seen
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_players.parse[name]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
            
        - define User <context.args.get[1]>
        - inject Player_Verification_Offline Instantly
        - define Days "<&e><util.date.time.duration.sub[<[User].last_played>].in_days.round_down> <&2>d<&a>ays<&2>,"
        - define Hours "<&e><util.date.time.duration.sub[<[User].last_played>].time.hour.round_down> <&2>h<&a>ours<&2>,"
        - define Minutes "<&e><util.date.time.duration.sub[<[User].last_played>].time.minute.round_down>"

        - Define Text "<proc[User_Display_Simple].context[<[User]>]> <&2>l<&a>ast <&2>s<&a>een <[Days]> <[Hours]> <[Minutes]> <&2>m<&a>inutes <&2>a<&a>go<&2>."
        - narrate <[Text]>
