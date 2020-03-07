            
Dialogue_Command:
    type: command
    name: dialogue
    debug: false
    description: Selects a dialogue option
    usage: /dialogue <&lt>#<&gt>
    permission: behrry.interaction.dialogue
    script:
        #@ Check for args or if Check for open dialogue
        - if <context.args.get[1]||null> == null || !<player.has_flag[interaction.options]>:
            - inject Command_Syntax Instantly

        #@ Check if uniquely ran
        - if <context.args.get[1].length> == 36 && <context.args.size> == 4:
            - define Arg <context.args.get[1]>
            - define Sel <context.args.get[2]>
            - define NPC <context.args.get[3]>
            - define Ind <context.args.get[4]>

            #@ Check for valid UUID
            - if !<player.flag[interaction.options].parse[split[/].get[3]].contains[<[Arg]>]>:
                - stop

            #@ Check if interacting with NPC
            - if !<script[<[NPC]>].list_keys[Selections].contains[<[Sel]>]||true>:
                - stop

            #@ Check if NPC has selection
            - if !<player.flag[interaction.npc].contains[<[NPC]>]||true>:
                - stop

            #@ Run selection, adjust flags
            - define Flag <player.flag[interaction.options].get[<[Ind]>]>
            - flag player interaction.options:!
            - flag player interaction.dedoption:|:<[Sel]>
            
            - inject <[NPC]> path:Selections.<[Sel]>
        - else:
        #@  Check if valid option
            - define Arg <context.args.get[1]>
            - define Options <player.flag[interaction.options]>
            - if !<[Options].is_integer> || <[Options].contains[.]> || <[Options].size> < <[Arg]> || 0 > <[Arg]>:
                - narrate format:Colorize_Red "Must be an option between 1-<[Options].size>."
                - stop
            - narrate success