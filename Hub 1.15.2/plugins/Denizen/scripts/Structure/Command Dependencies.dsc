# | ███████████████████████████████████████████████████████████
# % ██    Command Dependencies | Easy injections to complete scripts
# | ██
# % ██  [ Command Syntax Error & Stop ] ██
# % ██  [ Usage ] - inject Command_Syntax Instantly
Command_Syntax:
    type: task
    debug: false
    script:
        - define Command "<queue.script.yaml_key[aliases].get[1]||<queue.script.yaml_key[Name]>> "
        - define Hover "<proc[Colorize].context[Click to Insert:|Green]><proc[Colorize].context[<&nl> <queue.script.yaml_key[Usage].parsed>|Yellow]>"
        - define Text "<proc[Colorize].context[Syntax: <queue.script.yaml_key[Usage].parsed>|Yellow]>"
        - narrate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
        - stop


# % ██  [ Used a command wrongly, provide reason ] ██
# % ██  [ Usage ] - define Reason "no"
# % ██  [       ] - inject Command_Error Instantly
Command_Error:
    type: task
    debug: false
    script:
        - define Hover "<proc[Colorize].context[You typed:|red]><&r><&nl><&c>/<context.alias||<context.command>> <context.raw_args><&nl><&2>C<&a>lick to <&2>I<&a>nsert<&nl><&6>Syntax<&co> <queue.script.yaml_key[Usage].parsed>"
        - define Text "<proc[Colorize].context[<[Reason]>|red]>"
        - define Command "<queue.script.yaml_key[aliases].get[1]||<context.alias||<context.command>>> "
        - narrate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
        - stop

# % ██  [ Specifically not moderation, no permission message ] ██
# % ██  [ Usage ] - define Reason "no"
# % ██  [       ] - inject Admin_Permission_Denied Instantly
Admin_Permission_Denied:
    type: task
    debug: false
    script:
        - define Text "<proc[Colorize].context[You don't have permission to do that.|red]>"
        - define Hover "<proc[Colorize].context[Permission Required:|red]> <&6>Moderation"
        - narrate <proc[HoverMsg].context[<[Hover]>|<[Text]>]>
        - stop

# % ██  [ Verifies a player online ] ██
# % ██  [ Usage ]  - define User playername
# % ██  [       ]  - inject Player_Verification Instantly
Player_Verification:
    type: task
    debug: false
    ErrorProcess:
        - define Hover "<&6>Y<&e>ou <&6>E<&e>ntered<&co><&nl><&c>/<context.alias.to_lowercase> <context.raw_args>"
        - define Text "<proc[Colorize].context[Player is not online or does not exist.|red]>"
        - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
        - stop
    script:
        - if <server.match_player[<[User]>]||null> == null:
            - inject locally ErrorProcess Instantly
        - define User <server.match_player[<[User]>]>

# % ██  [ Verifies a player online or offline ] ██
# % ██  [ Usage ]  - define User playername
# % ██  [       ]  - inject Player_Verification_Offline Instantly
Player_Verification_Offline:
    type: task
    debug: false
    ErrorProcess:
        - define Hover "<&6>Y<&e>ou <&6>E<&e>ntered<&e>:<&nl><&c>/<context.command.to_lowercase> <context.raw_args>"
        - define Text "<proc[Colorize].context[Player does not exist.|red]>"
        - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
        - stop
    script:
        - if <server.match_player[<[User]>]||null> == null:
            - if <server.match_offline_player[<[User]>]||null> == null:
                - inject locally ErrorProcess Instantly
            - else:
                - define User <server.match_offline_player[<[User]>]>
        - else:
            - define User <server.match_player[<[User]>]>

# % ██  [ Easy display for PlayerNickname (PlayerName) / PlayerName ] ██
# % ██  [ Usage ]  - <proc[User_Display_Simple].context[<[User]>]>
User_Display_Simple:
    type: procedure
    debug: false
    definitions: User
    script:
        - if <[User].has_flag[behrry.essentials.display_name]>:
            - determine "<&r><[User].display_name||<[User].flag[behrry.essentials.display_name]>><&r> <proc[Colorize].context[(<[User].name>)|yellow]>"
        - else:
            - determine "<proc[Colorize].context[<[User].name>|yellow]>"

# % ██  [ Logging chat for global chat ] ██
# % ██  [ Usage ]  - define Log <LoggedText.escaped>
# % ██  [ Usage ]  - inject ChatLog Instantly
Chat_Logger:
    type: task
    debug: false
    script:
        - if <server.flag[Behrry.Essentials.ChatHistory.Global].size||0> > 24:
            - flag server Behrry.Essentials.ChatHistory.Global:<-:<server.flag[Behrry.Essentials.ChatHistory.Global].first>
        - flag server "Behrry.Essentials.ChatHistory.Global:->:<[Log]>"

# | ███████████████████████████████████████████████████████████
# % ██    Command Dependencies | Tab Completion
# | ██
# % ██  [ Tab-completes Players Online ] ██
# % ██  [ Usage ] - inject Online_Player_Tabcomplete Instantly
Online_Player_Tabcomplete:
    type: task
    debug: false
    script:
        - if !<player.has_flag[behrry.essentials.tabofflinemode]>:
            - if <context.args.size> == 0:
                - determine <server.list_online_players.parse[name].exclude[<player.name>]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
        - else:
            - if <context.args.size||0> == 0:
                - determine <server.list_players.parse[name].exclude[<player.name>]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>


# % ██  [ Usage ] - inject All_Player_Tabcomplete Instantly
All_Player_Tabcomplete:
    type: task
    debug: false
    script:
        - if <context.args.size> == 0:
            - determine <server.list_online_players.parse[name].exclude[<player.name>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>

# % ██  [ Usage ] - define Arg1 <list[option1|option2|option3]>
# % ██  [       ] - inject OneArg_Command_Tabcomplete Instantly
OneArg_Command_Tabcomplete:
    type: task
    debug: false
    script:
        - if <context.args.size||0> == 0:
            - determine <[Arg1]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg1].filter[starts_with[<context.args.get[1]>]]>

# % ██  [ Usage ] - define Arg1 <list[option1|option2|option3]>
# % ██  [       ] - define Arg2 <list[option1|option2|option3]>
# % ██  [       ] - inject OneArg_Command_Tabcomplete Instantly
TwoArg_Command_Tabcomplete:
    type: task
    debug: false
    script:
        - if <context.args.size||0> == 0:
            - determine <[Arg1]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg1].filter[starts_with[<context.args.get[1]>]]>
        - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg2]>
        - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg2].filter[starts_with[<context.args.get[2]>]]>

# % ██  [ Usage ] - define Arg1 <list[option1|option2|option3]>
# % ██  [       ] - define Arg2 <list[option1|option2|option3]>
# % ██  [       ] - define Arg# <list[option1|option2|option3]>
# % ██  [       ] - inject OneArg_Command_Tabcomplete Instantly
MultiArg_Command_Tabcomplete:
    type: task
    debug: false
    script:
        - if <context.args.size||0> == 0:
            - determine <[Arg1]>
        - foreach <context.args> as:Arg:
            - if <[Loop_Index]> == <context.args.size>:
                - if !<context.raw_args.ends_with[<&sp>]>:
                    - determine <[Arg<[Loop_Index]>].filter[starts_with[<context.args.get[<[Arg<[Loop_Index]>]>]>]]>
                - else if <[Arg<[Loop_Index].add[1]>].exists>:
                    - determine <[Arg<[Loop_Index].add[1]>]>
                - else:
                    - determine ''
            - else:
                - foreach next


# | ███████████████████████████████████████████████████████████
# % ██    Command Dependencies | Unique Command Features
# | ██
# % ██  [ Tab-completes Players Online ] ██
# % ██  [ Usage ] - inject Online_Player_Tabcomplete Instantly
