# | ███████████████████████████████████████████████████████████
# % ██    /addfriend - Adds a player to your friends list.
# | ██
# % ██  [ Command ] ██
AddFriend_Command:
    type: command
    name: addfriend
    debug: false
    description: Adds a player to your friends list.
    usage: /addfriend <&lt>Player<&gt>
    permission: behrry.essentials.addfriend
    script:
        #@ Check for args
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        
        #@ Check for player
        - define User <context.args.get[1]>
        - inject Player_Verification_Offline
        
        #@ Check if player is already a friend
        - if <player.has_flag[behrry.essentials.friends]>:
          - if <player.flag[behrry.essentials.friends].contains[<[User]>:
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is already your friend.|red]>"
            - stop
        
        #@ Check if player is on ignore list
        - if <player.has_flag[behrry.essentials.ignorelist]>:
          - if <player.flag[behrry.essentials.ignorelist].contains[<[User]>]>:
            - narrate "<proc[User_Display_Simple].context[<[User]>]> <proc[Colorize].context[is on your ignore list.|red]>"
            - stop
        
        #@ Add player to friends list
        - flag player behrry.essentials.friends:->:<[User]>
