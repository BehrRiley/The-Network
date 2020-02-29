World_Command:
    type: command
    name: world
    debug: false
    description: Teleports you to the specified world.
    usage: /world <&lt>WorldName<&gt>
    permission: behrry.essentials.world
    tab complete:
        - define blacklist <list[Bees_Nether|Bees_The_End|Runescape50px1]>
        - if <context.args.size||0> == 0:
            - determine <server.list_worlds.parse[name].exclude[<[Blacklist]>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_worlds.parse[name].exclude[<[Blacklist]>].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[1]||null> == null || <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly
        - define blacklist <list[Bees_Nether|Bees_The_End|Runescape50px1]>
        - define World <context.args.get[2]>
        - if <[Blacklist].contains[<[World]>]>:
            - inject Command_Syntax Instantly
        - if <[World]> == Creative:
            - adjust <player> gamemode:Creative
        - if <[World]> == Bees:
            - adjust <player> gamemode:Survival
        - teleport <player> <world[<context.args.get[1]>].spawn_location>
        - narrate "<proc[Colorize].context[You were teleported to world:|green]> <context.args.get[1]>"
