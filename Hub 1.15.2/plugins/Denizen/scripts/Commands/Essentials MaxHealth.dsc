# | ███████████████████████████████████████████████████████████
# % ██    /maxhealth - adjusts a player's max health
# | ██
# % ██  [ Command ] ██
MaxHealth_Command:
    type: command
    name: maxhealth
    debug: false
    description: Adjusts a player's max health up to 100.
    usage: /maxhealth <&lt>Player<&gt> <&lt>#<&gt>
    aliases:
        - maxhp
    permission: behrry.essentials.maxhealth
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_players.parse[name].exclude[<player.name>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
        - if <context.args.get[3]||null> != null:
            - inject Command_Syntax Instantly
        - if <context.args.get[2]||null> != null:
            - define User <context.args.get[1]>
            - inject Player_Verification Instantly
            - define NewHealth <context.args.get[2]>
        - else:
            - define User <player>
            - define NewHealth <context.args.get[1]>

        - if !<[NewHealth].is_integer>:
            - define Reason "Health is measured as a number."
            - inject Command_Error Instantly
        - if <[NewHealth]> < 1:
            - define Reason "Health cannot be negative or below 1."
            - inject Command_Error Instantly
        - if <[NewHealth].contains[.]>:
            - define Reason "Health cannot have a decimal."
            - inject Command_Error Instantly
        - if <[NewHealth]> > 100:
            - define Reason "Health can range up to 100."
            - inject Command_Error Instantly
    
        - adjust <[User]> max_health:<[NewHealth]>
        - narrate targets:<[User]> "<proc[Colorize].context[Maximum Health adjusted to:|green]> <&e><[NewHealth]>"
        - if <context.args.get[2]||null> != null:
            - narrate targets:<player> "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s Maximum Health set to:|green]> <&e><[NewHealth]>"
