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
        - define Message <[Message].unescaped>
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
        - if <[Arg1]> == List:
            - define Padding <yaml[DeveloperCodeBlocks].list_keys[].parse[length].highest.add[1]>
            - foreach <yaml[DeveloperCodeBlocks].list_keys[]> as:Script:
                - define CommandName "**__List of Valid Script Dependencies__**"
                - define Description0 "&gt # Type /Script Name Or /Script # for more info"
                - define Description1 "&gt [#]<&sp><&sp><element[<&lb>Name<&rb>].pad_right[<[Padding].add[1]>]> [#]<&sp><&sp><&lb>Name<&rb>"
                - define EmbedStyle "&gt ```ini"
                - if <[Loop_Index].is_even>:
                    - define "ScriptLine:->:<element[<&lb><[Loop_Index]><&rb>].pad_right[4].with[<&sp>]> <[Script].pad_right[<[Padding]>].with[<&sp>]>Lasagna"
                - else:
                    - define "ScriptLine:->:&gt <element[<&lb><[Loop_Index]><&rb>].pad_right[4].with[<&sp>]> <[Script].pad_right[<[Padding]>].with[<&sp>]><&sp><&sp>"
            - define ScriptLine <[ScriptLine].separated_by[].split[lasagna].separated_by[|]>
            - define EndBlock "&gt ```"
            - define Data:|:<[CommandName]>|<[EmbedStyle]>|<[Description0]>|<[Description1]>|<[ScriptLine]>|<[EndBlock]>
            - discord id:BehrBot message channel:<[Channel]> "<[Data].separated_by[<&nl>].unescaped>"
            - stop

        - if !<[Scripts].contains[<[Arg1]>]> && !<[Arg1].is_integer>:
            - discord id:BehrBot message channel:<[Channel]> "Invalid Script Name."
            - stop
        
        - if <[Arg1].is_integer>:
            - if <yaml[DeveloperCodeBlocks].list_keys[].size> < <[Arg1]> || <[Arg1].contains[.]> || <[Arg1]> < 2:
                - discord id:BehrBot message channel:<[Channel]> "Invalid Script Reference Index."
                - stop
            - define Index <[Arg1]>
        - else:
            - define index <yaml[DeveloperCodeBlocks].list_keys[].find[<[Arg1]>]>
        - define Yaml <yaml[DeveloperCodeBlocks].list_keys[].get[<[Index]>]>

        # @ ██ [ Organize Message ] ██
        - define CommandName <[Yaml].replace[_].with[<&sp>]>
        - define CommandLine "**__<[CommandName]>__**:"
        - define DescriptionLines <yaml[DeveloperCodeBlocks].read[<[Yaml]>.Description].separated_by[<&nl>]>
        - define UsageLine "***`Usage:`*** *`<yaml[DeveloperCodeBlocks].read[<[Yaml]>.Usage]>`*"
        - define EmbedStyle <yaml[DeveloperCodeBlocks].read[<[Yaml]>.EmbedStyle]||none>
        - define ExampleLine "**__Example__**:<&nl><&gt> ```<[EmbedStyle]>"
        - define ExampleLines "<yaml[DeveloperCodeBlocks].read[<[Yaml]>.Example].separated_by[<&nl>]>"
        - define EndBlock "<&gt> ```"

        - define Data:|:<[CommandLine]>|<[DescriptionLines]>|<[UsageLine]>|<[ExampleLine]>|<[ExampleLines]>|<[EndBlock]>

        # @ ██ [ Print ] ██
        - discord id:BehrBot message channel:<[Channel]> "<[Data].separated_by[<&nl>]>"