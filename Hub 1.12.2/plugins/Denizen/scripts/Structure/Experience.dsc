# - ███ [  When a player is directly connected to event:                          ] ███
# | ███ [    - run add_xp def:<#>|<skill> instantly                               ] ███
# | ███ [   ex:run add_xp def:100|farming instantly                               ] ███
# - ███ [                                                                         ] ███
# - ███ [  When a player is NOT directly connected to the event:                  ] ███
# | ███ [    - run add_xp_nostring def:<#>|<skill>|<player> instantly             ] ███
# | ███ [   ex:run add_xp_nostring def:100|farming|<player[Behr_Riley]> instantly ] ███

# % ███ [ returns xp needed for next level                                        ] ███
xp_calc:
    type: procedure
    debug: false
    definitions: lvl
    script:
        - define pow_term <[lvl].div[7]>
        - define mul_term <element[300].mul[<element[2].power[<[pow_term]>]>]>
        - determine <[lvl].add[<[mul_term]>].div[4].round_down>

# % ███ [ Grants the provided amount of xp to a player                            ] ███
add_xp:
    type: task
    debug: false
    definitions: xp|skill
    script:
        - if !<player.has_flag[behrry.skill.<[skill]>.Exp]>:
            - flag player behrry.skill.<[skill]>.Exp:0
        - if !<player.has_flag[behrry.skill.<[skill]>.ExpReq]>:
            - flag player behrry.skill.<[skill]>.ExpReq:0
        - if !<player.has_flag[behrry.skill.<[skill]>.Level]>:
            - flag player behrry.skill.<[skill]>.Level:1
        - while <[xp]> > 0:
            - define xp_req <proc[xp_calc].context[<player.flag[behrry.skill.<[skill]>.Level]>]>
            - define to_add <[xp_req].sub[<player.flag[behrry.skill.<[skill]>.ExpReq]>]>
            - define xp <[xp].sub[<[to_add]>]>
            - if <[xp]> >= 0:
                - flag player behrry.skill.<[skill]>.Level:++
                - flag player behrry.skill.<[skill]>.ExpReq:0
                - narrate "Congratulations, you've just advanced a <&6><[skill]><&r> level. <&nl>Your <&6><[skill]><&r> level is now <&6><player.flag[behrry.skill.<[skill]>.Level]><&f>."
            - else:
                - flag player behrry.skill.<[skill]>.Exp:+:<[xp].add[<[to_add]>]>
                - flag player behrry.skill.<[skill]>.ExpReq:+:<[xp].add[<[to_add]>]>

# % ███ [ Grants the provided amount of xp to an unstrung player                  ] ███
add_xp_nostring:
    type: task
    debug: false
    definitions: xp|skill|player
    script:
        - if !<[player].has_flag[behrry.skill.<[skill]>.Exp]>:
            - flag <[player]> behrry.skill.<[skill]>.Exp:0
        - if !<[player].has_flag[behrry.skill.<[skill]>.ExpReq]>:
            - flag <[player]> behrry.skill.<[skill]>.ExpReq:0
        - if !<[player].has_flag[behrry.skill.<[skill]>.Level]>:
            - flag <[player]> behrry.skill.<[skill]>.Level:1
        - while <[xp]> > 0:
            - define xp_req <proc[xp_calc].context[<[player].flag[behrry.skill.<[skill]>.Level]>]>
            - define to_add <[xp_req].sub[<[player].flag[behrry.skill.<[skill]>.ExpReq]>]>
            - define xp <[xp].sub[<[to_add]>]>
            - if <[xp]> >= 0:
                - flag <[player]> behrry.skill.<[skill]>.Level:++
                - flag <[player]> behrry.skill.<[skill]>.ExpReq:0
                - narrate "targets:<[Player]> Congratulations, you've just advanced a <&6><[skill]><&r> level! <&nl>Your <&6><[skill]><&r> level is now <&6><[player].flag[behrry.skill.<[skill]>.Level]><&f>."
            - else:
                - flag <[player]> behrry.skill.<[skill]>.Exp:+:<[xp].add[<[to_add]>]>
                - flag <[player]> behrry.skill.<[skill]>.ExpReq:+:<[xp].add[<[to_add]>]>

Experience_Handler:
    type: world
    debug: false
    events:
        on player joins:
            - if !<player.has_flag[Behrry.skill.Hitpoints.level]>:
                - flag player behrry.skill.Hitpoints.Exp:1154
                - flag player behrry.skill.Hitpoints.Level:10

clearerQWAT:
    type: task
    script:
        #- foreach <list[attack|strength|defense|ranged]> as:Skill:
        - foreach <server.list_players> as:Player:
            #- flag <[Player]> behrry.skill.<[Skill]>.Exp:0
            #- flag <[Player]> behrry.skill.<[Skill]>.Level:1
            #- flag <[Player]> behrry.skill.<[Skill]>.ExpReq:0
            - if <[Player].flag[behrry.skill.Hitpoints.Level]||0> < 10:
                - flag <[Player]> behrry.skill.Hitpoints.Exp:1154
                - flag <[player]> behrry.skill.Hitpoints.Level:10
                - flag <[Player]> behrry.skill.Hitpoints.ExpReq:0
