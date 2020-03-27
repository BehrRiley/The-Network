reloadscripts:
    type: command
    name: reloadscripts
    debug: false
    permission: behrry.development.reloadscripts
    aliases:
        - /r
    script:
        - reload

rh:
    type: world
    debug: false
    events:
        on reload scripts:
            - if <server.match_player[behr]||null> != null:
                - if <context.had_error>:
                    - narrate targets:<server.match_player[behr_riley]> "<&c>Reload Error"
                - else:
                    - narrate targets:<server.match_player[behr_riley]> "<&a>Reloaded"
