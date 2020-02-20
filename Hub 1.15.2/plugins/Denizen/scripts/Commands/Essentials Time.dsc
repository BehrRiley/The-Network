# | ███████████████████████████████████████████████████████████
# % ██    /Time - For setting the time
# | ██
# % ██  [ Command ] ██
Time_Command:
    type: command
    name: time
    debug: false
    description: Changes the time of day.
    usage: /time <&lt>Time of Day<&gt>/<&lt>0-23999<&gt>
    permission: behrry.essentials.time
    aliases:
        - nick
    tab complete:
        - define time <list[Start|Day|Noon|Sunset|Bedtime|Dusk|Night|Midnight|Sunrise|Dawn]>
        - if <context.args.size||0> == 0:
            - determine <[Time]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Time].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        - if <context.args.get[1].is_integer>:
            - define Int <context.args.get[1]>
            - if <[Int]> < 0:
                - narrate "<proc[Colorize].context[Time cannot be negative.|red]>"
            - if <[Int]> >= 24000:
                - narrate "<proc[Colorize].context[Time cannot exceed 23999.|red]>"
            - if <[Int].contains[.]>:
                - narrate "<proc[Colorize].context[Time cannot contain decimals.|red]>"
            - time <[Int]>
            - define Name <&e><[Int]>
        - else:
            - define Arg <context.args.get[1]>
            - choose <[Arg]>:
                - case Start:
                    - time 0
                    - define Name "<&e>Start"
                - case Day:
                    - time 1000
                    - define Name "<&e>Day"
                - case Noon:
                    - time 6000
                    - define Name "<&e>Noon"
                - case Sunset:
                    - time 11615
                    - define Name "<&e>Sunset"
                - case Bedtime:
                    - time 12542
                    - define Name "<&e>Bedtime"
                - case Dusk:
                    - time 12786
                    - define Name "<&e>Dusk"
                - case Night:
                    - time 13000
                    - define Name "<&e>Night"
                - case Midnight:
                    - time 18000
                    - define Name "<&e>Midnight"
                - case Sunrise:
                    - time 22200
                    - define Name "<&e>Sunrise"
                - case Dawn:
                    - time 23216
                    - define Name "<&e>Dawn"
                - case default:
                    - inject Command_Syntax Instantly
        - narrate "<proc[Colorize].context[Time set to:|green]> <[Name]>"
            
