# | ███████████████████████████████████████████████████████████
# % ██    /droplock - 
# | ██
# % ██  [ Command ] ██
droplock_Command:
    type: command
    name: droplock
    debug: false
    description: locks drops unless you click them
    usage: /droplock
    permission: behrry.essentials.droplock
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - if <player.has_flag[behrry.essentials.droplock]>:
            - flag player behrry.essentials.droplock:!
            - narrate "Drop lock mode disabled."
        - else:
            - flag player behrry.essentials.droplock
            - narrate "Drop lock mode enabled."

Droplock_Handler:
    type: world
    debug: false
    events:
        on player picks up item:
            - if <player.has_flag[behrry.essentials.droplock]>:
                - if <player.has_flag[behrry.essentials.pickup]>:
                    - if <player.flag[behrry.essentials.pickup]> == <context.item>:
                        - stop
                - else:
                    - determine cancelled
Droplock_Handler0:
    type: world
    debug: false
    events:
        on player right clicks block:
            - if <player.has_flag[behrry.essentials.droplock]>:
                - define Block <player.location.precise_cursor_on.find.entities[DROPPED_ITEM].within[0.5].exclude[<player>]>
                - flag player behrry.essentials.pickup:<[Block].get[1]> duration:1t

