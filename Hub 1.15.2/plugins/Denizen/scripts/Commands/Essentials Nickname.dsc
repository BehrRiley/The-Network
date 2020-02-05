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
        # -██ check if admin
        - if <context.args.size||0> == 0:
            - determine <server.list_online_players.parse[name]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
    script:
        # -██ [ blank ?
        - if <context.args.get[1]||null> == null || <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly

        # -██ [ targeting ?
        - if <context.args.get[2]||null> == null:
            - define Nickname <context.args.get[1]>
        - else:
            # -██ check if admin
            - define User <context.args.get[1]>
            - define Nickname <context.args.get[2]>
            - inject Player_Verification_Offline Instantly

        # -██ [ spam check ?
        #- if <[User].has_flag[]||<player.has_flag[]>>:
        #    - "You must wait X"
        #    - stop
        # -██ [ same check ?
        - if <[Nickname].parse_color> == <[User].flag[behrry.essentials.display_name]||<Player.flag[behrry.essentials.display_name]||>>:
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
        #- inject ProfanityCheck
        #- if <[Nickname].parse_color.strip_color.contains_any[<[Blacklist]>]>:
        #   - narrate "<proc[Colorize].context[Illegal Name.|red]>"
        #   - stop
        - define Blacklist "<list[Admin|a d m i n|mod|owner|owna|boss|leader|administrator]>"
        - if <[Nickname].parse_color.strip_color.contains_any[<[Blacklist]>]>:
            - narrate "<proc[Colorize].context[Illegal Name.|red]>"
            - stop

        # -██ [ resetting ?
        - if <[Nickname]> == <[User].name||<player.name>> || <list[Clear|Reset|Remove|Delete].contains[<[Nickname]>]>:
            - define Hover "<proc[Colorize].context[Click to change nickname.|green]><&nl> <&r><[User].name||<player.name>>"
            - define Text "<proc[Colorize].context[Nickname Reset to|yellow]> <&r><[User].name||<player.name>><&e>."
            - define Command "nick "
            - narrate targets:<[User]||<player>> <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
            - stop

        - define Hover "<proc[Colorize].context[Click to reset to:|green]><&nl> <&r><[User].name.display||<player.name.display>>"
        - define Text "<proc[Colorize].context[Your nickname has been changed to:|green]> <&r><[Nickname].parse_color>"
        - define Command "nick <[User].name.display.escaped.replace[&ss].with[&]||<player.name.display.escaped.replace[&ss].with[&]>>"
        - narrate targets:<[User]||<player>> <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>

        - adjust <[User]||<player>> display_name:<[Nickname].parse_color>
        - flag <[User]||<player>> behrry.essentials.display_name:<[Nickname].parse_color>