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
    permission: behrry.essentials.controlledflight
    aliases:
        - cfly
    tab complete:
        - define Arg1 <list[on|off]>
        - inject OneArg_Command_Tabcomplete Instantly
    script:
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly
        - define Arg <context.args.get[1]||null>
        - define ModeFlag "behrry.essentials.controlledflight"
        - define ModeName "Controlled flight"
        - inject Activation_Arg_Command Instantly
                
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