# | ███████████████████████████████████████████████████████████
# % ██    /hide - returns you to where you teleported from
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script, create out of combat bypass | cooldown | Bypass monsters near
Hide_Command:
    type: command
    name: hide
    debug: false
    description: Hides you from players.
    usage: /hide (on/off)
    permission: behrry.moderation.hide
    script:
        #@ Check for args
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - define Arg <context.args.get[1]||null>
        - define ModeFlag "behrry.moderation.hide"
        - define ModeName "Invisibility mode"
        - inject Activation_Arg_Command Instantly

        - if <player.has_flag[behrry.moderation.hide]>:
            - adjust <player> hide_from_players
            - while <player.is_online> && <player.has_flag[behrry.moderation.hide]>:
                - actionbar "<&7>You are hidden from players."
                - wait 5s
        - else:
            - adjust <player> show_to_players
        - repeat 3:
            - playsound <player.location> sound:ENTITY_BLAZE_AMBIENT
            - playeffect effect:EXPLOSION_NORMAL at:<player.location.add[0,1,0]> visibility:50 quantity:10 offset:0.5
            - playeffect effect:EXPLOSION_LARGE at:<player.location.add[0,1,0]> visibility:50 quantity:1 offset:0.5

Hide_Handler:
    type: world
    debug: false
    events:
        on player damages entity:
            - if <player.has_flag[behrry.moderation.hide]>:
                - determine passively cancelled
                - narrate format:Colorize_Red "You cannot attack while hidden."