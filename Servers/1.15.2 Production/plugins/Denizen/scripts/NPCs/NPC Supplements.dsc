NPC_Interaction:
    type: task
    debug: false
    definitions: Option|DeDupe
    script:
        - if <[DeDupe].exists>:
            - flag player Behrry.Interaction.OptionsCooldown:<-:<queue.split[/].get[2].as_script.name>/<[DeDupe]>
        - define NPC <npc[<queue.id.after_last[/]>]>
        - define Options <npc.script.yaml_key[Options.<[Option]>]>
        - wait 2s
        - inject Option_Builder Instantly
    Disengage:
        - if <player.has_flag[Behrry.Interaction.ActiveNPC]>:
            - if <player.flag[Behrry.Interaction.ActiveNPC].contains[<queue.script.name>]>:
                - flag player Behrry.Interaction.ActiveNPC:<-:<queue.script.name>
                - if <player.has_flag[Behrry.Interaction.ActiveOptions]>:
                    - flag player Behrry.Interaction.ActiveOptions:!
        - if <player.has_flag[Behrry.Interaction.ActiveOptions]>:
            - define Options <player.flag[Behrry.Interaction.ActiveOptions]>
            - define OptionsFiltered <[Options].filter[split[/].get[3].contains_any[<player.flag[Behrry.Interaction.ActiveNPC]>]]>
            - flag player Behrry.Interaction.ActiveOptions:!|:<[Options].exclude[<[OptionsFiltered]>]>
            - flag player Behrry.Interaction.OptionsCooldown:!
            - stop
    Assignment:
    # @ ██ [ Enable triggers                                             ] ██
        - trigger name:damage state:true
        - trigger name:click state:true
        - trigger name:proximity state:true radius:4

    # @ ██ [ Check for saved skins                                       ] ██
        - if <server.has_flag[Behrry.Meeseeks.Skin.<queue.script.name>]>:
            - adjust <npc> skin_blob:<server.flag[Behrry.Meeseeks.Skin.<queue.script.name>]>
        - else:
            - narrate "<proc[Colorize].context[No NPC skin saved for:|red]> <&6>'<&e><queue.script.name><&6>'"

    Exit:
        - inject Locally Disengage Instantly
    Click:
    # @ ██ [ QuickClick mechanic                                         ] ██
        - if <player.has_flag[Behrry.Interaction.ActiveNPC]>:
            - if <player.flag[Behrry.Interaction.ActiveNPC].contains[<queue.script.name>]> && <queue.script.list_keys[Dialogue].contains[QuickClick]> && <player.has_flag[Behrry.Interaction.QuickClick]> && <player.has_flag[Behrry.Interaction.Cooldown.ClickTrigger]>:
                - if <player.has_flag[Behrry.Interaction.Cooldown.QuickClickTrigger]>:
                    - stop
                - if <queue.list.contains[<player.flag[Behrry.Interaction.QuickClick].as_queue||null>]>:
                    - queue <player.flag[Behrry.Interaction.QuickClick].as_queue> stop
                    - flag player Behrry.Interaction.QuickClick:!
                - flag player Behrry.Interaction.Cooldown.QuickClickTrigger duration:2s
                - inject <queue.script> path:Selections.<queue.script.yaml_key[Dialogue.QuickClick]>
                - inject Locally Disengage Instantly
            - if <queue.script.list_keys[Dialogue].contains[QuickClick]>:
                - flag player Behrry.Interaction.QuickClick:<queue> duration:2s

    # @ ██ [ Check if player has a Quick-Chat option available           ] ██
        - if !<player.has_flag[Behrry.Interaction.ActiveNPC]>:
            - flag player Behrry.Interaction.ActiveNPC:->:<queue.script.name>
        - else if !<player.flag[Behrry.Interaction.ActiveNPC].contains[<queue.script.name>]>:
            - flag player Behrry.Interaction.ActiveNPC:->:<queue.script.name>
                
    # @ ██ [ Manual Click Trigger Cooldown                           [1] ] ██
    # % ██ | This is so we can have two separately timed checks          | ██
    # % ██ | One for regular chatter, and one for initiating QuickClicks | ██
        - if <player.has_flag[Behrry.Interaction.Cooldown.ClickTrigger]>:
            - stop

    # @ ██ [ Recursive Option Queue Cancel                               ] ██
        - foreach <queue.list.filter[contains[<player.uuid>]]> as:Queue:
            - queue <[Queue]> Stop

    # @ ██ [ Run generic dialogue                                        ] ██
        - flag player Behrry.Interaction.ActiveOptions:!
        - flag player Behrry.Interaction.OptionsCooldown:!
        - flag player Behrry.Interaction.Cooldown.ClickTrigger duration:2s
        - define ID <player.uuid>/<queue.script.name>/<npc.id>
        - inject <queue.script> path:Dialogue.Generic

Interaction_Handlers:
    type: world
    debug: false
    events:
        on player logs out:
        - inject NPC_Interaction path:Disengage Instantly