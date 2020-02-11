# | ███████████████████████████████████████████████████████████
# % ██    //give Command for giving items
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | offline capabilities
Help_Command:
    type: command
    name: help
    debug: false
    description: Prints commands and command info.
    useage: /help (#)
    script:
        - execute as_server "denizen do_nothing"

Help_Handler:
    type: world
    debug: false
    events:
        on help command:
            - determine passively fulfilled
            - if <context.args.get[2]||null> != null:
                - inject Command_Syntax Instantly
            - if <context.args.get[1]||null> == null:
                - define HelpPage 1
            - else if <context.args.get[1].is_integer>:
                - define HelpPage <context.args.get[1]>
            - else:
                - inject Command_Syntax Instantly

            - define Commands <server.list_scripts.parse[name].filter[ends_with[_Command]]>
            - foreach <[Commands]> as:command:
                - if !<player.has_permission[<script[<[Command]>_Command].yaml_key[permission]>]>:
                    - foreach next
                - else:
                    - define CommandList:->:<[Command]>
                    
                           # + -------- /Help | Commands | Info -------- +"
                           # /command <args> (args) | Does this thing here
                           # + -------- [ ] Previous | Next [ ] -------- +"
            - define DP "<element[].pad_left[3].with[x].replace[x].with[<&2>-<&a>-]>"
            - define Header "+ <[DP]> <proc[Colorize].context[/Help | Commands | Info|Green]> <[DP]> +"
            - define Footer "+ <[DP]> <proc[Colorize].context[[x] Previous | Next [y]|Green]> <[DP]> +"
            - if <page is higher than 1>:
                - define Hover "<proc[Colorize].context[|green]>"
                - define Text "<6>[<e>symbol<&6>]"
                - define Command "Help <[HelpPage].add[1]>"
                - define Next "<proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"
                - define Previous "<darkgray>[<gray>symbol<darkgray>"
            - else if <page is last>:
                - define Next <darkgray>[<gray>symbol<darkgray>
                - define Hover "<proc[Colorize].context[|green]>"
                - define Text "<6>[<e>symbol<&6>]"
                - define Command Help "<[HelpPage].sub[1]>"
                - define Previous "<proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"
            - else if <page is lower than max> && <page is higher than 1>:
                - define Hover1 "<proc[Colorize].context[|green]>"
                - define Text1 "<6>[<e>symbol<&6>]"
                - define Command1 "Help <[HelpPage].add[1]>"
                - define Next "<proc[MsgCmd].context[<[Hover1]>|<[Text1]>|<[Command1]>]>"
                - define Hover2 "<proc[Colorize].context[|green]>"
                - define Text2 "<6>[<e>symbol<&6>]"
                - define Command2 Help "<[HelpPage].sub[1]>"
                - define Previous "<proc[MsgCmd].context[<[Hover2]>|<[Text2]>|<[Command2]>]>"
            - else:
                - define reason "Invalid Page Number."
                - inject Command_Error Instantly
            - define Footer <[Footer].replace[[x]].with[<[Previous]>].replace[[y]].with[<[Next]>]>
