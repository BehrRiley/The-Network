KillAura_Command:
    type: command
    name: killaura
    debug: false
    description: Activates a kill-aura
    usage: /killaura (Player)
    permission: Behrry.Moderation.KillAura
    script:
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly
        
        - if <context.args.size> == 0:
            - define User <player>
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly
        
        - if <[User].has_flag[Behrry.Moderation.KillAura]>:
            - flag <[User]> Behrry.Moderation.KillAura:!
            - narrate "Deactivated"
            - stop
        - else:
            - flag <[User]> Behrry.Moderation.KillAura
            - narrate "Activated"
        - while <[User].has_flag[Behrry.Moderation.KillAura]>:
            - define Mobs <[User].location.find.entities[Zombie|Vex|Creeper|Spider|cave_spider|Phantom|Drowned|Slime|Skeleton|Pillager].within[35]>
            - remove <[Mobs]>
            - wait 3s

KillAura_Handler:
    type: world
    events:
        on player quits:
            - flag player Behrry.Moderation.KillAura:!