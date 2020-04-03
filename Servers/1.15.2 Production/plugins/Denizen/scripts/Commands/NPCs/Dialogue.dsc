            
Dialogue_Command:
    type: command
    name: dialogue
    debug: false
    description: Selects a dialogue option
    usage: /dialogue <&lt>#<&gt>
    permission: Behrry.Interaction.Dialogue
    aliases:
        - o
    #^  - d
    script:
    # @ ██ [ Check if Option Selection is active ] ██
        - if !<player.has_flag[Behrry.Interaction.ActiveOptions]>:
            - stop

    # @ ██ [ Check if Player ran command directly ] ██
        - else if <context.args.size> != 1:
            - if <context.args.get[2].length> != 36 || <context.args.size> != 5:
                - inject Command_Syntax Instantly
        - define OptionChoice <context.args.get[1]>

    # @ ██ [ Define Definitions ] ██
        - define Options <player.flag[Behrry.Interaction.ActiveOptions]>
        - define OptionsFiltered <[Options].filter[split[/].get[3].contains_any[<player.flag[Behrry.Interaction.ActiveNPC]>]]>
        
        - if !<[OptionsFiltered].parse[before[/]].contains[<[OptionChoice]>]>:
            - stop
        - define SelectedOption <[OptionsFiltered].map_get[<[OptionChoice]>].split[/]>
        
        - define ASS <[SelectedOption].get[2]>
        - define SEL <[SelectedOption].get[3]>
        - define NPC <[SelectedOption].get[4]>

        - flag player Behrry.Interaction.OptionsCooldown:|:<[ASS]>/<[SEL]> duration:30s
        - flag player Behrry.Interaction.ActiveOptions:!|:<[Options].exclude[<[OptionsFiltered]>]>

        - define ID <player.uuid>/<[NPC].script.name>/<[NPC].id>
        - inject <[ASS].as_script> path:Selections.<[SEL]> npc:<[NPC]>

#@DisguiseFix:
#@    type: world
#@    events:
#@        on d command bukkit_priority:lowest:
#^            - determine passively cancelled
#^            - define Alias d
#^            - inject Dialogue_Command Instantly
