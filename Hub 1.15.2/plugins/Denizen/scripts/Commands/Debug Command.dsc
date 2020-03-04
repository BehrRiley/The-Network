debug_Command:
    type: command
    name: debug
    debug: true
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