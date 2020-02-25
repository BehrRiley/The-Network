# | ███████████████████████████████████████████████████████████
# % ██    /home name takes you to your home.
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script | tab complete GUI for homes on blank | transform flags into notable to make homes unique
Home_Command:
    type: command
    name: home
    debug: false
    description: Teleports you to a home.
    permission: behrry.essentials.home
    aliases:
      - h
      - homes
    usage: /home <&lt>HomeName<&gt> (Remove)
    tab complete:
        - if <context.args.size||0> == 0:
          - determine <player.flag[behrry.essentials.homes.name]||>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <player.flag[behrry.essentials.homes.name].filter[starts_with[<context.args.get[1]>]]||>
        - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
            - determine "remove"
        - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
            - determine "remove"
    script:
        #@ Check if arg1 is blank or if arg3 isn't blank
        - if <context.args.get[1]||null> == null || <context.args.get[3]||null> != null:
            #- define Title "My Homes"
            #- define HCount <player.flag[behrry.essentians.homes.name].size>
            #- if <[HCount].div[9].round_up.add[1]> > 5:
            #    - define size 5
            #    - define Title "<[Title]> "
            #- else:
            #    - define Size <[HCount].div[9].round_up.add[1]>
            #- define SoftMenu <list[<[SelectHomes]>|<[Delete]>|<[ReLocate]>|<[ChangeDirection]>|<[Guide]>|<[WhereIs]>]>
            #- note "in@generic[title=<[title]>;size=<[Size]>]" as:<player>HomeGUI
            #- inventory open d:HomeGUI
            - inject Command_Syntax Instantly 
        #@ Check for existing homes
        - if !<player.has_flag[behrry.essentials.homes.name]>:
            - narrate "<proc[Colorize].context[You have no homes.|red]>"
            - stop
        #@ Check for two remove args
        - if <context.raw_args.split[<&sp>].filter[is[==].to[remove]].size> == 2:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop
        #@ Check for a remove arg if there's two args
        #- todo: check below for low-key duplicate check
        - if <context.args.size> == 2 && <context.raw_args.split[<&sp>].filter[is[==].to[remove]].size> == 0:
            - inject Command_Syntax Instantly

        #@ Define the home
        #- todo: replace two individual flags with one map&key flag
        #- replace flag name:<player.flag[behrry.essentials.homes].parse[before[/]].find[<[Name]>]||null>
        #- replace flag ref:<player.flag[behrry.essentials.homes].parse[after[/]].find[<[Name]>]||null>
        - define Name <context.raw_args.split[<&sp>].filter[is[==].to[remove].not].get[1]||null>
        - define Ref <player.flag[behrry.essentials.homes.name].find[<[Name]>]||null>
        - define Location <player.flag[behrry.essentials.homes.location].get[<[Ref]>].as_location||null>
        
        #@ check if one of the two args are remove...
        #- todo: this check kinda exists already
        - if <context.args.get[1]||null> == remove || <context.args.get[2]||null> == remove:
            #@ check if the home exists
            #- replace flag <player.flag[behrry.essentials.homes].parse[before[/]].contains[<[Name]>]>:
            - if <player.flag[behrry.essentials.homes.name].contains[<[Name]>]>:
                - narrate "<&2>H<&a>ome <proc[Colorize].context[[<[Name]>]|yellow]> <&2>R<&a>emoved<&2>."
                #- replace flag - flag player behrry.essentials.homes:<-:<[Name]>/<[Location]>
                - flag player behrry.essentials.homes.name:<-:<[Name]>
                - flag player behrry.essentials.homes.location:<-:<[Location]>
            - else:
                - narrate "<proc[Colorize].context[That home does not exist.|red]>"
        - else:
            #@ check if the home exists
            - if <player.flag[behrry.essentials.homes.name].contains[<[Name]>]>:
                - flag <player> behrry.essentials.teleport.back:<player.location>
                - teleport <player> <[Location]>
                - narrate "<proc[Colorize].context[Teleported to:|green]> <&6>[<&e><player.flag[behrry.essentials.homes.name].get[<[Ref]>]><&6>]"
            - else:
                - narrate "<proc[Colorize].context[That home does not exist.|red]>"

#HomeGUI_Handler:
 #   type: world
 #   events:
 #       on player opens inventory:
 #       on player closes inventory:
 #       on player clicks in inventory:
 #       on player drags in inventory:
