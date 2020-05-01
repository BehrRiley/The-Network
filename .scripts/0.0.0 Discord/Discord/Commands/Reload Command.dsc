Reload_DCommand:
    type: task
    debug: false
    usage: /reload (Yaml)
    syntax: /reload (Yaml)
    description: Reloads Scripts or Yaml Dependencies
    definitions: Channel|Group|Message|Author
    RolePermission:
        - Developer
        - Coordinator
    script:
        - define Message <[Message].unescaped>

        # @ ██ [ Check args ] ██
        - define Args <[Message].split[<&sp>].remove[1]||>
        - define MaxArgs 1
        - inject ArgSizeCheck

        # @ ██ [ Verify Syntax - "/r" ] ██
        - if <[Message]> != /r && !<[Message]> != /reload && !<[Message].starts_with[/reload]> && !<[Message].starts_with[/r<&sp>]>:
            - stop

        - if <[Arg1]||null> == yaml:
            - yaml id:DeveloperCodeBlocks unload
            - yaml id:DeveloperCodeBlocks "load:data/Developer Code Blocks.dsc"
            - discord id:BehrBot message channel:<[Channel]> "Yaml Files reloaded."
            - stop

        # @ ██ [ Command Checks ] ██
        - Define Command "Reload"
        - Inject RoleCheck

        - discord id:BehrBot message channel:<[Channel]> "Reloading Scripts..."
        - reload
        - wait 5t
        - if <server.has_flag[Dehrry.Reload.ScriptError]>:
            - discord id:BehrBot message channel:<[Channel]> <server.flag[Dehrry.Reload.ScriptError].separated_by[<&nl>]>
            - flag server Dehrry.Reload.ScriptError:!
        - else:
            - discord id:BehrBot message channel:<[Channel]> ":white_check_mark: Scripts Reloaded."


ScriptError_Handler:
    type: world
    debug: false
    events:
        on script generates error:
            - if "<context.message.contains_any_text[list_flags|{ braced } command format|'&dot' or '&cm']>":
                - determine cancelled
            - if <context.queue.contains[EXCOMMAND_]||false>:
                - stop

            - define "Message:->:<&lt>a:weewoo2:610363395241148418<&gt> **__Script Error__** <&lt>a:weewoo2:610363395241148418<&gt>"

            - define "Message:->:**`Script Origin:`** `<context.queue.script.name||Unknown>`"

            - if <context.line||null> != null:
                - define "Message:->:**`Line Origin:`** `[<context.line||unknown>]`"

            - define "Message:->:**`File Origin:`** `<context.queue.script.relative_filename||null>`"

            - if <context.message||null> != null:
                - define "Message:->:**`Available Context:`**"
                - define "Message:->:<&gt> ```dif<&nl><&gt> - <context.message||null>```"

            - flag server Dehrry.Reload.ScriptError:!|:<[Message]> duration:1s