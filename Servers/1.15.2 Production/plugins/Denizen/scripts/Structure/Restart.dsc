Restart_Handler:
    type: world
    debug: false
    events:
        on restart command:
            - determine passively fulfilled
            - inject Restart_Command
        on server start:
            - wait 5s
            - repeat 5:
                - if <bungee.server||null> == BanditCraft:
                    - bungeeexecute "send Discord BanditCraft"
                    - stop
                - else:
                    - wait 2s
        on system time minutely every:5:
            - if <util.date.time.hour.mod[12]> == 1 && <util.date.time.minute> == 55:
                - if <server.has_flag[behrry.essentials.restartskip]>:
                    - flag server behrry.essentials.restartskip:!
                    - narrate targets:<server.list_online_players.filter[in_group[Moderation]]> format:Colorize_yellow "Server restart queue skipped."
                    - stop
                - announce "<&6>{<&e>▲<&6>}-<&e>Server will restart in five minutes.<&6>-{<&e>▲<&6>}"
                - run Server_Restart_Task def:<duration[300]>|20


Server_Restart_Task:
    type: task
    debug: false
    definitions: time|speed
    Restart:
        - bossbar remove Restart
        - bungeeexecute "Send all Discord"
        - wait 3s
        - adjust server restart
    script:
        - define Time <[Time].as_duration>
        - define TimeInt <[Time].in_seconds>

        - define m <[Time].time.minute>
        - define s <[Time].time.second.pad_left[2].with[0]>
        - define Clock <&e><[m]><&6>:<&e><[s]>

        - bossbar create Restart players:<server.list_online_players> "title:<&4><&l>S<&c><&l>erver <&4><&l>R<&c><&l>estart<&4>: <[Clock]>" color:red progress:1
        - repeat <[TimeInt]>:
            - if <server.has_flag[behrry.essentials.restartskip]>:
                - announce format:Colorize_Green "Server Restart Skipped."
                - flag server behrry.essentials.restartskip:!
                - bossbar remove Restart
                - stop
            - wait <[Speed]>t

            - define Time <[Time].sub[1s]>
            - define m <[Time].time.minute>
            - define s <[Time].time.second.pad_left[2].with[0]>
            - define Clock <&e><[m]><&6>:<&e><[s]>
            - define Timer <[Time].in_seconds.div[<[TimeInt]>]>

            - bossbar update Restart players:<server.list_online_players> "title:<&4><&l>S<&c><&l>erver <&4><&l>R<&c><&l>estart<&4>: <[Clock]>" color:red progress:<[Timer]>
 
        - inject Locally Restart

quicktest:
    type: task
    script:
        - define dur <duration[10s]>
        - define sec <[Dur].in_seconds>
        - narrate <[Sec]>

