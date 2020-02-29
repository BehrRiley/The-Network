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
        - define distance 4000

        #@ Check world
        - if <player.world.name> != Bees:
            - narrate "<proc[Colorize].context[This cannot be done in this world.|red]>"
            - stop
        
        #@ Check for cooldown
        - if <player.has_flag[behrry.essentials.rtpcooldown]>:
            - narrate "<proc[Colorize].context[You must wait:|red]> <player.flag[behrry.essentials.rtpcooldown].expiration.formatted>> <proc[Colorize].context[to RTP again.|red]>"
        
        - flag player behrry.essentials.rtpcooldown duration:1m
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