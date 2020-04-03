Option_Builder:
    type: task
    debug: false
    script:
        - foreach <[Options]> as:Option:
            - if <player.has_flag[Behrry.Interaction.OptionsCooldown]>:
                - if <player.flag[Behrry.Interaction.OptionsCooldown].parse[before[/]].contains[<queue.split[/].get[2].as_script.name>]> && <player.flag[Behrry.Interaction.OptionsCooldown].parse[after[/]].contains[<[Option].split[/].limit[2].get[1]>]>:
                    - foreach next
            - define UUID <util.random.uuid>
            - define Hover "<&6>[<&e>Select<&6>]<&a> <[Option].split[/].limit[2].get[2]>"
            - define Message "<&6>[<&e>Click<&6>]<&a> <[Option].split[/].limit[2].get[2]>"
            # $                       /  Loop_Index /   UUID  / Script Name           /  Selection                        /  NPC
            - define Command "dialogue <[Loop_Index]> <[UUID]> <queue.split[/].get[2]> <[Option].split[/].limit[2].get[1]> <[NPC]>"
            # $                                      /  Loop_Index   / UUID  / Script Name            /  Selection                        /  NPC
            - flag Behrry.Interaction.ActiveOptions:|:<[Loop_Index]>/<[UUID]>/<queue.split[/].get[2]>/<[Option].split[/].limit[2].get[1]>/<[NPC]> duration:10s
            - narrate <proc[MsgCmd].context[<[Hover]>|<[Message]>|<[Command]>]>
