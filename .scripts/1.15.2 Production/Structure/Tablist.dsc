tablist:
    type: world
    debug: false
    header:
        - "<&a><&m><element[].pad_left[40].with[-]>"
        - "<&f>Welcome to <&2>B<&a>andit <&2>C<&a>raft!"
        - "<&7>Players Online<&3>:<&r> <&6>[<&f><server.list_online_players.size.sub[<[Hidden].size>]><&6>/<&f><server.max_players><&6>]<&f>    <&7>Ping<&3>:<&r> <&6>[<&f><[Player].ping><&6>]"
        - "<&a><&m><element[].pad_left[40].with[-]>"
    footer:
        - "<&a><&m><element[].pad_left[40].with[-]>"
        #     <&7>Server<&3>:<&r> <&6>[<&f><bungee.server><&6>]
        - "<&7>World<&3>:<&r> <&6>[<&f><[Player].world.name.to_titlecase><&6>]<&f>                  <&7>Coins<&3>:<&r> <&6>[<&f><[Player].flag[Behrry.Economy.Coins]||0><&6>]"
        - "<&7>Server<&3>: <&6>[<&f><bungee.server><&6>]                 <&7>Time<&3>:<&r> <&6>[<&f><util.date.time.hour><&6><&3>:<&r><&f><util.date.time.minute><&6><&3>:<&r><&f><util.date.time.second><&6>]"
        - "<&a><&m><element[].pad_left[40].with[-]>"
    moderatorheader:
        - "<&a><&m><element[].pad_left[40].with[-]>"
        - "<&f>Welcome to <&2>B<&a>andit <&2>C<&a>raft!"
        - "<&7>Players Online<&3>:<&r> <&6>[<&f><server.list_online_players.size><&6>/<&f><server.max_players><&6>]<&f>    <&7>Ping<&3>:<&r> <&6>[<&f><[Player].ping><&6>]"
        - "<&a><&m><element[].pad_left[40].with[-]>"
    events:
        on delta time secondly every:2:
            - foreach <server.list_online_players> as:player:
                - if <context.second.mod[20]> >= 10:
                    - if <[Player].in_group[Moderation]> || <[Player].in_group[Producers]>:
                        - define Prefix <script[Ranks].yaml_key[<[Player].groups.get[1]>.Prefix.<[Player].groups.get[2]>].parsed>
                        - if <[player].has_flag[behrry.moderation.hide]>:
                            - adjust <[Player]> "player_list_name:<[Prefix]><&7><[Player].name> <&7>(<&8>hidden<&7>)"
                        - else:
                            - adjust <[Player]> "player_list_name:<[Prefix]><[Player].name>"
                    - else:
                        - adjust <[Player]> "player_list_name:<&sp><[Player].name>"
                - else:
                    - if <[Player].in_group[Moderation]> || <[Player].in_group[Producers]>:
                        - define Prefix <script[Ranks].yaml_key[<[Player].groups.get[1]>.Prefix.<[Player].groups.get[2]>].parsed>
                        - if <[player].has_flag[behrry.moderation.hide]>:
                            - adjust <[Player]> "player_list_name:<[Prefix]><&7><[Player].display_name.strip_color> <&7>(<&8>hidden<&7>)"
                        - else:
                            - adjust <[Player]> "player_list_name:<[Prefix]><[Player].display_name>"
                    - else:
                        - adjust <[Player]> "player_list_name:<&sp><[Player].display_name>"


                - define Hidden <server.list_online_players.filter[has_flag[behrry.moderation.hide]]>

                - define header "<script.yaml_key[header].separated_by[<&nl>].parsed>"
                - define footer "<script.yaml_key[footer].separated_by[<&nl>].parsed>"
                - adjust <[Player]> tab_list_info:<[header]>|<[footer]>