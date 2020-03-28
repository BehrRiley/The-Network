Head_Command:
    type: command
    name: head
    description: Gives you a player's head.
    usage: /head <&lt>Name<&gt> (UUID)
    permission: behrry.essentials.head
    script:
    # @ ██ [  Check Args ] ██
        - if <context.args.get[1]||null> == null || <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly

    # @ ██ [  Check if specifying UUID ] ██
        - define PlayerName <context.args.get[1]>
        - if <context.args.get[2]||null> == null:
            - give player_head[skull_skin=<[PlayerName]>]
        - else:
            - define UUID <context.args.get[2]>
            - give player_head[skull_skin=<[PlayerName]>|<[UUID]>]




            