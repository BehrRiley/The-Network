Me_Command:
    type: command
    name: me
    usage: /me <&lt>Message<&gt>
    description: na
    permission: Behrry.Essentials.Me
    script:
        - if <context.args.size> == 0:
            - inject Command_Syntax Instantly
            
        - announce "<&5><player.name> <context.raw_args>"
        