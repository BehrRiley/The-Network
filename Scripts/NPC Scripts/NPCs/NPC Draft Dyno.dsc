Meeseeks:
    type: assignment
    debug: false
    actions:
        on assignment:
            - inject NPC_Interaction path:Assignment
        on exit proximity:
            - inject NPC_Interaction path:Exit
        on click:
            - inject NPC_Interaction path:Click
        on damage:
            - inject NPC_Interaction path:Click
    Dialogue:
        Generic:
            - if <npc.owner> == <player>:
                - run <npc.flag[Interaction.Dialogue.Generic.Owner]>
            - else:
                - run <npc.flag[Interaction.Dialogue.Generic.Player]>
    placeholder0:
        - choose <npc.flag[Interaction.Placeholder]>:
            - case Generic:
            - case QuickClick:
            - case Selection:
            - case Option:
    DialogueStages:
        - Dialogue
        - Wait
        - Selection
        - Trade
        - OpenShop
    Tasks:
        - Fetch
        - Go-To
        - Follow
        - Stay
        - Farm
        - Mine
        - Gather
    #^  - Run (1.5)
    #^  - Walk (1.35)