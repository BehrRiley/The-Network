# | ███████████████████████████████████████████████████████████
# % ██    //give Command for giving items
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | offline capabilities
Help_Command:
    type: command
    name: help
    debug: false
    description: Prints eligible commands
    useage: /help
    script:
        - execute as_server "denizen do_nothing"

Help_Handler:
    type: world
    debug: false
    events:
        on help command:
            - determine passively fulfilled
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
            - define Footer "+ <[DP]> <proc[Colorize].context[[ ] Previous | Next [ ]|Green]> <[DP]> +"
