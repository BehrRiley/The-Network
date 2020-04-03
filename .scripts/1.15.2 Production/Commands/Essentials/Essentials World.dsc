World_Command:
    type: command
    name: world
    debug: false
    description: Teleports you to the specified world.
    admindescription: Teleports you, or another player, to the specified world.
    usage: /world <&lt>WorldName<&gt>
    adminusage: /world (Player) <&lt>WorldName<&gt>
    permission: behrry.essentials.world
    tab complete:
        - define blacklist <list[World_Nether|World_The_End|Runescape50px1|Bandit-Craft]>
        - if <context.args.size||0> == 0:
            - determine <server.list_worlds.parse[name].exclude[<[Blacklist]>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_worlds.parse[name].exclude[<[Blacklist]>].filter[starts_with[<context.args.get[1]>]]>
    script:
        # @ ██ [ Check Args ] ██
        - if <context.args.size> != 1:
            - inject Command_Syntax Instantly

        # @ ██ [ Check if world is Blacklisted ] ██
        - define blacklist <list[World_Nether|World_The_End|Runescape50px1]>
        - define World <context.args.get[1]>
        - if <[Blacklist].contains[<[World]>]>:
            - if !<player.groups.contains_any[Coordinator|Administrator|Developer]>:
                - inject Command_Syntax Instantly
        
        # @ ██ [ Check if world is loaded ] ██
        - if !<server.list_worlds.parse[name].contains[<[World]>]>:
            - narrate "<&e><[World].to_titlecase> <proc[Colorize].context[is not currently loaded.|Red]>"
            # $ ██ [ To-Do:
            # - ██ | Check for world files, offer to create world if player has perms
            - stop

        # @ ██ [ Teleport player to the world ] ██
        - flag <Player> behrry.essentials.teleport.back:<player.location>
        - teleport <player> <world[<context.args.get[1]>].spawn_location>
        - narrate "<proc[Colorize].context[You were teleported to world:|green]> <context.args.get[1]>"
