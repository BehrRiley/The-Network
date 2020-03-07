Option_Builder:
    type: task
    debug: true
    script:
        - foreach <[Options]> as:Option:
            - define UUID <util.random.uuid>
            - define Hover "<&6>[<&e>Select<&6>]<&a> <[Option].split[/].limit[2].get[2]>"
            - define Message "<&6>[<&e>Click<&6>]<&a> <[Option].split[/].limit[2].get[2]>"
            #-               /dialogue   uuid    "option/.."                          npc     Loop_Index
            - define Command "Dialogue <[UUID]> <[Option].split[/].limit[2].get[1]> <[NPC]> <[Loop_Index]>"
            #-                                    Loop_Index  /  "option/.."                       / uuid   / npc
            - flag player interaction.options:|:<[Loop_Index]>/<[Option].split[/].limit[2].get[1]>/<[UUID]>/<[NPC]>
            - narrate <proc[MsgCmd].context[<[Hover]>|<[Message]>|<[Command]>]>
