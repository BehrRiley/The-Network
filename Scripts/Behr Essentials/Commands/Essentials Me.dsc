Me_Command:
    type: command
    name: me
    usage: /me <&lt>Message<&gt>
    description: na
    permission: Behr.Essentials.Me
    script:
        - if <context.args.is_empty>:
            - inject Command_Syntax Instantly
            
        - announce "<&5><player.name> <context.raw_args.parse_color.strip_color>"
        