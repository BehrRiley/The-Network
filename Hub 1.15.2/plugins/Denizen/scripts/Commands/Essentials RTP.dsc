# | ███████████████████████████████████████████████████████████
# % ██    /rtp - takes you to the rtp!
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script, create out of combat bypass | cooldown | Bypass monsters near
RTP_Command:
    type: command
    name: rtp
    debug: false
    description: Randomly teleports you
    usage: /rtp
    permission: behrry.essentials.rtp
    script:
        #@ Check for args
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly

        #@ Define integers
        - define distance 5000

        #@ Check world
        - if <player.world.name> != Bees:
            - narrate "<proc[Colorize].context[This cannot be done in this world.|red]>"
            - stop
        
        - cast levitation power:30 duration:1s
        - wait .8s
        #@ Define bad areas
        - define Blacklist <list[Lava|Water|Leaves|ice]>
        - repeat 100:
            - define x <util.random.int[-<[Distance]>].to[<[Distance]>]>
            - define z <util.random.int[-<[Distance]>].to[<[Distance]>]>
            - ~chunkload <location[<[x]>,0,<[z]>,<player.world.name>].chunk>
            - define Loc <location[<[x]>,0,<[z]>,<player.world.name>].highest>
            - if <[Loc].material.name.contains_any[<[Blacklist]>]>:
                #- narrate "Bad RTP, retrying... <[Loc].material.name>"
                - repeat next
            - else:
                - narrate "<proc[Colorize].context[Teleporting you randomly!|Green]>"
                - flag player behrry.essentials.teleport.back:<player.location>
                - teleport <player> <[Loc].add[0,50,0].with_pitch[90]>
                - cast SLOW_FALLING duration:20s power:1
                - repeat stop