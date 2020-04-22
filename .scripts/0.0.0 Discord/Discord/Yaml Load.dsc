Yaml_DCommand:
    type: task
    debug: false
    usage: /yaml <&lt>Create/Load/Reload<&gt> <&lt>ID<&gt> <&lt>File<&gt>
    todo: Set & Save usage
    syntax: /yaml <&lt>Create/Load/Reload<&gt> <&lt>ID<&gt> <&lt>File<&gt>
    description: Provides script dependency and helpful script blocks.
    definitions: Channel|Group|Message|Author
    RolePermission:
        - Developer
        - Coordinator
    script:
        - narrate test


ReceiveTest:
    type: task
    debug: false
    script:
        - flag server test:<server.list_players>
        - announce to_console <&c><queue.time_ran>"