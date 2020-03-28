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

    # @ ██ [  Define settings ] ██
        - define Settings <list[settings.essentials.bedspawn]>
