Restart_Handler:
    type: world
    debug: false
    events:
        on restart command:
        #    #- Send players to backup/lobby server
            - determine passively fulfilled
            - if <context.args.get[1]||null> == null || <context.args.get[4]||null> != null:
                - inject Command_Syntax Instantly
            - if !<list[Instant|Queue|Skip|Set].contains[<context.args.get[2]||null>]>:
                - inject Command_Syntax Instantly
            - run Restart_Command Instantly
        on stop command:
            - if <bungee.server> != TestServer:
                - bungeeexecute "send <bungee.server> TestServer"
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
        - execute as_server save-all
        - wait 5s
        - bossbar remove Restart
        - adjust server restart
        - narrate target:<server.match_player[behr]> "discard"
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
                - bossbar remove Restart
                - stop
            - wait <[Speed]>t

            - define Time <[Time].sub[1s]>
            - define m <[Time].time.minute>
            - define s <[Time].time.second.pad_left[2].with[0]>
            - define Clock <&e><[m]><&6>:<&e><[s]>
            - define Timer <[Time].in_seconds.div[<[TimeInt]>]>

            - bossbar update Restart players:<server.list_online_players> "title:<&4><&l>S<&c><&l>erver <&4><&l>R<&c><&l>estart<&4>: <[Clock]>" color:red progress:<[Timer]>
 
        - inject Locally Restart Instantly

quicktest:
    type: task
    script:
        - define dur <duration[10s]>
        - define sec <[Dur].in_seconds>
        - narrate <[Sec]>



# | ███████████████████████████████████████████████████████████
# % ██    /rtp - takes you to the rtp!
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██ | furnish script, create out of combat bypass | cooldown | Bypass monsters near
Restart_Command:
    type: command
    name: restart
    debug: false
    description: Restarts the server
    usage: /restart <&lt>Instant/Queue/Skip/Set<&gt> (Time (Speed))
    permission: behrry.moderation.restart
    tab complete:
        - define Arg1 <list[Instant|Queue|Skip|Set]>
        - inject OneArg_Command_Tabcomplete Instantly
    script:
        #@ Check for args
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly

        #@ Run sub-command
        - choose <context.args.get[1]>:
            - case Queue:
                #@ Check args
                - if <context.args.get[2]||null> == null:
                    - define Time <duration[300s]>
                    - define Speed 20

                - else:
                    #@ Check for speed
                    - if <context.args.get[3]||null> == null:
                        - define Speed 20

                    #@ Check speed format & values
                    - else:
                        - define Speed <context.args.get[3]>
                        - if !<[Speed].is_integer>:
                            - narrate format:Colorize_Red "Speed must be a valid number."
                            - stop
                        - if <[Speed].contains[.]>:
                            - narrate format:Colorize_Red "Speed cannot contain decimals."
                            - stop
                        - if <[Speed]> < 0:
                            - narrate format:Colorize_Red "Time cannot be negative."
                            - stop
                        - if <[Speed]> > 100:
                            - narrate format:Colorize_Red "Time cannot exceed 100 ticks."
                            - stop

                    #@ Check time format
                    - if <context.args.get[1].contains[.]>:
                        - narrate format:Colorize_Red "Time cannot contain decimals."
                        - stop
                    - define Time <duration[<context.args.get[2]>]||invalid>
                    - if <[Time]> == invalid:
                        - narrate format:Colorize_Red "Invalid time format."
                        - stop

                    #@ Check time values
                    - if <[Time].in_seconds> < 0:
                        - narrate format:Colorize_Red "Time cannot be negative."
                        - stop
                    - if <[Time].in_seconds> >= 1200:
                        - narrate format:Colorize_Red "Time cannot exceed 10 minutes."
                        - stop
                    
                - run Server_Restart_Task def:<[Time]>|<[Speed]>

            #@ Skip the next restart
            - case Skip:
                - if <context.args.get[2]||null> != null:
                    - inject Command_Syntax Instantly
                - flag server behrry.essentials.restartskip
            
            #@ Instantly restart the server
            - case Instant:
                - if <context.args.get[2]||null> != null:
                    - inject Command_Syntax Instantly
                - inject Server_Restart_Task path:Restart Instantly
            
            #@ Invalid sub-command
            - case default:
                - inject Command_Syntax Instantly