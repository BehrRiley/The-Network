Coins_Command:
    type: command
    name: coins
    debug: false
    description: Tells you how many coins you or another player has.
    usage: /coins (Player)
    permission: Behrry.Economy.Coins
    aliases:
        - coin
        - money
        - bal
        - balance
    script:
    # @ ██ [  Check for args ] ██
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly

        - if <context.args.size> == 0:
            - if !<Player.has_flag[Behrry.Economy.Coins]>:
                - flag player Behrry.Economy.Coins:1
            - narrate "<&e>Coin Balance<&6>: <&a><player.flag[Behrry.Economy.Coins].format_number>"
        - else:
            - define User <context.args.get[1]>
            - inject Player_Verification_Offline Instantly
        
            - if !<[User].has_flag[Behrry.Economy.Coins]>:
                - flag <[User]> Behrry.Economy.Coins:1
            - narrate "<proc[User_Display_Simple].context[<[User]>]><&e>'s Coin Balance<&6>: <&a><[User].flag[Behrry.Economy.Coins].format_number>"