# | ███████████████████████████████████████████████████████████
# % ██    /back - returns you to where you teleported from
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script, create out of combat bypass | cooldown | Bypass monsters near
back_Command:
    type: command
    name: back
    debug: false
    description: Returns you back to your last location.
    usage: /back
    permission: behrry.essentials.back
    script:
        #@ Check for args
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        #- blocking teleports with mobs is silly in survival, too much room for error
        #- define Blacklist <list[Blaze|Cave_Spider|Creeper|Drowned|Elder_Guardian|Ender_Dragon|Enderman|Endermite|Evoker|Ghast|Guardian|Husk|Illusioner|Magma_Cube|Phantom|Pillager|Ravager|Shulker|Silverfish|Skeleton|Slime|Cave_SpiderStray|Vex|Vindicator|Witch|Wither|Zombie]>
        #- if <player.location.find.entities[<[Blacklist]>].within[10].size> != 0:
        #    - narrate "<proc[Colorize].context[You cannot return with enemies near-by.|red]>"
        
        #@ check if they have a back location
        - if <player.has_flag[behrry.essentials.teleport.back]>:
            - define BackLoc <player.flag[behrry.essentials.teleport.back].as_location>
            - narrate "<proc[Colorize].context[Returning to last location.|green]>"
            - flag <player> behrry.essentials.teleport.back:<player.location>
            - teleport <player> <[BackLoc]>
        - else:
            - narrate "<proc[Colorize].context[No back location to return to.|red]>"



