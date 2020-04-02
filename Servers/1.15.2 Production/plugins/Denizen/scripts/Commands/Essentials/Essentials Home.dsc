Home_Command:
    type: command
    name: home
    debug: false
    description: Teleports you to a home.
    admindescription: Teleports you to a home, or another player's home.
    permission: Behrry.Essentials.Home
    aliases:
      - h
    usage: /home <&lt>HomeName<&gt> (Remove/Relocate)
    adminusage: /home <&lt>player<&gt> <&lt>HomeName<&gt> (Remove)
    tab complete:
        - if <context.args.size||0> == 0:
          - determine <player.flag[Behrry.Essentials.Homes].parse[before[/]]||>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <player.flag[Behrry.Essentials.Homes].parse[before[/]].filter[starts_with[<context.args.get[1]>]]||>
        - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
            - determine "remove"
        - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
            - determine "remove"
    script:
    # @ ██ [  Verify args ] ██
        - if <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly

    # @ ██ [  Check for existing homes ] ██
        - if !<player.has_flag[Behrry.Essentials.Homes]>:
            - narrate "<proc[Colorize].context[You have no homes.|red]>"
            - stop

    # @ ██ [  Open Home GUI ] ██
        - if <context.args.get[1]||null> == null:
            - run Home_GUI Instantly def:Teleport
            - stop

    # @ ██ [  Check for two remove or relocate ] ██
        - if <context.raw_args.split[<&sp>].filter[is[==].to[remove]].size> == 2:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop
        - if <context.raw_args.split[<&sp>].filter[is[==].to[relocate]].size> == 2:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

    # @ ██ [  Check for both relocate and remove ] ██
        - if <context.raw_args.split.contains[remove]> && <context.raw_args.split.contains[relocate]>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

    # @ ██ [  Check for a remove or relocate arg if there's two args ] ██
        - if <context.args.size> == 2:
            - if <context.raw_args.split[<&sp>].filter[is[==].to[remove]].size.add[<context.raw_args.split[<&sp>].filter[is[==].to[relocate]].size>]> != 1:
                - inject Command_Syntax Instantly

    # @ ██ [  Define the home name and determine if removing ] ██
        - if <context.args.size> == 1:
            - define Name <context.args.get[1]>
            - define Remove false
            - define Relocate False
        - else:
            - if <context.raw_args.contains[remove]>:
                - if <context.args.get[1]> == remove:
                    - define Name <context.args.get[2]>
                - else:
                    - define Name <context.args.get[1]>
                - define Remove true
            - else:
                - if <context.args.get[1]> == remove:
                    - define Name <context.args.get[2]>
                - else:
                    - define Name <context.args.get[1]>
                - define Relocate true

    # @ ██ [  check if the home exists ] ██
        - if !<player.flag[Behrry.Essentials.Homes].parse[before[/]].contains[<[Name]>]>:
            - narrate "<proc[Colorize].context[That home does not exist.|red]>"
            - stop

    # @ ██ [  Define the home location ] ██
        - define Location <player.flag[Behrry.Essentials.Homes].map_get[<[Name]>].as_location>
        
    # @ ██ [  Run removal if removing ] ██
        - if <[Remove]>:
            - flag player Behrry.Essentials.Homes:<-:<[Name]>/<[Location]>
            - narrate "<&2>H<&a>ome <proc[Colorize].context[[<[Name]>]|yellow]> <&2>R<&a>emoved<&2>."
            - stop
        
    # @ ██ [  Run relocate if relocating ] ██
        - if <[Relocate]>:
            - flag player Behrry.Essentials.Homes:<-:<[Name]>/<[Location]>
            - define NewLocation <player.location.simple.as_location.add[0.5,0,0.5].with_yaw[<player.location.yaw>].with_pitch[<player.location.pitch>]>
            - flag <player> Behrry.Essentials.Homes:->:<[Name]>/<[NewLocation]>
            - narrate "<&2>H<&a>ome <proc[Colorize].context[[<[Name]>]|yellow]> <&2>R<&a>elocated<&2>."
            - stop

    # @ ██ [ Check if home world exists ] ██
        - if !<server.list_worlds.contains[<[Location].world>]>:
            - narrate format:Colorize_Red "World is not loaded."
            - stop

    # @ ██ [  Teleport to Home ] ██
        - flag <player> Behrry.Essentials.Teleport.Back:<player.location>
        - if !<[Location].chunk.is_loaded>:
            - chunkload <[Location].chunk> duration:20s
        - teleport <player> <[Location]>
        - narrate "<proc[Colorize].context[Teleported to:|green]> <&6>[<&e><[Name]><&6>]"

Home_GUI:
    type: task
    definitions: Selection
    debug: false
    script:
    # @ ██ [  Create GUI properties ] ██
        - define Title "My Homes"
        - define HomeCount <player.flag[Behrry.Essentials.Homes].size>
        - if <[HomeCount].div[9].round_up.add[1]> > 2:
            - define size 36
            - define Title "<[Title]> (1-27)"
        - else:
            - define Size <[HomeCount].div[9].round_up.mul[9].add[9]>
        
    # @ ██ [  Determine Action ] ██
        - choose <[Selection]>:
            - case Teleport:
                - define ActionLore "<&3>C<&b>lick <&3>t<&b>o <&3>T<&b>eleport"
            - case Rename:
                - define ActionLore "<&3>C<&b>lick <&3>t<&b>o <&3>R<&b>ename"
            - case HomeSelect:
                - define ActionLore "<&3>C<&b>lick <&3>t<&b>o <&3>S<&b>elect"
            - case Relocate:
                - define ActionLore "<&3>C<&b>lick <&3>t<&b>o <&3>R<&b>elocate"
            - case Delete:
                - define ActionLore "<&4>C<&c>lick <&4>t<&c>o <&4>D<&c>elete"

    # @ ██ [  Create Homelist ] ██
        - define Homes <player.flag[Behrry.Essentials.Homes]>
        #- define HomeList:->:<item[Blank]>
        - foreach <[Homes]> as:Home:
            - define Name <[Home].before[/]>
            - define Location <[Home].after[/]>
            - define Display "<&6>N<&e>ame<&6>: <&a><[Name]>"
            - define Lore "<list[<[ActionLore]>|<&6>W<&e>orld<&6>: <&a><[Location].world.name>|<&6>L<&e>ocation<&6>: <&6>[<&a><[location].x.round_up>,<[location].y.round_up>,<[location].z.round_up><&6>]]>"
            - define Item <item[compass].with[nbt=li@action/<[Selection]>|name/<[Name]>|location/<[Location]>;display_name=<[Display]>;lore=<[Lore]>]>
            - define HomeList:->:<[Item]>
        - repeat <[HomeCount].div[9].round_up.mul[9].sub[<[HomeList].size>]>:
            - define HomeList:->:<item[Blank]>

    # @ ██ [  Create Menu ] ██
        #- todo: HomeSelect
        - foreach <list[Teleport|Rename|Relocate|HomeSelect|Delete]> as:Option:
            - if <[Selection]> == <[Option]>:
                - define Display "<&6>[<&e>Selected<&6>]"
                - if <[Selection]> == Delete:
                    - define Item <item[magma_cream].with[enchantments=respiration,1;flags=HIDE_ALL]>
                - else:
                    - define Item <item[ender_eye].with[enchantments=respiration,1;flags=HIDE_ALL]>
            - else if <[Option]> != Delete:
                - define Display "<&8>[<&7>Click to Select<&8>]"
                - define Item <item[ender_pearl]>
            - else:
                - define Display "<&4>[<&c>Click to Select<&4>]"
                - define Item <item[fire_charge]>
            - choose <[Option]>:
                - case "Teleport":
                    - define Lore "<list[<proc[Colorize].context[[Teleport to Home]|blue]>|<proc[Colorize].context[Teleports you to a home.|green]>]>"
                - case "Rename":
                    - define Lore "<list[<proc[Colorize].context[[Rename Home]|blue]>|<proc[Colorize].context[Renames a home.|green]>]>"
                - case "Relocate":
                    - define Lore "<list[<proc[Colorize].context[[Relocate Home]|blue]>|<proc[Colorize].context[Relocates a home|green]>|<proc[Colorize].context[to your location.|green]>]>"
                - case "HomeSelect":
                    - define Lore "<list[<proc[Colorize].context[[Select Homes]|blue]>|<proc[Colorize].context[Selects a bunch of homes|green]>|<proc[Colorize].context[for group commands.|green]>]>"
                - case "Delete":
                    - define Lore "<list[<proc[Colorize].context[[Delete Home]|blue]>|<proc[Colorize].context[Permanently deletes a home.|red]>]>"
            - define HomeList:->:<[Item].with[display_name=<[Display]>;Lore=<[Lore]>;nbt=action/menu<[Option]>]>
        - repeat 3:
            - define HomeList:->:<item[Blank]>
        - define "Homelist:->:<item[ender_eye].with[display_name=<proc[Colorize].context[[Add Home]|yellow]>;nbt=li@action/menuAddHome]>"

        #- define SoftMenu <list[<[SelectHomes]>|<[Delete]>|<[ReLocate]>|<[ChangeDirection]>|<[Guide]>|<[WhereIs]>]>
        - note "in@generic[title=<[title]>;size=<[Size]>;contents=<[HomeList]>]" as:<player.uuid>HomeGUI
        - inventory open d:<player.uuid>HomeGUI
        - stop

HomeGUI_Handler:
    type: world
    debug: false
    events:
        on player clicks in inventory:
            - if <context.inventory.after[<player.uuid>]> == homegui:
                - determine passively cancelled
                - if <context.item.nbt[Action]||null> == null:
                    - stop
                - choose <context.item.nbt[Action]>:
                    - case "Teleport":
                        - execute as_player "home <context.item.nbt[name]>"

                    - case "Rename":
                        - execute as_player "renamehome <context.item.nbt[name]>"
                        - inventory close

                    - case "Relocate":
                        - execute as_player "home <context.item.nbt[name]> relocate"
                        - run Home_GUI Instantly def:Teleport
                    
                    - case "HomeSelect":
                        - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"

                    - case "Delete":
                        - if !<player.has_flag[Behrry.Essentials.HomeWarning]>:
                            - flag player Behrry.Essentials.Homewarning duration:1m
                            - narrate format:Colorize_Red "Are you sure you want to delete?"
                            - stop
                        - else:
                            - flag player Behrry.Essentials.HomeWarning:!
                            - execute as_player "home <context.item.nbt[name]> remove"
                            - run Home_GUI Instantly def:Teleport

                    - case "menuTeleport":
                        - run Home_GUI Instantly def:Teleport
                    - case "menuRename":
                        - run Home_GUI Instantly def:Rename
                    - case "menuRelocate":
                        - run Home_GUI Instantly def:Relocate
                    - case "menuHomeSelect":
                        - run Home_GUI Instantly def:HomeSelect
                    - case "menuDelete":
                        - run Home_GUI Instantly def:Delete
                    - case "menuAddHome":
                        - execute as_player "sethome Home<player.flag[Behrry.Essentials.Homes].size.add[1]||>"
                        - run Home_GUI Instantly def:Teleport

        on player drags in inventory:
            - if <context.inventory.contains[<player.uuid>]||false>:
                - determine passively cancelled
        on player drops:
            - if <player.inventory.contains[<player.uuid>]||false>:
                - determine passively cancelled
