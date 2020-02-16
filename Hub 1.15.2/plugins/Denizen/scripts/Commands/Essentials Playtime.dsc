# | ███████████████████████████████████████████████████████████
# % ██    /playtime - Shows you a player's current playtime.
# | ██
# % ██  [ Command ] ██
Playtime_Command:
    type: command
    name: playtime
    debug: false
    description: Shows you a player's current playtime.
    usage: /playtime <&lt>Player<&gt>
    permission: behrry.essentials.playtime
    aliases:
        - pt
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_online_players.parse[name].exclude[<player.name>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]||null> == null:
            - define User <player>
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification_Offline Instantly
            
        - define PDays "<&6><[User].statistic[PLAY_ONE_MINUTE].div[1728000].round_down><&f><&o>"
        - define PHours "<&6><[User].statistic[PLAY_ONE_MINUTE].div[72000].round_down.mod[24]><&f><&o>"
        - define PMinutes "<&6><[User].statistic[PLAY_ONE_MINUTE].div[1200].round_down.mod[60]><&f><&o>"
        - define FirstDays "<&6><util.date.time.duration.sub[<[User].first_played>].in_days.round_down><&f><&o>"

        - Define Text "<&2>P<&a>laytime<&2>: <[PDays]> <&2>d<&a>ays<&2>, <[PHours]> <&2>h<&a>ours<&2>, <[PMinutes]> <&2>m<&a>inute<&2>s <&b><&pipe> <&2>F<&a>irst <&2>L<&a>ogin:<[FirstDays]> <&2>d<&a>ays <&2>a<&a>go<&2>."
        - narrate <[Text]>
