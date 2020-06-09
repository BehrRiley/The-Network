Nickname_Command:
    type: command
    name: nickname
    debug: false
    description: Changes your display name.
    admindescription: Changes a your own or another player's display name.
    usage: /nickname <&lt>Nickname<&gt>
    adminusage: /nickname (Player) <&lt>Nickname<&gt>
    permission: Behr.Essentials.Nickname
    adminpermission: Behr.Essentials.Nickname.others
    aliases:
        - nick
    tab complete:
        - if <player.groups.contains[Moderation]>:
            - inject Online_Player_Tabcomplete Instantly
    script:
    # @ ██ [  correct syntax? ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax Instantly

    # @ ██ [  one or two args? ] ██
        - if <context.args.size> == 1:
            - define User <player>
            - define Nickname <context.args.get[1]>
        - else:
            - inject Admin_Verification
            - define User <context.args.get[1]>
            - inject Player_Verification_Offline Instantly
            - define Nickname <context.args.get[2]>
                    
    # @ ██ [  same nickname ? ] ██
        - if <[Nickname].parse_color> == <[User].flag[Behr.Essentials.Display_Name]||>:
            - narrate "Nothing interesting happens."
            - inject Command_Error
    # @ ██ [  alphanumerical ? ] ██
        - if !<[Nickname].matches[[a-zA-Z0-9-_\&]+]>:
            - define reason "Nicknames should be alphanumerical."
            - inject Command_Error
    # @ ██ [  No name ? ] ██
        - if <[Nickname].parse_color.strip_color.length> < 1:
            - define reason "Nickname must have letters."
            - inject Command_Error
    # @ ██ [  too long ? ] ██
        - if <[Nickname].parse_color.strip_color.length> > 16:
            - define reason "Nicknames should be less than 16 charaters."
            - inject Command_Error
    # @ ██ [  blacklisted ? ] ██
        - if <[Nickname].contains[&k]>:
            - define reason "Obfuscated names are blacklisted."
            - inject Command_Error
        - define Blacklist "<server.list_players.filter[in_group[moderation]].parse[name].include[Admin|a d m i n|owner|owna|administrator|moderator|server|behr_riley|Founder|Mod|Admin|Helper]>"
        - if <[Nickname].contains_any[<[Blacklist]>]>:
            - define reason "Illegal Name."
            - inject Command_Error
        - if <[Nickname].parse_color.strip_color.contains_any[<[Blacklist]>]>:
            - define reason "Illegal Name."
            - inject Command_Error

    # @ ██ [  resetting ? ] ██
        - if <[Nickname]> == <[User].name> || <list[Clear|Reset|Remove|Delete|Default].contains[<[Nickname]>]>:
            - define Hover "<proc[Colorize].context[Click to change nickname.|green]><&nl> <&r><[User].name>"
            - define Text "<proc[Colorize].context[Nickname Reset to|yellow]> <&r><[User].name><&e>."
            - define Command "nick "
            - narrate targets:<[User]> <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
            - adjust <[User]> display_name:<[User].name>
            - flag <[User]> Behr.Essentials.Display_Name:!
            - stop

        - define Hover "<proc[Colorize].context[Click to reset to:|green]><&nl> <&r><[User].display_name>"
        - define Text "<proc[Colorize].context[Your nickname has been changed to:|green]> <&r><[Nickname].parse_color>"
        - define Command "nick <[User].display_name.escaped.replace[&ss].with[&]>"
        - narrate targets:<[User]> <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - if <[User]> != <player>:
            - narrate "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s nickname changed to:|green]> <&r><[Nickname].parse_color>"
        - adjust <[User]> display_name:<[Nickname].parse_color>
        - adjust <[User]> name:<[Nickname].parse_color>
        - flag <[User]> Behr.Essentials.Display_Name:<[Nickname].parse_color>
