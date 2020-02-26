tablist:
    type: world
    debug: false
    header:
        - "<&a><&m><element[].pad_left[40].with[-]>"
        - "<&f>Welcome to <&2>B<&a>andit <&2>C<&a>raft!"
        - "<&7>Players Online<&co> <&6>[<&f><server.list_online_players.size><&6>/<&f><server.max_players><&6>]<&f>    <&7>Ping<&co> <&6>[<&f><[value].ping><&6>]"
        - "<&a><&m><element[].pad_left[40].with[-]>"
    footer:
        - "<&a><&m><element[].pad_left[40].with[-]>"
        #     <&7>Server<&co> <&6>[<&f><bungee.server><&6>]
        - "<&7>World<&co> <&6>[<&f><[value].world.name><&6>]<&f>                             <&7>Coins<&co> <&6>[<&f><[value].money.as_money.format_number||0><&6>]"
        - "<&7>Time<&co> <&6>[<&f><util.date.time.hour><&6><&co><&f><util.date.time.minute><&6><&co><&f><util.date.time.second><&6>]    <&7>Days Since Last Accident<&co> <&6>[<&f><[value].money.as_money.format_number||0><&6>]"
        - "<&a><&m><element[].pad_left[40].with[-]>"
    events:
        on delta time secondly:
            - foreach <server.list_online_players>:
            #-temp remove after uperms fix
                - if <bungee.server||null> == null:
                    - if <context.second.mod[20]> >= 10:
                        - if <[value].in_group[Moderation]> || <[Value].in_group[Producers]>:
                            - define Prefix <script[Ranks].yaml_key[<[Value].groups.get[1]>.Prefix.<[Value].groups.get[2]>].parsed>
                            - adjust <[value]> "player_list_name:<[Prefix]><[Value].name>"
                        - else:
                            - adjust <[value]> "player_list_name:<&sp><[value].name>"
                    - else:
                        - if <[value].in_group[Moderation]> || <[Value].in_group[Producers]>:
                            - define Prefix <script[Ranks].yaml_key[<[Value].groups.get[1]>.Prefix.<[Value].groups.get[2]>].parsed>
                            - adjust <[value]> "player_list_name:<[Prefix]><[Value].display_name>"
                        - else:
                            - adjust <[value]> "player_list_name:<&sp><[Value].display_name>"
                - else:
                    - adjust <[value]> "player_list_name:<&sp><[Value].display_name>"
                - define header "<script.yaml_key[header].separated_by[<&nl>].parsed>"
                - define footer "<script.yaml_key[footer].separated_by[<&nl>].parsed>"
                - adjust <[value]> tab_list_info:<[header]>|<[footer]>