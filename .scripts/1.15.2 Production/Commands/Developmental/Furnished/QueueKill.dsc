QueueKill_command:
    type: command
    name: queuekill
    description: Kills a named queue, or lists queues to kill.
    usage: /queuekill (QueueID)
    permission: behrry.essentials.queuekill
    script:
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly

        - if <queue.list.size> == 1:
            - narrate "<&c>No active queues."
            - stop

        - if <context.args.size> == 0:
            - foreach <queue.list> as:Queue:
                - define Hover "<&c>Click to kill Queue<&4>:<&nl><&a><[Queue].id><&nl><&e>Script<&6>: <&a><queue.script><&nl><&e>File<&6>: <&a><queue.script.filename>"
                - define Text "<&c>[<&4><&chr[2716]><&c>]<&e> <[Queue].id>"
                - define Command "QueueKill <[Queue].id>"
                - narrate <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - else:
            - if !<queue.exists[<context.args.get[1]>]>:
                - narrate "<&c>Queue has ended or does not exist."
                - stop
            - queue <queue[<context.args.get[1]>]> stop
            - narrate "<&e>Killed Queue<&6>: <&a><queue.list.exclude[<queue>].get[1]>"