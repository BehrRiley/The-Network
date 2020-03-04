# | ███████████████████████████████████████████████████████████
# % ██     Essentials Main Structure
# | ██
# % ██    [ Chat Management ] ██
# $ ██    [ To-Do ]                     ██
Essentials:
    type: world
    debug: true
    events:
        on system time hourly:
            - execute as_server "acball 100"
        #on restart command:
        #    - bungeeexecute "send <bungee.server> MainHub"
        #on player breaks block in:NetherSpawn:
        #    - determine cancelled
        on player clicks block in:golden_shovel:
            #- if <context.location> == <location[29,64,197,Bees]>:
            - if <player.inventory.list_contents.parse[material.name].contains[golden_shovel]>:
                - stop
            - else:
                - give i@golden_shovel
                - execute as_op "claimbook <player.name>"
        on player logs in:
            - wait 1s
            #- run Chat_Channel_Load def:Global
            - if <player.has_flag[behrry.essentials.display_name]>:
                - adjust <player> display_name:<player.flag[behrry.essentials.display_name]>
            - if <player.in_group[Silent]>:
                - while !<player.groups.contains[Public]>:
                    - execute as_server "upc addgroup <player.name> Public"
                    - wait 5t
        on player quits:
            - flag player behrry.chat.lastreply:!
        on hanging breaks because obstruction:
                - determine cancelled
        on player right clicks Composter:
            - if <context.location.material.level> == 8 && <player.world.name> == Gielinor:
                - determine cancelled
        on player kicked:
            - if <context.reason> == "Illegal characters in chat":
                - determine cancelled
        on player dies:
            - flag player behrry.essentials.teleport.deathback:<player.location>
            - define key Behrry.Essentials.Cached_Inventories
            - define YamlSize <yaml[<player>].read[<[Key]>].size||0>
            - define UID <yaml[<player>].read[<[Key]>].get[<[YamlSize]>].before[Lasagna]||0>
            - if <[YamlSize]> > 9:
                - foreach <yaml[<player]>].read[<[Key]>].get[1].to[<[YamlSize].sub[9]>]>:
                    - yaml id:<player> set <[Key]>:<-:<[Value]>
            - yaml id:<player> set <[Key]>:->:<[UID].add[1]>Lasagna<player.inventory.list_contents>
            - yaml id:<player> savefile:data/pData/<player.uuid>.yml
        on player respawns:
            - if <player.flag[settings.essentials.bedspawn]||false> == true:
                - determine passively <player.bed_spawn>
            - else:
                - determine passively <player.world.spawn_location>
        on pl command:
            - determine passively fulfilled
            - narrate "Plguins (4): <&a>BehrEdit<&f>, <&a>BehrryEssentials<&f>, <&a>Citizens<&f>, <&a>Denizen<&f>"
        on resource pack status:
            #- narrate targets:<server.match_player[behr]> "<context.status>"
            - if <context.status> == accepted:
                - flag player Resource_Accepted duration:40s
            - if <context.status> == declined:
                - narrate "<&c>You must accept the resource pack. This does not affect textures - only moderation font specs."
                - wait 1s
                - narrate "<&c>Kicking in 25 seconds - please accept resource pack."
                - title "title:<&4>Warning" "subtitle:<&c>Please accept resource pack."
                - actionbar "<&4>This resource pack does not change game textures."
                - wait 5s
                - narrate "<&c>Tip: Edit Server > Server Resource Packs: ENABLED"
                - wait 20s
                - if !<server.has_flag[behrry.essentials.resourcecheckspam.<player>]>:
                    - flag server behrry.essentials.resourcecheckspam.<player> duration:1m
                    - announce format:Colorize_yellow "Player declined resource pack."
                - if <player.has_flag[Resource_Accepted]>:
                    - stop
                - kick <player> "reason:Must accept resource pack. This does not affect textures."
        on player changes gamemode:
            - if <player.has_flag[gamemode.inventory.changebypass]>:
                - flag player gamemode.inventory.changebypass:!
            - else:
                - flag player gamemode.inventory.<player.gamemode>:!|:<player.inventory.list_contents>
            - inventory clear
            - if <player.has_flag[gamemode.inventory.<context.gamemode>]>:
                - inventory set d:<player.inventory> o:<player.flag[gamemode.inventory.<context.gamemode>].as_list>
            - else:
                - flag player gamemode.inventory.<context.gamemode>:<player.inventory.list_contents>
        #on player damages player:
        #    - if <context.entity.gamemode||null> == creative:
        #        - if !<context.entity.has_flag[smacked]>:
        #            - define vector <context.entity.location.sub[<context.damager.location>].normalize.mul[0.5]>
        #            - adjust <context.entity> velocity:<def[vector].x>,0.4,<def[vector].z>
        #            - flag <context.entity> smacked duration:0.45s
        #        - playeffect effect:EXPLOSION_NORMAL at:<context.entity.location.add[0,1,0]> visibility:50 quantity:10 offset:0.5
        #        - playeffect effect:EXPLOSION_LARGE at:<context.entity.location.add[0,1,0]> visibility:50 quantity:1 offset:0.5

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
        - define Hover "<script[Ranks].yaml_key[<player.groups.get[1]>.HoverNP].parsed>"
        - define Text "<script[Ranks].yaml_key[<player.groups.get[1]>.Prefix.<player.groups.get[2]>].parsed><player.display_name><&r>"
        - define Command "<script[Ranks].yaml_key[<player.groups.get[1]>.CmdNP].parsed>"
        - define NamePlate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
        - define DiscordNamePlate "**<player.display_name>**"

    DiscordMessage:
        - define DiscordMessage "<[DiscordNamePlate]>: <context.message>"
        - discord id:GeneralBot message channel:593523276190580736 "<[DiscordMessage].parse_color.strip_color.replace[`].with['].replace[▲].with[<&lt>:pufferfish:681640271028551712<&gt>].replace[:pufferfish:].with[<&lt>:pufferfish:681640271028551712<&gt>]>"
    GlobalChatLog:
        - if <server.flag[Behrry.Essentials.ChatHistory.Global].size||0> > 24:
            - flag server Behrry.Essentials.ChatHistory.Global:<-:<server.flag[Behrry.Essentials.ChatHistory.Global].first>
        - flag server Behrry.Essentials.ChatHistory.Global:->:<[Message].escaped>
        #- define Channel 123
        #- discord id:GeneralBot message channel:<[Channel]>

    events:
        on player joins:
            - if <player.has_flag[behrry.protecc.prospecting]>:
                - flag player behrry.protecc.prospecting:!
            #@ Print the chat history
            - narrate <server.flag[Behrry.Essentials.ChatHistory.Global].parse[unescaped].separated_by[<&nl>]>

            #@ Format the message
            - if <bungee.server||BanditCraft> == BanditCraft:
                - define Server "Bandit Craft."
            - else:
                - define Server "The Test Server."
            - define Message "<player.flag[behrry.essentials.display_name]||<player.name>> <proc[Colorize].context[joined the network on:|yellow]> <&a><[Server]>"

            #@ Log the chat
            - define Log <[Message].escaped>
            - inject Chat_Logger Instantly

            #@ Discord relay to other servers
            - if <bungee.server||BanditCraft> == TestServer:
                - discord id:BehrBot message channel:681573237687058458 "►◄<[Message].escaped>"
            - else:
                - discord id:BehrBot message channel:681573237687058458 "◄►<[Message].escaped>"

            #@ Print to game chat
            - determine <[Message]>
            
        on player quits:
            #@ Cancel if player was kicked
            - if <player.has_flag[behrry.moderation.kicked]>:
                - determine NONE
                
            #@Format the Message
            - define Message "<player.flag[behrry.essentials.display_name]||<player.name>> <proc[Colorize].context[left the network.|yellow]>"

            #@Log to global chat
            - if <server.flag[Behrry.Essentials.ChatHistory.Global].size||0> > 24:
                - flag server Behrry.Essentials.ChatHistory.Global:<-:<server.flag[Behrry.Essentials.ChatHistory.Global].first>
            - flag server Behrry.Essentials.ChatHistory.Global:->:<[Message].escaped>

            #@Discord Relay to Other Servers
            - if <bungee.server||BanditCraft> == TestServer:
                - discord id:BehrBot message channel:681573237687058458 "►◄<[Message].escaped>"
            - else:
                - discord id:BehrBot message channel:681573237687058458 "◄►<[Message].escaped>"
            
            #@ Join Message Main Server
            - determine <[Message]>

        on player chats:
            - determine passively cancelled
            #@ NPC Check
            - if <player.has_flag[Interacting_NPC]>:
                - stop
            
            #@ Ignore Check
            #-

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
            
            #@ Print to Other Servers
            - if <bungee.list_servers.size||1> > 1:
                - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
                    - bungee <[Server]>:
                        - announce <[Message]>
            #@ Discord message
            #- inject locally DiscordMessage Instantly
            - if <bungee.list_servers.contains[TestServer]> && <bungee.server> != TestServer:
                - bungeerun TestServer Discord_Chat_Task def:<[DiscordNamePlate]>|<context.message.escaped>
            - else:
                - inject locally DiscordMessage Instantly
            

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
