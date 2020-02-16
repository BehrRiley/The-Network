# | ███████████████████████████████████████████████████████████
# % ██    /weather - Controls the weather
# | ██
# % ██  [ Command ] ██
Weather_Command:
    type: command
    name: weather
    debug: false
    description: turns on or off gamemode requesting for the specific gamemode
    usage: /weather <&lt>Gamemode<&gt> (On/Off) (Time)
    permission: behrry.essentials.weather
    tab complete:
        - define Arg1 <list[sunny|storm|thunder]>
        - if <context.args.size||0> == 0:
            - determine <[Arg1]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Arg1].filter[starts_with[<context.args.get[1]>]]>
    script:
        - narrate "incomplete"
