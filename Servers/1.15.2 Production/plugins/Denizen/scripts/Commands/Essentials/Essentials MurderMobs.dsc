# | ███████████████████████████████████████████████████████████
# % ██    /murdermobs - from
# | ██
# % ██  [ Command ] ██
murdermobs_Command:
    type: command
    name: murdermobs
    debug: false
    description: Murders the mobs around all players.
    usage: /murdermobs
    permission: behrry.essentials.murdermobs
    script:
        #@ Check for args
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        
        #@ check if they have a murdermobs location
        - foreach <server.list_online_players> as:Player:
            - remove <[Player].location.find.entities[Creeper|skeletons|Enderman|Zombie].within[50]>



