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