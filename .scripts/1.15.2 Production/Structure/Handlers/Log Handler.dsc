Login_Handler:
    type: world
    debug: false
    events:
        on bungee server connects:
        # @ ██ [ Message Discord ] ██
            - if !<bungee.connected>:
                - define wait:+:1
                - if <[Wait]> > 5:
                    - announce to_console format:Colorize_Red "Bungee could not establish a connection in time."
                    - announce to_console format:Colorize_Red "<script.file_name> // lines: [5] - [13]"
                    - stop
                - wait 5t
            - if <bungee.list_servers.contains[Discord]||false>:
                - define DiscordMessage ":white_check_mark: **<context.server>** is now connected."
                - wait 1s
                - announce <bungee.connected>
                - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>
        # $ ██ [ To-Do: Send players back to BanditCraft ] ██
        on bungee server disconnects:
            - if <bungee.list_servers.contains[Discord]||false>:
                - define e <&lt>a:WeeWoo2:592074452896972822<&gt>
                - define DiscordMessage "<[E]> **<context.server>** disconnected."
                - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>
        on player logs in:
            #$ This should move to on player joins network--
            - if !<server.list_files[../../../../.playerdata/].contains[<player.uuid>.dsc]>:
                - yaml id:<player.uuid> create
                - yaml id:<player.uuid> savefile:../../../../.playerdata/<player.uuid>.dsc
            - else:
                - yaml id:<player.uuid> load:../../../../.playerdata/<player.uuid>.dsc

            #    - yaml id:<player.uuid> create
            #    - yaml id:<player.uuid> savefile:data/pData/<player.uuid>.yml
            #- else:
            #    - yaml id:<player.uuid> load:data/pData/<player.uuid>.yml
        on player joins:
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
            - determine <[Message]>
        on player quits:
        # @ ██ [ Remove Flags ] ██
            - define BlacklistFlags <list[behrry.chat.lastreply|behrry.essentials.inbed|Behrry.Essentials.Sitting]>
            - foreach <[BlacklistFlags]> as:Flag:
                - flag player <[Flag]>:!
            
        # @ ██ [ Message ] ██
            #- determine <[Message]>
            
        # - ██ [ Cancel if player was kicked ] ██
        # - - if <player.has_flag[behrry.moderation.kicked]>:
        # -     - determine NONE
    ServerName:
        - choose <bungee.server>:
            - case BehrCraft:
                - define Server "BehrCraft"
            - case Discord:
                - define Server "Discord | Test Server"
            - case 1152Construction:
                - define Server "Test Server | 1.15.2"
            - case 1122Construction:
                - define Server "Test Server | 1.12.2"
            - case default:
                - define Server "A Test Server"

ChatEvent_Message:
    type: task
    debug: false
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