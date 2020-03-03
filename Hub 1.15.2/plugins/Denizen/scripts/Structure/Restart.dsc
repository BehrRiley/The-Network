Restart_Handler:
    type: world
    debug: false
    events:
        on stop command:
            - if <bungee.server> != TestServer:
                - bungeeexecute "send <bungee.server> TestServer"
        on system time minutely every:5:
            - if <util.date.time.hour.mod[12]> == 2 && <util.date.time.minute> == 55:
                - announce "<&6>{<&e>▲<&6>}-<&e>Server will restart in five minutes.<&6>-{<&e>▲<&6>}"
                - inject Server_Restart_Task

Server_Restart_Task:
    type: task
    debug: true
    script:
        - flag server behrry.essentials.restartcountdown:<duration[5m]>
        - bossbar create Restart players:<server.list_online_players> "title:<&4><&l>S<&c><&l>erver <&4><&l>R<&c><&l>estart<&4>: <&e>00<&6>:<&e>00" color:red progress:1
        - repeat 90:
            - define flag <server.flag[behrry.essentials.restartcountdown].as_duration>
            - define m <[flag].time.minute>
            - define s <[flag].time.second.pad_left[2].with[0]>
            - define time <&e><[m]><&6>:<&e><[s]>
            - flag server behrry.essentials.restartcountdown:<[flag].sub[1s]>
            - bossbar update Restart players:<server.list_online_players> "title:<&4><&l>S<&c><&l>erver <&4><&l>R<&c><&l>estart<&4>: <[Time]>" color:red progress:<[Flag].in_seconds.div[300]>
            - wait 1s
        - bossbar remove Restart