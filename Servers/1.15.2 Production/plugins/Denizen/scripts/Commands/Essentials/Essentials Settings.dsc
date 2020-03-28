settings_Command:
    type: command
    name: settings
    debug: false
    description: Adjusts your personal settings.
    usage: /settings (Setting (On/Off))
    permission: behrry.essentials.settings
    script:
    # @ ██ [  Check for args ] ██
        #- to-do: GUI
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly

    # @ ██ [  Define Settings ] ██
        - define Essentials <list[bedspawn]>
        - define ChatLogs <list[FirstJoined|Joined|Switched|Quit|Players]>
        - define Settings <list[]>

        - foreach <list[<[Essentials]>]> as:Flag:
            - if !<player.has_flag[Behrry.Essentials.<[Flag]>]>:
                - flag player Behrry.Essentials.<[Flag]>
            - define EssentialsFlags:->:Behrry.Essentials.<[Flag]>
        - foreach <list[<[ChatLogs]>]> as:Flag:
            - define ChatLogFlags:->:Behrry.Settings.ChatHistory.<[Flag]>
        - foreach <list[<[Settings]>]> as:Flag:
            - define ChatLogFlags:->:Behrry.Essentials.<[Flag]>
