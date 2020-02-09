# | ███████████████████████████████████████████████████████████
# % ██    /nick - for changing your nickname / display name
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | Admin capabilities
Nickname_Command:
    type: command
    name: nickname
    debug: false
    description: Changes your display name.
    admindescription: Changes a your own or another player's display name.
    usage: /nickname <&lt>Nickname<&gt>
    adminusage: /nickname (Player) <&lt>Nickname<&gt>
    aliases:
        - nick
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - if !<player.has_flag[behrry.essentials.tabofflinemode]>:
                - if <context.args.size||0> == 0:
                    - determine <server.list_online_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
            - else:
                - if <context.args.size||0> == 0:
                    - determine <server.list_players.parse[name].exclude[<player.name>]>
                - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                    - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
        # -██ [ correct syntax?
        - if <context.args.get[1]||null> == null || <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly
        # -██ [ one or two args?
        - if <context.args.get[2]||null> == null:
            - define User <player>
            - define Nickname <context.args.get[1]>
        - else:
            - if <player.groups.contains[Moderation]>:
                - define User <context.args.get[1]>
                - inject Player_Verification_Offline Instantly
                - define AdminRan True
            - else:
                - if <context.args.get[1]> == <player.name>:
                    - define User <player>
                - else:
                    - narrate "<proc[Colorize].context[You don't have permission to do that.|red]>"
                    - stop
            - define Nickname <context.args.get[2]>
                    
        # -██ [ same nickname ?
        - if <[Nickname].parse_color> == <[User].flag[behrry.essentials.display_name]||>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop
        # -██ [ alphanumerical ?
        - if !<[Nickname].matches[[a-zA-Z0-9-_\&]+]>:
            - narrate "<proc[Colorize].context[Nicknames should be alphanumerical.|red]>"
            - stop
        # -██ [ too long ?
        - if <[Nickname].parse_color.strip_color.length> > 16:
            - narrate "<proc[Colorize].context[Nicknames should be less than 16 charaters.|red]>"
            - stop
        # -██ [ blacklisted ?
        - if <[Nickname].contains_any[&k]>:
            - narrate "<proc[Colorize].context[Obfuscated names are blacklisted.|red]>"
            - stop
        - define Blacklist "<list[Admin|a d m i n|owner|owna|administrator|moderator]>"
        - if <[Nickname].parse_color.strip_color.contains_any[<[Blacklist]>]>:
            - narrate "<proc[Colorize].context[Illegal Name.|red]>"
            - stop

        # -██ [ resetting ?
        - if <[Nickname]> == <[User].name> || <list[Clear|Reset|Remove|Delete].contains[<[Nickname]>]>:
            - define Hover "<proc[Colorize].context[Click to change nickname.|green]><&nl> <&r><[User].name>"
            - define Text "<proc[Colorize].context[Nickname Reset to|yellow]> <&r><[User].name><&e>."
            - define Command "nick "
            - narrate targets:<[User]> <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
            - stop

        - define Hover "<proc[Colorize].context[Click to reset to:|green]><&nl> <&r><[User].name.display>"
        - define Text "<proc[Colorize].context[Your nickname has been changed to:|green]> <&r><[Nickname].parse_color>"
        - define Command "nick <[User].name.display.escaped.replace[&ss].with[&]>"
        - narrate targets:<[User]> <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - if <[AdminRan].exists>:
            - if <[User].has_flag[behrry.essentials.display_name]>:
                - narrate targets:<Player> "<[User].name.display> <&6>(<&e><[User].name><&6>)<proc[Colorize].context['s nickname changed to:|green]> <&r><[Nickname].parse_color>"
            - else:
                - narrate targets:<Player> "<&e><[User].name><proc[Colorize].context['s nickname changed to:|green]> <&r><[Nickname].parse_color>"

        - adjust <[User]> display_name:<[Nickname].parse_color>
        - flag <[User]> behrry.essentials.display_name:<[Nickname].parse_color>