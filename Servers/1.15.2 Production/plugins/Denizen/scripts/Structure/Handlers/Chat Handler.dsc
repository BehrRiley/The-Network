Chat_Handler:
    type: world
    debug: false
    GroupManager:
        - flag player behrry.chat.experience:+15
        - if !<player.in_group[Patron]>:
            - if <player.in_group[Silent]>:
                - execute as_server "upc removeGroup <player.name> Silent"
                - execute as_server "upc addGroup <player.name> Visitor"
            - if <player.in_group[Visitor]>:
                - if <player.flag[behrry.chat.experience]> > 1000:
                    - execute as_server "upc removeGroup <player.name> Visitor"
                    - execute as_server "upc addGroup <player.name> Patron"
    events:
        on player chats bukkit_priority:lowest:
            - determine passively cancelled
            - define Message <context.message.parse_color>
            
        # @ ██ [  Mute Check, Formatting & Print ] ██
            - if <player.flag[behrry.moderation.muted]||false>:
                - define Moderation <server.list_online_players.filter[in_group[Moderation]]>
                - narrate format:Muted_Chat_Format targets:<[Moderation]> <[Message].strip_color>
                - stop
                
        # @ ██ [  Fixing your group ] ██
            - run locally GroupManager Instantly

        # @ ██ [  BChat Check, Formatting & Print ] ██
            - if <player.has_flag[Behrry.Essentials.BChat]>:
                - define Targets <server.list_online_players.filter[has_permission[behrry.essentials.bchat]]>
                - define Prefix "<&e>{▲}<&6>-<&e><player.display_name.strip_color><&6>:"
                - narrate targets:<[Targets]> "<[Prefix]> <&7><[Message].parse_color>"
                - stop
            
        # @ ██ [ Check if hidden moderator ] ██
            - if <player.has_flag[behrry.moderation.hide]>:
                - narrate format:Colorize_red "You are currently hidden."
                - stop

        # @ ██ [  VoiceChat Check, Formatting & Print ] ██
            - if <player.has_flag[Behrry.Essentials.VoiceChat]>:
                - define Targets <server.list_online_players_flagged[behrry.essentials.voicechat]>
                - define Prefix "<&b>[┤<proc[Colorize].context[VoiceChat]|Blue]><player.display_name||<player.name>><&3>:<&r>"
                - narrate targets:<[Targets]> "<[Prefix]> <[Message].parse_color><&r>"
                - stop

        # @ ██ [  Message Formatting ] ██
            - if <player.groups.contains_any[Moderation|Producer|Sponsor]>:
                - define Prefix "<script[Ranks].yaml_key[<player.groups.get[1]>.Prefix.<player.groups.get[2]>].parsed><player.display_name><&r>"
            - else:
                - define Prefix "<&7><player.display_name><&r>"
            - define Hover "<proc[Colorize].context[Real Name:|green]><&nl><player.name><&nl><proc[Colorize].context[Click to Message|green]>"
            - define Text "<[Prefix]><&b>:<&r> <[Message]>"
            - define Command "message <player.name> "
            - define NewMessage "<proc[MsgHint].context[<[Hover].escaped>|<[Text].escaped>|<[Command]>]>"
            - define DiscordMessage "**<player.display_name.strip_color>**: <[Message].strip_color>"
                
        # @ ██ [  Run individual player checks ] ██
            - foreach <server.list_online_players> as:Player:
            # @ ██ [  Check if player is ignoring chatter ] ██
                - if <[Player].flag[Behrry.Essentials.IgnoreList].contains[<player>]||false>:
                    - define Blacklist:->:<[Player]>

        # @ ██ [  Log chat ] ██
            - define log <player>/<[NewMessage]>
            - inject Chat_Logger Instantly

        # @ ██ [  Print chat ] ██
            - narrate targets:<server.list_online_players.exclude[<[Blacklist]||>]> <[NewMessage]>
        # $ - bungeerun <bungee.list_servers> ChatEvent_Message def:<context.uuid>|<[Message].escaped>|PlayerJoined
            - foreach <bungee.list_servers.exclude[Discord].exclude[<bungee.server>]> as:Server:
                - bungee <[Server]>:
                    - announce <[NewMessage]>
            - if <bungee.list_servers.contains[Discord]||false>:
                - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>
            - if <player.has_flag[Behrry.Essentials.Display_Name]>:
                - announce to_console format:Console_Chatter_displayname_Format "<[Message]>"
            - else:
                - announce to_console format:Console_Chatter_Format "<[Message]>"

Discord_Relay:
    type: task
    debug: false
    definitions: Message
# $ definitions: Message|UserLink
    script:
    # $ ██ [ To-Do:                                                      ] ██
    # - ██ | Add UserLinks as secondary definition for ignoring players  | ██
    # - ██ | Dependent File:                                             | ██
    # - ██ | .scripts/0.0.0 Discord/Discord/Handlers/Discord Handler.dsc | ██
        # @ ██ [ Define Userlink ] ██
        # % How should UserLink look?
        # % Guessing with key/value mapping - playertag/discordtag
        #^- define User <[UserLink].before[/]>
        #^- foreach <server.list_online_players> as:Player:
        #^    - if <[player].has_flag[Behrry.Essentials.IgnoreList]>:
        #^        - if <player.flag[Behrry.Essentials.IgnoreList].contains[<[User]>]>:
        #^            - define Blacklist:->:<[User]>

        # @ ██ [ Check if player is Muted ] ██
        # ^    - if <[User].has_flag[behrry.moderation.muted]>:
        # ^        - define Moderation <server.list_online_players.filter[in_group[Moderation]]>
        # ^        - narrate format:Muted_Chat_Format targets:<[Moderation].include[<[User]>]> "<[Message].unescaped.strip_color>"
        # ^        - stop
        # @ ██ [ Log the Chat ] ██
            - define Log Discord/<[Message].unescaped>
            - inject Chat_Logger Instantly

        # @ ██ [ Print to Chat ] ██
            - narrate targets:<server.list_online_players.exclude[<[BlackList]||>]> "<[Message].unescaped>"
            #- announce "<[Message].unescaped>"
    

Muted_Chat_Format:
    type: format
    debug: false
    format: "<&7>[<&c>Muted<&7>] <player.name><&8>:<&7> <text>"
Console_Chatter_displayname_Format:
    type: format
    debug: false
    format: "<&3>[<&7>Chatter<&3>] <&r><player.flag[Behrry.Essentials.Display_Name]> <&8>(<&7><player.name><&8>)<&b>:<&r> <text>"
Console_Chatter_Format:
    type: format
    debug: false
    format: "<&3>[<&7>Chatter<&3>] <&7><player.name><&b>:<&r><&f> <text>"


    # $ ██ [ To-Do:                   ] ██
    # - ██ | These should be flagged  | ██
    
Ranks:
    type: yaml data
    Moderation:
        Prefix:
            CMeme: <&2>[<&a>Mod<&2>]<&sp><&r>
            Administrator: <&6>[<&e>Mod<&6>]<&sp><&r>
            Moderator: <&6>[<&e>Mod<&6>]<&sp><&r>
            Support: <&b>[<&3>Support<&b>]<&sp><&r>
        HoverNP: "<&2>R<&a>eal <&2>N<&a>ame<&2>: <&e><player.name><&nl><proc[Colorize].context[Click to Report Issue|yellow]>"
        CmdNP: "snp message: "
    Producers:
        Prefix:
            Developer: <&1>[<&9>Dev<&1>]<&r>
            Architect: na
            Constructor: <&6>[<&e>C<&6>]<&r>
            Builder: na
        HoverNP: "<&2>R<&a>eal <&2>N<&a>ame<&2>: <&e><player.name><&nl><proc[Colorize].context[Click to Private Message|yellow]>"
        CmdNP: "msg <player.name> "
    Public:
        Prefix:
            Sponsor: <&1>[<&b>Sponsor<&1>]<&sp><&r>
            Patron: ""
            Visitor: <&2>[<&a>New<&2>]<&sp><&r>
            Silent: ""
            Muted: <&4>[<&c>Muted<&4>]<&sp><&r>
        HoverNP: "<&2>R<&a>eal <&2>N<&a>ame<&2>: <&e><player.name><&nl><proc[Colorize].context[Click to Private Message|yellow]>"
        CmdNP: "msg <player.name> "


