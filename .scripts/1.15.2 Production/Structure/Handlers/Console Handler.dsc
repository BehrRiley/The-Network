Console_Handler:
    type: world
    debug: false
    events:
        on server start:
            - adjust system redirect_logging:true

        on reload scripts:
            - if <server.match_player[behr]||null> != null:
                - if <context.had_error>:
                    - narrate targets:<server.match_player[behr_riley]> "<&c>Reload Error"
                - else:
                    - narrate targets:<server.match_player[behr_riley]> "<&a>Reloaded"
 
        on script generates error:
            - if <server.match_player[behr]||null> != null:
                - if "<context.message.contains_any_text[list_flags|{ braced } command format]>":
                    - determine cancelled
                - if <context.queue.contains[EXCOMMAND_]||false>:
                    - stop
                - narrate targets:<server.match_player[behr_riley]> "<&4>Script Error<&co> <&c><context.queue.script.name||null> <&e>in <&c><context.queue.script.relative_filename||null><&e><&nl><context.message||null>"

        on server generates exception:
            - if <server.match_player[behr]||null> != null:
                - if <context.queue.contains[EXCOMMAND_]||false>:
                    - stop
                - narrate targets:<server.match_player[behr_riley]> "<&4>Server generated exception<&co> <&c><context.type>"

#testing:
#    type: world
#    events:
#        on player receives commands:
#            - if <player.in_group[Moderation]>:
#                - stop
#            - define Commands <server.list_scripts.parse[name].filter[ends_with[_Command]].alphabetical>
#
#        # @ ██ [  Verify Permissions | Build list ] ██
#            - foreach <[Commands]> as:command:
#                - if !<player.has_permission[<script[<[Command]>].yaml_key[permission]||null>]>:
#                    - foreach next
#                - else:
#                    - define CommandList:->:<[Command]>
#            - determine <context.commands.filter[contains_any[<[CommandList]>]]>
#
#



        #on console output:
        #    - if "<context.message.contains_any_text[+> <&lb>ScriptEvent<&rb> Event]>":
        #        - determine cancelled
        