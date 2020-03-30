Login_Handler:
    type: world
    debug: false
    events:
        on bungee player joins network:
        # % <context.name> returns the connecting player's name.
        # % <context.uuid> returns the connection player's UUID.
            - wait 1s
            - if <player.has_flag[justjoined]>:
                - stop
        # @ ██ [Format the Message ] ██
            - define Message "<player.flag[behrry.essentials.display_name]||<player.name>> <proc[Colorize].context[joined the network.|yellow]>"
            - define DiscordMessage ":heavy_plus_sign: **<player.flag[behrry.essentials.display_name].strip_color||<player.name>>** has joined the network."
            - bungeerun <bungee.list_servers.exclude[Discord]> ChatEvent_Message def:<context.uuid>|<[Message].escaped>|PlayerJoined
            - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage].escaped>

        on bungee player leaves network:
        # % <context.name> returns the leaving player's name.
        # % <context.uuid> returns the leaving player's UUID.
        # @ ██ [Format the Message ] ██
            - define User <player[<context.uuid>]>
            - define Message "<[User].flag[behrry.essentials.display_name]||<[User].name>> <proc[Colorize].context[left the network.|yellow]>"
            - define DiscordMessage ":heavy_multiplication_x: **<[User].flag[behrry.essentials.display_name].strip_color||<[User].name>>** has left the network."
            - bungeerun <bungee.list_servers.exclude[Discord]> ChatEvent_Message def:<context.uuid>|<[Message].escaped>|PlayerQuit
            - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage].escaped>

        on bungee player switches to serer:
        # @ ██ [ Flag Next Server ] ██
            - define User <player[<context.uuid>]>
            - define DiscordMessage ":curly_loop: **<[User].flag[behrry.essentials.display_name].strip_color||<[User].name||>>** switched to `<context.server>`"
            - Bungee <context.server>:
                - flag <player[<context.uuid>]> Behrry.Essentials.ServerSwitching:<bungee.server> duration:5s
            - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage].escaped>
        on bungee server connects:
        # @ ██ [ Message Discord ] ██
            - if <bungee.list_servers.contains[Discord]||false>:
                - define e :white_check_mark:
                - define DiscordMessage "<[E]> **<context.server>** is now connected."
                - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>
        # $ ██ [ To-Do: Send players back to BanditCraft ] ██
        on bungee server disconnects:
            - if <bungee.list_servers.contains[Discord]||false>:
                - define e <&lt>a:WeeWoo2:592074452896972822<&gt>
                - define DiscordMessage "<[E]> **<context.server>** disconnected."
                - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>

        on player logs in for the first time:
            - flag player justjoined duration:10s
        # @ ██ [ Format the message ] ██
            - define Message "▲ <&6><player.name> <&d>joined the network for the first time! <&r>▲"
            - define e <&lt>a:sheep:693346095249752066<&gt>
            - define DiscordMessage "<[E]> **<player.name>** joined the network for the first time! <[E]>"

        # @ ██ [ Log Chat ] ██
            - define Log FirstJoined/<[Message]>
            - inject ChatLog Instantly

        # @ ██ [ Print Servers ] ██
            - announce <[Message]>
            - foreach <server.list_online_players> as:Player:
                - playsound <[Player]> pitch:0.6 sound:ENTITY_PLAYER_LEVELUP
                - wait 3t
                - playsound <[Player]> pitch:0.8 sound:ENTITY_PLAYER_LEVELUP
                - wait 18t
                - playsound <[Player]> pitch:1.2 sound:ENTITY_PLAYER_LEVELUP
            - if <bungee.list_servers.size||1> > 1:
                - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
                    - bungee <[Server]>:
                        - announce <[Message]>
                        - foreach <server.list_online_players> as:Player:
                            - playsound <[Player]> pitch:0.6 sound:ENTITY_PLAYER_LEVELUP
                            - wait 3t
                            - playsound <[Player]> pitch:0.8 sound:ENTITY_PLAYER_LEVELUP
                            - wait 18t
                            - playsound <[Player]> pitch:1.2 sound:ENTITY_PLAYER_LEVELUP
            - if <bungee.list_servers.contains[Discord]||false>:
                - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>
        on player joins:
            - determine passively NONE
        # @ ██ [ Adjust Flags ] ██
            - define BlackFlags <list[behrry.protecc.prospecting]>
            - foreach <[BlackFlags]> as:BlackFlag:
                - if <player.has_flag[<[BlackFlag]>]>:
                    - flag player <[BlackFlag]>:!

        # @ ██ [ Correct Roles ] ██
            - if <player.in_group[Silent]>:
                - while !<player.groups.contains[Public]>:
                    - execute as_server "upc addgroup <player.name> Public"
                    - wait 5t

        # @ ██ [ Print the chat history ] ██
            - foreach <server.flag[Behrry.Essentials.ChatHistory.Global]> as:Log:
                - define LogType <[Log].unescaped.before[/]>
                - define LogMessage <[Log].unescaped.after[/]>
                - define Flag Behrry.Settings.ChatHistory.<[LogType]>
                - if !<player.has_flag[<[Flag]>]>:
                    - flag player <[Flag]>
                - if <player.flag[<[Flag]>]>:
                    - narrate <[LogMessage]>

        # @ ██ [ Adjust Displayname ] ██
            - wait 1s
            - if <player.has_flag[behrry.essentials.display_name]>:
                - adjust <player> display_name:<player.flag[behrry.essentials.display_name]>
        
        # @ ██ [ Check if Switching Servers ] ██
            - if <player.has_flag[Behrry.Essentials.ServerSwitching]>:
                - flag player Behrry.Essentials.ServerSwitching:!
                - stop

        # @ ██ [ Format the message ] ██
            - inject Locally ServerName Instantly
            - if <player.has_flag[behrry.essentials.display_name]>:
                - define Name <player.flag[behrry.essentials.display_name]>
            - else:
                - define Name <player.name>
            - define Message "<[Name]> <proc[Colorize].context[joined the network on:|yellow]> <&a><[Server]><&6>."
        on player quits:
        # @ ██ [ Remove Flags ] ██
            - define BlacklistFlags <list[behrry.chat.lastreply]>
            - foreach <[BlacklistFlags]> as:Flag:
                - flag player <[Flag]>:!
            
        # @ ██ [ Message ] ██
            - determine NONE
            
        # - ██ [ Cancel if player was kicked ] ██
        # - - if <player.has_flag[behrry.moderation.kicked]>:
        # -     - determine NONE
    ServerName:
        - choose <bungee.server>:
            - case BanditCraft:
                - define Server "Bandit Craft"
            - case Discord:
                - define Server "Discord | Test Server"
            - case 1152Construction:
                - define Server "Test Server | 1.15.2"
            - case 1122Construction:
                - define Server "Test Server | 1.12.2"
            - case default:
                - define Server "A Test Server"

    Old:
        on player quits:
        # @ ██ [Format the Message ] ██
        # $   - define Message "<player.flag[behrry.essentials.display_name]||<player.name>> <proc[Colorize].context[left the network.|yellow]>"
        # $   - define DiscordMessage "**<player.display_name.strip_color>**: <[Message].strip_color>"

        # @ ██ [Log to global chat ] ██
        # $   - define Log Quit/<[Message]>
        # $   - inject Chat_Logger Instantly
            
        # @ ██ [ Print to Other Servers ] ██
        # $   - if <bungee.list_servers.size||1> > 1:
        # $       - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
        # $           - bungee <[Server]>:
        # $               - announce <[Message]>
        # $   - if <bungee.list_servers.contains[Discord]||false>:
        # $       - bungeerun Discord Discord_Message def:593523276190580736|<[DiscordMessage]>

        # @ ██ [ Join Message Main Server ] ██
            - determine <[Message]>


ChatEvent_Message:
    type: task
    debug: true
    definitions: PlayerUUID|RawMessage|EventType
    script:
    # @ ██ [ Check for Setting ] ██
        - define Flag Behrry.Settings.ChatEvent.<[EventType]>
        - wait 1t
        - foreach <server.list_online_players> as:Player:
            - if !<[Player].has_flag[<[Flag]>]>:
                - flag <[Player]> <[Flag]>
            - if <[Player].flag[<[Flag]>]>:
            # @ ██ [ Check if User is Ignored ] ██
                - if <[Player].has_flag[behrry.essentials.ignorelist]>:
                    - if <player.flag[behrry.essentials.ignorelist].parse[uuid].contains[<[PlayerUUID]>]||false>:
                        - foreach next
                - narrate targets:<[Player]> <[RawMessage].unescaped>