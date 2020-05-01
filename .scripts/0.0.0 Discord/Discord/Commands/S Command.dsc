S_DCommand:
    type: task
    debug: false
    usage: /s <&lt>Script<&gt>
    syntax: /s <&lt>Script<&gt>
    description: Provides script dependency and helpful script blocks.
    definitions: Channel|Group|Message|Author
    RolePermission:
        - Developer
        - Coordinator
    script:
        # @ ██ [ Verify Syntax - "/s" ] ██
        - if !<[Message].starts_with[/script]> && !<[Message].starts_with[/s<&sp>]>:
            - stop

        # @ ██ [ Command Checks ] ██
        - Define Command "S"
        - Inject RoleCheck

        # @ ██ [ Define main definitions ] ██
        - define Scripts <yaml[DeveloperCodeBlocks].list_keys[]>
        - define Args <[Message].split[<&sp>].remove[1]||>

        # @ ██ [ Check args ] ██
        - define MaxArgs 1
        - inject ArgSizeCheck
        - if !<[Scripts].contains[<[Arg1]>]>:
            - stop
        - define index <yaml[DeveloperCodeBlocks].list_keys[].find[<[Arg1]>]>
        - define Yaml <yaml[DeveloperCodeBlocks].list_keys[].get[<[Index]>]>
        
        # @ ██ [ Organize Message ] ██
        - define CommandName <[Yaml].replace[_].with[<&sp>]>
        - define CommandLine "**__<[CommandName]>__**:"
        - define DescriptionLines <yaml[DeveloperCodeBlocks].read[<[Yaml]>.Description].separated_by[<&nl>]>
        - define UsageLine "***`Usage:`*** *`<yaml[DeveloperCodeBlocks].read[<[Yaml]>.Usage]>`*"
        - define EmbedStyle <yaml[DeveloperCodeBlocks].read[<[Yaml]>.EmbedStyle]||none>
        - define ExampleLine "**__Example__**:```<[EmbedStyle]><&nl>"
        - define ExampleLines "<yaml[DeveloperCodeBlocks].read[<[Yaml]>.Example].separated_by[<&nl>]>"
        - define EndBlock "```"

        - define Data:|:<[CommandLine]>|<[DescriptionLines]>|<[UsageLine]>|<[ExampleLine]>|<[ExampleLines]>|<[EndBlock]>
        # @ ██ [ Print ] ██
        - discord id:BehrBot message channel:<[Channel]> "<[Data].separated_by[<&nl>]>"