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
    usage: /help (#)
    permission: behrry.essentials.help
    tab complete:
        - determine ""
    script:
        - execute as_server "denizen do_nothing"

Help_Handler:
    type: world
    debug: false
    description: Prints commands and command info.
    usage: /help (#)
    permission: behrry.essentials.help
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
            
            - define Commands <server.list_scripts.parse[name].filter[ends_with[_Command]].alphabetical>

            # Verify Console Ran
            - if <context.source_type> == server:
                - foreach <[Commands]> as:command:
                    - define Syntax "<proc[Colorize].context[<script[<[Command]>].yaml_key[Usage].parsed||>|Yellow]>"
                    - define Description "<&b>| <&3><script[<[Command]>].yaml_key[description]||>"
                    - announce to_console "<[Syntax]> <[Description]>"
                - stop

            # Verify Permissions | Build list
            - foreach <[Commands]> as:command:
                - if !<player.has_permission[<script[<[Command]>].yaml_key[permission]||null>]>:
                    - foreach next
                - else:
                    - define CommandList:->:<[Command]>
                
            # Setup Notes
            # + -------- /Help | Commands | Info -------- +"
            # /command <args> (args) | Does this thing here
            # /command <args> (args) | Does this thing here
            # + -------- [ ] Previous | Next [ ] -------- +"

            # Format Body
            # /command <args> (args) | Does this thing here
            
            # Distribute Pages
            - define Lines 8
            - define PageCount <[CommandList].size.div[<[Lines]>].round_up>
            - if <[HelpPage]> > <[PageCount]>:
                - define reason "Invalid Page Number."
                - inject Command_Error Instantly
            - define Math1 "<element[<[Lines]>].mul[<[HelpPage].sub[1]>].add[1]>"
            - define Math2 "<element[<[Lines]>].mul[<[HelpPage].sub[1]>].add[<[Lines]>]>"
            - define CommandPage "<[CommandList].get[<[Math1]>].to[<[Math2]>]>"

            # Format Header
            # + -------- /Help | Commands | Info -------- +"
            - define DP "<element[].pad_left[6].with[x].replace[x].with[<&2>-<&a>-]>"
            - define PageDisplay "<&6>[<&e><[HelpPage]><&6>/<&e><[PageCount]><&6>]"
            - define Header "<&a>+ <[DP]> <proc[Colorize].context[/Help ~ Commands ~ Info|Green]> <[DP]> +"
            
            # Format Footer
            # + -------- [ ] Previous | Next [ ] -------- +"
            - define Footer "<&a>+ <[DP]> <proc[Colorize].context[Q Previous Z Next Y|Green]> <[DP]> +"
            - if <[HelpPage]> == 1:
                - define Previous "<&7>[<&8><&chr[25c0]><&7>]"

                - define Hover "<proc[Colorize].context[Click for Page:|green]><&nl><&6>[<&e>-<&chr[27a4]><&6>] <proc[Colorize].context[(<[HelpPage].add[1]>/<[PageCount]>)|yellow]> <&6>[<&e>-<&chr[27a4]><&6>]"
                - define Text "<&6>[<&e><&chr[27a4]><&6>]"
                - define Command "Help <[HelpPage].add[1]>"
                - define Next "<proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"

            - else if <[HelpPage]> > 1 && <[HelpPage]> < <[PageCount]>:
                - define Hover1 "<proc[Colorize].context[Click for Page:|green]><&nl><&6>[<&e><&chr[25c0]>-<&6>] <proc[Colorize].context[(<[HelpPage].sub[1]>/<[PageCount]>)|yellow]> <&6>[<&e><&chr[25c0]>-<&6>]"
                - define Text1 "<&6>[<&e><&chr[25c0]><&6>]"
                - define Command1 "Help <[HelpPage].sub[1]>"
                - define Previous "<proc[MsgCmd].context[<[Hover1]>|<[Text1]>|<[Command1]>]>"

                - define Hover2 "<proc[Colorize].context[Click for Page:|green]><&nl><&6>[<&e>-<&chr[27a4]><&6>] <proc[Colorize].context[(<[HelpPage].add[1]>/<[PageCount]>)|yellow]> <&6>[<&e>-<&chr[27a4]><&6>]"
                - define Text2 "<&6>[<&e><&chr[27a4]><&6>]"
                - define Command2 "Help <[HelpPage].add[1]>"
                - define Next "<proc[MsgCmd].context[<[Hover2]>|<[Text2]>|<[Command2]>]>"

            - else if <[HelpPage]> == <[PageCount]>:
                - define Hover "<proc[Colorize].context[Click for Page:|green]><&nl><&6>[<&e><&chr[25c0]>-<&6>] <proc[Colorize].context[(<[HelpPage].sub[1]>/<[PageCount]>)|yellow]> <&6>[<&e><&chr[25c0]>-<&6>]"
                - define Text "<&6>[<&e><&chr[25c0]><&6>]"
                - define Command "Help <[HelpPage].sub[1]>"
                - define Previous "<proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"

                - define Next "<&7>[<&8><&chr[27a4]><&7>]"

            - else:
                - define reason "Invalid Page Number."
                - inject Command_Error Instantly
            - define Footer <[Footer].replace[Q].with[<[Previous]>].replace[Y].with[<[Next]>].replace[Z].with[<[PageDisplay]>]>
            
            # Print
            - narrate <[Header]>
            - foreach <[CommandPage]> as:Command:
                # <script[<[Command]>].yaml_key[#####]>]>
                - define Hover "<proc[Colorize].context[Click to Insert:|green]><&nl><proc[Colorize].context[<script[<[Command]>].yaml_key[Usage].parsed>|Yellow]>"
                - define Text "<proc[Colorize].context[<script[<[Command]>].yaml_key[Usage].parsed>|Yellow]> <&b>&pipe <&3><script[<[Command]>].yaml_key[description]>"
                - define Command "<script[<[Command]>].yaml_key[name]> "
                - narrate "<proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>"
            - narrate <[Footer]>