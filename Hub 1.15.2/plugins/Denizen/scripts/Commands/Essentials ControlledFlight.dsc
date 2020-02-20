# | ███████████████████████████████████████████████████████████
# % ██    /controlledflight - Enters a controlled flight mode for precision hovering
# | ██
# % ██  [ Command ] ██
Controlledflight_Command:
    type: command
    name: controlledflight
    debug: false
    description: Enters a controlled flight mode for precision hovering
    usage: /controlledflight (on/off)
    aliases:
        - cfly
    permission: behrry.essentials.controlledflight
    Activate:
        - if <player.has_flag[behrry.essentials.controlledflight]>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - else:
            - flag player behrry.essentials.controlledflight
            - narrate "<proc[Colorize].context[Controlled flight Enabled.|green]>"
        
            #- spawn armor_stand[gravity=false;visible=false] <player.location> save:Seat
            #- define Entity <entry[Seat].spawned_entities.get[1]>
            #- wait 1t
            #- mount <player>|<[Entity]>
            #- flag <player> Essentials.flightentity:<[Entity]>
    Deactivate:
        - if !<player.has_flag[behrry.essentials.controlledflight]>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - else:
            - flag player behrry.essentials.controlledflight:!
            - narrate "<proc[Colorize].context[Controlled flight Enabled.|green]>"
    script:
        - choose <context.args.get[1]||null>:
            - case "on":
                - inject locally Activate Instantly
            - case "off":
                - inject locally Deactivate Instantly
            - case "null":
                - if <player.has_flag[behrry.essentials.controlledflight]>:
                    - inject locally Deactivate Instantly
                - else:
                    - inject locally Activate Instantly
            - case default:
                - inject Command_Syntax Instantly
                
#Controlled_Flight_Handler:
#    type: world
#    events:
#        on player steers entity:
#            - if <context.dismount>:
#                - remove <player.flag[Essentials.flightentity]>
#                - flag <player> Essentials.flightentity:!
#                - stop
#            - if <context.sideways> > 0.5:
#                - adjust 
#
#            - narrate <context.sideways>
#            - narrate <context.forward>
#            - narrate <context.jump>
#            - narrate <context.dismount>