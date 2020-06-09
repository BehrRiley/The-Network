RenameHome_Command:
    type: command
    name: renamehome
    debug: false
    description: Renames a specified home.
    permission: Behr.Essentials.Renamehome
    aliases:
      - h
    usage: /home <&lt>HomeName<&gt> (NewHomeName)
    tab complete:
        - define Args <player.flag[Behr.Essentials.Homes].parse[before[/]]>
        - inject OneArg_Command_Tabcomplete
    script:
    # @ ██ [  Verify args ] ██
        - if <context.args.size> > 2:
            - inject Command_Syntax Instantly

    # @ ██ [  Open GUI without args ] ██
        - if <context.args.is_empty>:
            - run Home_GUI Instantly def:Rename
            - stop

    # @ ██ [  Check for existing Homes ] ██
        - if !<player.has_flag[Behr.Essentials.Homes]>:
            - define reason "You have no Homes."
            - inject Command_Error

    # @ ██ [  Check first home ] ██
        - define Name <context.args.get[1]>
        - if !<player.flag[Behr.Essentials.Homes].parse[before[/]].contains[<[Name]>]||null>:
            - narrate "Home does not exist."
            - inject Command_Error

    # @ ██ [  Check for new name ] ██
        - if <context.args.get[2]||null> != null:
            - define NewName <context.args.get[2]>

        # @ ██ [  Check new home name ] ██
            - if <[Name]> == <[NewName]>:
                - define reason "Nothing interesting happens."
                - inject Command_Error
            - if <player.flag[Behr.Essentials.Homes].parse[before[/]].contains[<[NewName]>]||false>:
                - define reason "This home name already exists."
                - inject Command_Error
            - if !<[NewName].matches[[a-zA-Z0-9-_]+]>:
                - define reason "Home names should only be alphanumerical."
                - inject Command_Error
            - if <[NewName]> == Remove:
                - define reason "Invalid home name."
                - inject Command_Error
        
        # @ ██ [  Rename old to new ] ██
            - define Location <player.flag[Behr.Essentials.Homes].map_get[<[Name]>].as_location>
            - flag player Behr.Essentials.Homes:<-:<[Name]>/<[Location]>
            - flag player Behr.Essentials.Homes:->:<[NewName]>/<[Location]>
            - narrate "<&2>H<&a>ome <&6>[<&e><[Name]><&6>] <&2>R<&a>enamed<&2> <&2>t<&a>o<&2>: <&6>[<&e><[NewName]><&6>]"
            - stop

    # @ ██ [  Start chat listener ] ██
        - flag player Behr.Essentials.HomeRename:<[Name]>
        - narrate format:Colorize_green "Type a new Home Name."
        - while <player.is_online> && <player.has_flag[Behr.Essentials.HomeRename]>:
            - actionbar "<&2>Type a new Home Name<&a>. <&b>| <&7>'<&8>Cancel<&7>' <&8>to cancel."
            - wait 5s