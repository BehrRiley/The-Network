r:
    type: command
    name: r
    debug: false
    aliases:
        - /r
    script:
        - reload

rh:
    type: world
    debug: false
    events:
        on reload scripts:
            - if <context.had_error>:
                - narrate targets:<server.match_player[behr]> "<&c>Reload Error"
            - else:
                - narrate targets:<server.match_player[behr]> "<&a>Reloaded"