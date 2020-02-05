r:
    type: command
    name: r
    debug: false
    aliases:
        - /r
    script:
        - if <context.server>:
          - narrate "<proc[colorize].context[Nothing interesting happens.|yellow]>"
          - stop
        - reload

rh:
    type: world
    debug: false
    events:
        on reload scripts:
            - if <context.had_error>:
                - announce "<&c>Reload Error"
            - else:
                - announce "<&a>Reloaded"