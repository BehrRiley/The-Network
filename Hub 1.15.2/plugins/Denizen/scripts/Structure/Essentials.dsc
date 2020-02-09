# | ███████████████████████████████████████████████████████████
# % ██     Essentials Main Structure
# | ██
# % ██    [ Chat Management ] ██
# $ ██    [ To-Do ]                     ██
Essentials:
    type: world
    debug: false
    events:
        on system time minutely every:15:
            - execute as_server "save-all"
        on system time hourly every:12:
            - adjust restart
        on restart command:
            - bungeeexecute "send <bungee.server> MainHub"
        on stop command:
            - bungeeexecute "send <bungee.server> MainHub"
        on player chats:
            - determine passively cancelled
            - if <player.has_flag[Interacting_NPC]>:
                - stop
            - define Hover "<script[Ranks].yaml_key[<player.groups.get[1]>.HoverNP].parsed>"
            - define Text "<script[Ranks].yaml_key[<player.groups.get[1]>.Prefix.<player.groups.get[2]>].parsed><player.name.display><&r>"
            - define Command "<script[Ranks].yaml_key[<player.groups.get[1]>.CmdNP].parsed>"
            - define NamePlate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
            - define Message "<[NamePlate]>: <context.message.parse_color>"
            #- discord id:GeneralBot Message channel:623742787615064082 "**[<player.groups.get[1]>]** <player.name.display.strip_color>: <context.message.strip_color>"
            - flag server Behrry.Essentials.ChatHistory.Global:->:<[Message].escaped>
            - announce <[Message]>
            #- bungeerun <bungee.list_servers.exclude[<bungee.server>]> Relay_Chat_Task def:Global|<[Message].escaped>
        on player logs in:
            - wait 1s
            #- run Chat_Channel_Load def:Global
            - if <player.has_flag[behrry.essentials.display_name]>:
                - adjust <player> display_name:<player.flag[behrry.essentials.display_name]>
        on player joins:
            - wait 1s
            - determine "<player.name.display> <proc[Colorize].context[joined the server.|green]>"
        on hanging breaks:
            - if <context.entitiy||> == <server.match_player[behr]||>:
                - stop
            - else if <context.cause> == obstruction:
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
            - yaml id:<player> set <[Key]>:->:<[UID].add[1]>Lasagna<context.inventory.list_contents>
            - yaml id:<player> savefile:data/pData/<player.uuid>.yml
        on pl command:
            - determine passively fulfilled
            - narrate "Plguins (5): <&a>BehrEdit<&f>, <&a>BehrryEssentials<&f>, <&a>Citizens<&f>, <&a>Denizen<&f>, <&a>Depenizen<&f>"
        on resource pack status:
            - narrate targets:<server.match_player[behr]> "<context.status>"
        on player changes gamemode:
            - flag player gamemode.inventory.<player.gamemode>:!|:<player.inventory.list_contents>
            - inventory clear
            - if <player.has_flag[gamemode.inventory.<context.gamemode>]>:
                - inventory set d:<player.inventory> o:<player.flag[gamemode.inventory.<context.gamemode>].as_list>
            - else:
                - flag player gamemode.inventory.<context.gamemode>:<player.inventory.list_contents>

Ranks:
    type: yaml data
    Moderation:
        Prefix:
            CMeme: <&a>☼<&sp>
            Administrator: ☼<&sp>
            Moderator: ☼<&sp>
            Support: ▓<&sp>
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
            Sponsor: <&sp>
            Patron: <&sp>
            Visitor: <&2>[<&a>New<&2>]<&sp>
            Silent: <&sp>
            Muted: <&4>[<&c>Muted<&4>]<&sp>
        HoverNP: "<&2>R<&a>eal <&2>N<&a>ame<&2>: <&e><player.name><&nl><proc[Colorize].context[Click to Private Message|yellow]>"
        CmdNP: "msg <player.name> "