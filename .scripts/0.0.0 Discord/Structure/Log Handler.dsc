Login_Handler:
    type: yaml data
    debug: false
    events:
#        on bungee player joins network:
#        # % <context.name> returns the connecting player's name.
#        # % <context.uuid> returns the connection player's UUID.
#            - wait 1s
#            - if <player.has_flag[justjoined]||false>:
#                - stop
#            - if <player.is_banned||true>:
#                - stop
#            - if <player.name||null> == null:
#                - announce to_console "<&c>Player Leaves Network returned NULL for name."
#                - stop
#        # @ ██ [Format the Message ] ██
#            #$ <player.flag[behrry.essentials.display_name]||<player.name>>
#            #$ <player.flag[behrry.essentials.display_name].strip_color||<player.name>>
#            - define Message "<player.name> <proc[Colorize].context[joined the network.|yellow]>"
#            - define DiscordMessage ":heavy_plus_sign: **<player.name>** has joined the network."
#            - bungeerun <bungee.list_servers.exclude[<bungee.server>]> ChatEvent_Message def:<context.uuid>|<[Message].escaped>|PlayerJoined
#            - run Discord_Message def:LoudGeneral|<[DiscordMessage].escaped>
#
#        on bungee player leaves network:
#        # % <context.name> returns the leaving player's name.
#        # % <context.uuid> returns the leaving player's UUID.
#            - if <player.is_banned||true>:
#                - stop
#        # @ ██ [Format the Message ] ██
#            - if <player.name||null> == null:
#                - announce to_console "<&c>Player Leaves Network returned NULL for name."
#                - stop
#
#            #$<[User].flag[behrry.essentials.display_name]||<[User].name>>
#            #$<[User].flag[behrry.essentials.display_name].strip_color||<[User].name>>
#            - define Message "<player.name> <proc[Colorize].context[left the network.|yellow]>"
#            - define DiscordMessage ":heavy_multiplication_x: **<player.name>** has left the network."
#            - bungeerun <bungee.list_servers.exclude[<server.bungee>]> ChatEvent_Message def:<context.uuid>|<[Message].escaped>|PlayerQuit
#            - run Discord_Message def:LoudGeneral|<[DiscordMessage].escaped>
#
#        on bungee player switches to server:
#        # @ ██ [ Flag Next Server ] ██
#            - define User <player[<context.uuid||null>]||null>
#            - if <[User]||null> == null:
#                - announce to_console "<&c>Player Leaves Network returned NULL for name."
#                - stop
#            - define DiscordMessage ":curly_loop: **<[User].flag[behrry.essentials.display_name].strip_color||<[User].name||>>** switched to `<context.server>`"
#            - Bungee <context.server>:
#                - flag <player[<context.uuid||null>]||null> Behrry.Essentials.ServerSwitching:<bungee.server> duration:5s
#            - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage].escaped>
#
#        on player logs in for the first time:
#            - flag player justjoined duration:10s
#
#        # @ ██ [ Format the message ] ██
#            - define Message "<&6><player.name> <&d>joined the network for the first time!"
#            - define e <&lt>a:sheep:693346095249752066<&gt>
#            - define DiscordMessage "<[E]> **<player.name>** joined the network for the first time! <[E]>"
#
#        # @ ██ [ Log Chat ] ██
#            - define Log FirstJoined/<[Message]>
#            - inject ChatLog Instantly
#
#        # @ ██ [ Print Servers ] ██
#            - announce <[Message]>
#            - foreach <server.list_online_players> as:Player:
#                - playsound <[Player]> pitch:0.6 sound:ENTITY_PLAYER_LEVELUP
#                - wait 3t
#                - playsound <[Player]> pitch:0.8 sound:ENTITY_PLAYER_LEVELUP
#                - wait 18t
#                - playsound <[Player]> pitch:1.2 sound:ENTITY_PLAYER_LEVELUP
#            - if <bungee.list_servers.size||1> > 1:
#                - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
#                    - bungee <[Server]>:
#                        - announce <[Message]>
#                        - foreach <server.list_online_players> as:Player:
#                            - playsound <[Player]> pitch:0.6 sound:ENTITY_PLAYER_LEVELUP
#                            - wait 3t
#                            - playsound <[Player]> pitch:0.8 sound:ENTITY_PLAYER_LEVELUP
#                            - wait 18t
#                            - playsound <[Player]> pitch:1.2 sound:ENTITY_PLAYER_LEVELUP
#            - if <bungee.list_servers.contains[Discord]||false>:
#                - run Discord_Message def:LoudGeneral|<[DiscordMessage]>
#    ServerName:
#        - choose <bungee.server>:
#            - case BehrCraft:
#                - define Server "BehrCraft"
#            - case Discord:
#                - define Server "Discord | Test Server"
#            - case 1152Construction:
#                - define Server "Test Server | 1.15.2"
#            - case 1122Construction:
#                - define Server "Test Server | 1.12.2"
#            - case default:
#                - define Server "A Test Server"