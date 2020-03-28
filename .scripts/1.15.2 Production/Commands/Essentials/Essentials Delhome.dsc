# | ███████████████████████████████████████████████████████████
# % ██    /home name takes you to your home.
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script | tab complete GUI for homes on blank | Add admin controls to use other homes
DelHome_Command:
    type: command
    name: delhome
    debug: false
    description: Deletes a specified name.
    permission: behrry.essentials.delhome
    usage: /delhome <&lt>HomeName<&gt>
    tab complete:
        - if <context.args.size||0> == 0:
          - determine <player.flag[behrry.essentials.homes].parse[before[/]]||>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <player.flag[behrry.essentials.homes].parse[before[/]].filter[starts_with[<context.args.get[1]>]]||>
    script:
    # @ ██ [  Verify args ] ██
        - if <context.args.get[1]||null> == null || <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly

    # @ ██ [  Check for existing homes ] ██
        - if !<player.has_flag[behrry.essentials.homes]>:
            - narrate "<proc[Colorize].context[You have no homes.|red]>"
            - stop
    
    # @ ██ [  Re-Route Command ] ██
        - define Home <context.args.get[1]>
        - execute as_player "home <[Home]> remove"