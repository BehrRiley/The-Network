QueueKill_command:
    type: command
    name: queuekill
    description: Debugs the command you type.
    usage: /queuekill
    permission: behrry.essentials.queuekill
    script:
        - define queue <queue.list.exclude[<queue>].get[1]>
        - queue <[queue]> stop