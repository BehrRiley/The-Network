damage_handler:
    type: world
    debug: false
    events:
        on player damages entity:
            #@ Determine damage amount
            - define Damage <context.final_damage>
            - flag player behrry.skill.exp.cd:+:<context.final_damage> duration:1s
            - if <player.flag[Behrry.skill.exp.cd]||0> > 50:
                - stop
            
            - if <player.location.find.entities.within[5].size> > 25:
                - stop

            #@ Determine damage style
            - choose <context.cause>:
                - case projectile:
                    - run add_xp def:<[Damage]>|Ranged instantly
                - case entity_attack entity_sweep_attack:
                    - choose <player.flag[behrry.combat.attackstyle]||Accurate>:
                        - case accurate:
                            - run add_xp def:<[Damage]>|Attack instantly
                        - case aggressive:
                            - run add_xp def:<[Damage]>|Strength instantly
                        - case defensive:
                            - run add_xp def:<[Damage]>|Defense instantly
            - run add_xp def:<[Damage].div[3]>|Hitpoints instantly

Attack_Style:
    type: command
    name: AttackStyle
    debug: false
    description: Changes your attack style.
    usage: /AttackStyle (Accurate/Aggressive/Defensive)
    permission: behrry.combat.attackstyle
    script:
        - if <context.args.size||0> != 1:
            - inject Command_Syntax Instantly
        
        - define Style <context.args.get[1]>
        - if !<list[Accurate|Aggressive|Defensive].contains[<[Style]>]>:
            - inject Command_Syntax Instantly
        
        - choose <[Style]>:
            - case accurate:
                - narrate format:Colorize_Green "You are now fighting Accurately"
            - case aggressive:
                - narrate format:Colorize_Green "You are now fighting Aggressively"
            - case defensive:
                - narrate format:Colorize_Green "You are now fighting Defensively"
        - flag player behrry.combat.attackstyle:<[style]>



Highscores_Command:
    type: command
    name: highscores
    debug: false
    description: Checks the highscores
    usage: /highscores <&lt>Skill/Total<&gt>
    permission: behrry.combat.highscores
    script:
        #@ Verify args
        - if <context.args.size||0> != 1:
            - inject Command_Syntax Instantly

        #@ Verify Skill
        - define Skills <list[Attack|Strength|Defense|Ranged|Hitpoints]>
        - define Skill <context.args.get[1].to_titlecase>
        - if !<[Skills].contains[<[Skill]>]>:
            - inject Command_Syntax Instantly

        - define Players <server.list_players_flagged[behrry.skill.<[Skill]>.Level]>
        - define PlayersOrdered <[Players].sort_by_number[flag[behrry.skill.<[Skill]>.Level]].reverse>
        - define PlayerGet <[PlayersOrdered].get[1].to[8]>
        - narrate "<&2>+<&a>-------<&6>[<&e> HighScores <&6>] <&b>| <&6>[<&e> <[Skill]> <&6>]<&a>-------<&2>+"
        - foreach <[PlayerGet]> as:Player:
            - narrate "<proc[User_Display_Simple].context[<[Player]>]> <&b>| <&e> Level<&6>: <&a><[Player].flag[behrry.skill.<[Skill]>.Level]> <&b>| <&e> Exp<&6>: <&a><[Player].flag[behrry.skill.<[Skill]>.Exp].round>"
    
level_Command:
    type: command
    name: level
    debug: false
    description: Checks your level in a skill.
    usage: /level (Skill)
    permission: behrry.combat.level
    tab complete:
        - define arg1 <list[Attack|Strength|Defense|Hitpoints|Ranged]>
        - inject OneArg_Command_Tabcomplete Instantly
    script:
        #@ Verify args
        - if <context.args.size||0> > 1:
            - inject Command_Syntax Instantly

        #@ Verify Skill
        - define Skills <list[Attack|Strength|Defense|Ranged|Hitpoints]>
        - define Skill <context.args.get[1].to_titlecase>
        - if !<[Skills].contains[<[Skill]>]>:
            - inject Command_Syntax Instantly

        #@ Verify exists
        - if !<player.has_flag[behrry.skill.<[skill]>.Exp]>:
            - flag player behrry.skill.<[skill]>.Exp:0
        - if !<player.has_flag[behrry.skill.<[skill]>.ExpReq]>:
            - flag player behrry.skill.<[skill]>.ExpReq:0
        - if !<player.has_flag[behrry.skill.<[skill]>.Level]>:
            - flag player behrry.skill.<[skill]>.Level:1

        #@ Print Format
        - define Lvl <player.flag[behrry.skill.<[Skill]>.Level]>
        - define TotalExp <player.flag[behrry.skill.<[Skill]>.Exp].round>
        - define ExpReq <player.flag[behrry.skill.<[Skill]>.ExpReq].round>
        - define LvlExpReq <proc[xp_calc].context[<player.flag[behrry.skill.<[Skill]>.level]>]>

        - define SkillLevel "<&6>[<&e><[Skill]><&6>]<&e> level<&6>: <&a><[Lvl]>"
        - define Progress "<&e>Experience<&6>: <&a><[ExpReq]><&2>/<&a><[LvlExpReq]> <&b>| <&a><[ExpReq].div[<[LvlExpReq]>].round_to_precision[0.01].after[.]>%<&e> to level: <&a><[Lvl].add[1]>"
        - define TotalExperience "<&e>Total Experience<&6>: <&a><[TotalExp]>"

        - narrate "<[SkillLevel]> <&b>| <[TotalExperience]>"
        - narrate "<[Progress]>"
