# | ███████████████████████████████████████████████████████████
# % ██    /help Command for information on commands
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ 
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
            # Verify command syntax
            - determine passively fulfilled
            - if <context.args.get[2]||null> != null:
                - inject Command_Syntax Instantly
            - if <context.args.get[1]||null> == null:
                - define HelpPage 1
            - else if <context.args.get[1].is_integer>:
                - define HelpPage <context.args.get[1]>
            - else:
                - inject Command_Syntax Instantly

            # Verify Permissions | Build list
            - define Commands <server.list_scripts.parse[name].filter[ends_with[_Command]]>
            - foreach <[Commands]> as:command:
                - if !<player.has_permission[<script[<[Command]>_Command].yaml_key[permission]>]>:
                    - foreach next
                - else:
                    - define CommandList:->:<[Command]>
                
            # Setup Notes
            # + -------- /Help | Commands | Info -------- +"
            # /command <args> (args) | Does this thing here
            # + -------- [ ] Previous | Next [ ] -------- +"

            # Format Body
            # /command <args> (args) | Does this thing here
            
            # Distribute Pages
            - define Lines 6
            - define PageCount <[CommandList].size.div[<[Lines]>].round_up>
            - repeat <[PageCount]>:
                # 1,9,17,25
                # a_n=8(n-1)+1
                - define Math1 "<element[<[Lines]>].mul[<[value].sub[1]>].add[1]>"
                - define Math2 "<element[<[Lines]>].mul[<[value].sub[1]>].add[<[Lines].sub[1]>]>"
                - define CommandPage<[Value]> "<[CommandList].get[<[Math1]>].to[<[Math2]>]>"

            # Format Header
            # + -------- /Help | Commands | Info -------- +"
            - define DP "<element[].pad_left[3].with[x].replace[x].with[<&2>-<&a>-]>"
            - define Header "+ <[DP]> <proc[Colorize].context[/Help | Commands | Info|Green]> <[DP]> +"
            
            # Format Footer
            # + -------- [ ] Previous | Next [ ] -------- +"
            - define Footer "+ <[DP]> <proc[Colorize].context[[x] Previous | Next [y]|Green]> <[DP]> +"
            - if <[HelpPage]> > 1:
                - define Hover "<proc[Colorize].context[|green]>"
                - define Text "<6>[<e>symbol<&6>]"
                - define Command "Help <[HelpPage].add[1]>"
                - define Next "<proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"
                - define Previous "<darkgray>[<gray>symbol<darkgray>"
            - else if <[HelpPage]> == <[PageCount]>:
                - define Next <darkgray>[<gray>symbol<darkgray>
                - define Hover "<proc[Colorize].context[|green]>"
                - define Text "<6>[<e>symbol<&6>]"
                - define Command Help "<[HelpPage].sub[1]>"
                - define Previous "<proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"
            - else if <[HelpPage]> <= <[PageCount]> && <[HelpPage]> > 1:
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
            
            # Print
            - narrate <[Header]>
            - foreach <[CommandPage<[HelpPage]>]> as:Command:
                # <script[<[Command]>_Command].yaml_key[#####]>]>
                - define Hover "<proc[Colorize].context[Click to Insert:|green]><&nl><proc[Colorize].context[<[Command]>|Yellow]>"
                - define Text "<proc[Colorize].context[<[Command]>|Yellow]> <lightblue>| <&e><script[<[Command]>_Command].yaml_key[description]>]>"
                - define Command "<[Command]>"
                - narrate "<proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>"
            - narrate <[Footer]>
