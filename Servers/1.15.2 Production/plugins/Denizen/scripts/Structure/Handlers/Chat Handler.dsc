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
    NameplateFormat:
        #- define Hover "<script[Ranks].yaml_key[<player.groups.get[1]>.HoverNP].parsed>"
        - define Text "<script[Ranks].yaml_key[<player.groups.get[1]>.Prefix.<player.groups.get[2]>].parsed><player.display_name><&r>"
        #- define Command "<script[Ranks].yaml_key[<player.groups.get[1]>.CmdNP].parsed>"
        #- define NamePlate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
        - define NamePlate <[Text]>
        - define DiscordNamePlate "**<player.display_name>**"

    #!DiscordMessage:
    #!   - define DiscordMessage "<[DiscordNamePlate]>: <context.message>"
    #!   - discord id:GeneralBot message channel:593523276190580736 "<[DiscordMessage].parse_color.strip_color.replace[`].with['].replace[▲].with[<&lt>:pufferfish:681640271028551712<&gt>].replace[:pufferfish:].with[<&lt>:pufferfish:681640271028551712<&gt>]>"
    GlobalChatLog:
        - if <server.flag[Behrry.Essentials.ChatHistory.Global].size||0> > 24:
            - flag server Behrry.Essentials.ChatHistory.Global:<-:<server.flag[Behrry.Essentials.ChatHistory.Global].first>
        - flag server Behrry.Essentials.ChatHistory.Global:->:<[Message].escaped>
        #- define Channel 123
        #- discord id:GeneralBot message channel:<[Channel]>

    events:
        on player chats:
            - determine passively cancelled
            #@ NPC Check
            - if <player.has_flag[Interacting_NPC]>:
                - stop

            #@ Command Check
            - if <player.has_flag[behrry.essentials.homerename]>:
                - define OldHome <player.flag[behrry.essentials.homerename]>
                - flag player behrry.essentials.homerename:!
                #@ Check args
                - define Name <context.message>
                - if <[Name]> == Cancel:
                    - narrate format:Colorize_Yellow "Home rename cancelled."
                    - stop
                - if <[Name].split.size> > 1:
                    - narrate format:Colorize_Red "Names cannot have spaces."
                    - stop
                - execute as_player "renamehome <[OldHome]> <[Name]>"
                - stop

            #@ Mute check
            - if <player.has_flag[muted]>:
                - define Targets "<server.list_online_players.filter[in_group[Moderation]]>"
                - define Message "<&7>[<&8>Muted<&7> <&7><player.name>: <context.message.strip_color>"
                - narrate targets:<[Targets]> <[Message]>
                - determine cancelled

            #@ BChat Check
            - if <player.has_flag[behrry.essentials.bchat]>:
                - define Targets <server.list_online_players.filter[has_permission[behrry.essentials.bchat]]>
                - define Prefix "<&e>{▲}<&6>-<&e><player.display_name.strip_color><&6>:"
                - narrate targets:<[Targets]> "<[Prefix]> <&7><context.message.parse_color>"
                - determine cancelled

            #@ Fixing your group
            - run locally GroupManager Instantly

            #@ in-game formatting
            - inject locally NameplateFormat Instantly

            #@ ChatLog
            - define Message "<[NamePlate]>: <context.message.parse_color.replace[:pufferfish:].with[▲]>"
            - inject locally GlobalChatLog Instantly
            
            #@ Print to Server
            - announce <[Message]>
            
            #@ Check for ignorelists
            
            #@ Print to Other Servers
            - if <bungee.list_servers.size||1> > 1:
                - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
                    - bungee <[Server]>:
                        - announce <[Message]>
            #@ Discord message
            #- inject locally DiscordMessage Instantly
            #- if <bungee.list_servers.contains[TestServer]> && <bungee.server> != TestServer:
            #    - bungeerun TestServer Discord_Chat_Task def:<[DiscordNamePlate]>|<context.message.escaped>
            #- else:
            #    - inject locally DiscordMessage Instantly
            

            ##@ Discord relay - between external servers
            #- if <bungee.server||null> == Hub2:
            #    - discord id:BehrBot message channel:681573237687058458 "►◄<[Message].escaped>"
            #- else:
            #    - discord id:BehrBot message channel:681573237687058458 "◄►<[Message].escaped>"

Ranks:
    type: yaml data
    Moderation:
        Prefix:
            CMeme: <&a>☼<&sp><&r>
            Administrator: ☼<&sp><&r>
            Moderator: ☼<&sp><&r>
            Support: ▓<&sp><&r>
        HoverNP: "<&2>R<&a>eal <&2>N<&a>ame<&2>: <&e><player.name><&nl><proc[Colorize].context[Click to Report Issue|yellow]>"
        CmdNP: "snp message: "
    Producers:
        Prefix:
            Developer: ▓<&sp>
            Architect: ▓<&sp>
            Constructor: ▓<&sp>
            Builder: ▓<&sp>
        HoverNP: "<&2>R<&a>eal <&2>N<&a>ame<&2>: <&e><player.name><&nl><proc[Colorize].context[Click to Private Message|yellow]>"
        CmdNP: "msg <player.name> "
    Public:
        Prefix:
            Sponsor: ""
            Patron: ""
            Visitor: <&2>[<&a>New<&2>]<&sp><&r>
            Silent: ""
            Muted: <&4>[<&c>Muted<&4>]<&sp><&r>
        HoverNP: "<&2>R<&a>eal <&2>N<&a>ame<&2>: <&e><player.name><&nl><proc[Colorize].context[Click to Private Message|yellow]>"
        CmdNP: "msg <player.name> "
