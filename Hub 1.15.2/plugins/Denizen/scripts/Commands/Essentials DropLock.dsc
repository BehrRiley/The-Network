# | ███████████████████████████████████████████████████████████
# % ██    /droplock - 
# | ██
# % ██  [ Command ] ██
droplock_Command:
    type: command
    name: droplock
    debug: false
    description: locks drops unless you click them
    permission: behrry.essentials.droplock
    usage: /droplock (on/off)
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <list[on|off]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <list[on|off].filter[starts_with[<context.args.get[1]>]]>
    Activate:
        - if <player.has_flag[behrry.essentials.droplock]>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - else:
            - flag player behrry.essentials.droplock
            - narrate "<proc[Colorize].context[Drop Lock  Enabled.|green]>"
    Deactivate:
        - if !<player.has_flag[behrry.essentials.droplock]>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - else:
            - flag player behrry.essentials.droplock:!
            - narrate "<proc[Colorize].context[Drop Lock Enabled.|green]>"
    script:
        - choose <context.args.get[1]||null>:
            - case "on":
                - inject locally Activate Instantly
            - case "off":
                - inject locally Deactivate Instantly
            - case "null":
                - if <player.has_flag[behrry.essentials.droplock]>:
                    - inject locally Deactivate Instantly
                - else:
                    - inject locally Activate Instantly
            - case default:
                - inject Command_Syntax Instantly

Droplock_Handler:
    type: world
    debug: false
    events:
        on player picks up item:
            #@ Check if player is in droplock mode
            - if <player.has_flag[behrry.essentials.droplock]>:
                #@ Check for unique pickup
                - if <player.has_flag[behrry.essentials.pickup]>:
                    #@ If the item is in the unique pickup list, allow pickup
                    - if <player.flag[behrry.essentials.pickup]> == <context.item>:
                        - stop
                - else:
                    - determine cancelled
        on player right clicks block:
            #@ Check if player is in droplock mode
            - if <player.has_flag[behrry.essentials.droplock]>:
                #@ Search for dropped items 0.5 blocks around the click location
                - define DroppedItems <player.location.precise_cursor_on.find.entities[DROPPED_ITEM].within[0.5].exclude[<player>]>
                - flag player behrry.essentials.pickup:->:<[DroppedItems]> duration:1t
