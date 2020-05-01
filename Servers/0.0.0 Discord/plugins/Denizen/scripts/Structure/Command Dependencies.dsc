# % ███████████████████████████████████████████████████████████
# @ ██    Handler Definitions Required: Group|Author
# @ ██    Script  Definitions Required: Command
# % ██
# @ ██    Usage:  - Define Command "Help"
# @ ██            - Inject RoleCheck
RoleCheck:
    type: task
    debug: false
    script:
        #@ Define Permissions
        - Define RolePermissions <script[<[Command]>_DCommand].yaml_key[RolePermission]>

        #@ Check Permission
        - if !<[Author].roles[<[Group]>].parse[name].contains_any[<[RolePermissions]>]||false> || <[RolePermissions].contains[Everyone]>:
            - define Permission true

# % ███████████████████████████████████████████████████████████
# @ ██    Script  Definitions Required: MaxArgs
# % ██
# @ ██    Usage:  - define MaxArgs 3
# @ ██            - inject ArgSizeCheck
ArgSizeCheck:
    type: task
    debug: false
    script:
        #@ Check Size
        - if <[Args].size||0> > <[MaxArgs]>:
            - stop
        - foreach <[Args]> as:Arg:
            - define Arg<[Loop_Index]> <[Arg]>

# % ███████████████████████████████████████████████████████████
# @ ██    Handler Definitions Required: 
# @ ██    Script  Definitions Required: 
# % ██
# @ ██    Usage:  - 
# @ ██            - 
Template:
    type: task
    debug: false
    script:
        #@ Define Permissions
        - execute

        #@ aaaaaa
        - execute