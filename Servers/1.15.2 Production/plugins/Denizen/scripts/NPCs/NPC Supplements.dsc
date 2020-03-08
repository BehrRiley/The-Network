NPC_Interaction:
    type: task
    debug: true
    definitions: Option|NPC
    script:
        #- define ExcludeOptions <player.flag[interaction.npc.]>
        - define Options <script[<[NPC]>].yaml_key[Options.<[Option]>]>
        - define ActiveNPCs <player.flag[interaction.npc]||<list[]>>
        - define NPCFlags <[ActiveNPCs].parse[split[/].get[4]].filter[is[==].to[<[NPC]>]]>

        - if <player.has_Flag[interaction.npc]>:
            - flag player interaction.options:!|:<[ActiveNPCs].exclude[<[NPCflags]>].exclude[<player.flag[interaction.dedoption]>]>
        - else:
            - flag player interaction.npc:<[NPC]>
            - flag player interaction.dedoption:!
            - flag player interaction.options:!|:<[ActiveNPCs].exclude[<[NPCflags]>]>
        
        - wait 2s
        - inject Option_Builder Instantly

    Assignment:
        #@ Enable triggers
        - trigger name:click state:true
        - trigger name:proximity state:true radius:4

        #@ Check for saved skins
        - if <server.has_flag[npc.skin.<queue.script.name>]>:
            - adjust <npc> skin_blob:<server.flag[npc.skin.<queue.script.name>]>
        - else:
            - narrate "<proc[Colorize].context[No NPC skin saved for:|red]> <&6>'<&e><queue.script.name><&6>'"
    Exit:
        - narrate <queue.script.name>
        - if <player.flag[interaction.npc].contains[<queue.script.name>]||false>:
            - flag player interaction.npc:<-:<queue.script.name>
    Click:
        #@ QuickClick mechanic
        - if <player.has_flag[interaction.quickclick]>:
            - queue <player.flag[interaction.quickclick].as_queue> stop
            - flag player interaction.quickclick:!
            - inject <queue.script> path:Dialogue.generic
            - stop
        - flag player interaction.quickclick:<queue> duration:1s

        #- wait 10t

        #@ Run generic dialogue
        - if <player.flag[interaction.npc].contains[<queue.script.name>]||false>:
            - flag player interaction.npc:<-:<queue.script.name>
            
        - inject <queue.script> path:Dialogue.Generic

Interaction_Handlers:
    type: world
    debug: false
    events:
        on player logs out:
            - flag player interaction.npc:!
        
