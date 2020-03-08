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
        
        #@ check if they have a back location
        - if <player.has_flag[behrry.essentials.teleport.back]>:
            - define BackLoc <player.flag[behrry.essentials.teleport.back].as_location>
            - narrate format:Colorize_Green "Returning to last location"
            - flag <player> behrry.essentials.teleport.back:<player.location>
            - teleport <player> <[BackLoc]>
        - else:
            - narrate format:Colorize_Red "No back location to return to"



