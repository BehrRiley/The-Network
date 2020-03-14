debug_Command:
    type: command
    name: debug
    debug: false
    description: Debugs the command you type.
    usage: /debug (run)/<&lt>commandname<&gt> (Args)
    permission: behrry.essentials.debug
    script:
        #@ Check for args
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        
        #@ Check if we're running a scriptname or command
        - if <context.args.get[1]> == run && <context.args.get[2]||null> != null && <context.args.get[2]> != debug:
            - if <context.args.get[3]||null> == null:
                - run <context.args.get[2]>
            - else:
                - run <context.args.get[2]> path:<context.raw_args.after[<context.args.get[1]><&sp>]>
            
        #@ check if they have a debug location
        - else:
            - execute as_op "denizen debug -r"
            - if <context.args.size> == 1:
                #@ /command
                - execute as_op "<context.args.get[1]>"
            - else:
                #@ /command arg1+
                - execute as_op "<context.args.get[1]> <context.raw_args.after[<context.args.get[1]><&sp>]>"
            - execute as_op "denizen submit"

Queue_Kill:
    type: command
    name: queue
    permission: behrry
    script:
        - define queue <queue.list.exclude[<queue>].get[1]>
        - queue <[queue]> stop


test:
    type: task
    debug: false
    script:
        - define Loc <player.location.sub[0,3,0]>
        - define Distance 100
        - define Frequency 4
        - repeat <[Distance]>:
            - define mod <[Value]>
            - if <[mod].is_even>:
                - repeat <[mod]>:
                    - define Loc <[Loc].sub[0,0,16]>
                    - chunkload <[Loc].chunk> duration:1s
                    - wait <[Frequency]>t
                - repeat <[mod]>:
                    - define Loc <[Loc].add[16,0,0]>
                    - chunkload <[Loc].chunk> duration:1s
                    - wait <[Frequency]>t
            - else:
                - repeat <[mod]>:
                    - define Loc <[Loc].add[0,0,16]>
                    - chunkload <[Loc].chunk> duration:1s
                    - wait <[Frequency]>t
                - repeat <[mod]>:
                    - define Loc <[Loc].sub[16,0,0]>
                    - chunkload <[Loc].chunk> duration:1s
                    - wait <[Frequency]>t
            - announce to_console "<&e>Completion<&6>:<&a> <[mod].div[<[Distance]>].round_to[5].mul[100]>%"
            #- announce to_console "<&e>Completion<&6>:<&a> <element[<[Mod]>].div[<[Distance].mul[<[Distance].sub[1].mul[2].div[2].add[1]>]>]>%"
        - announce to_console "<&a>Chunkloading Complete<&2>."


