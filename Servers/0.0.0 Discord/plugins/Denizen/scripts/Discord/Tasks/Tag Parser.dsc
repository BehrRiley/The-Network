tag_parser_startup:
    type: world
    debug: false
    events:
        on server start:
            - wait 5s
            - flag server tag_parser_validchannels:!|:680549401273565354
            - flag server tag_parser_link:http://one.denizenscript.com/haste/65739
            - define link <server.flag[tag_parser_link]>
            - define "samples:|:<list[link/<[link].escaped>|sample_bool/true|sample_0/0|sample_1/1|sample_10/10|sample_0p5/0.5]>"
            - define "samples:|:<list[sample_text/Hello, world!|help/try typing 'help' to the bot!]>"
            - define "samples:|:<list[version/<server.version.escaped>|denizen_version/<server.denizen_version.escaped>]>"
            - flag server tag_parser_samples:!|:<[samples]>
        on script generates error:
            - flag server tag_parser_result_temp:FAILED=ERROR/<context.message.escaped.replace[;].with[&sc]>;<server.flag[tag_parser_result_temp]||>
        on script generates exception:
            - flag server tag_parser_result_temp:FAILED=EXCEPTION/<context.type.escaped.replace[;].with[&sc]>-<context.message.escaped.replace[;].with[&sc]>;<server.flag[tag_parser_result_temp]||>

TagParser_Task:
    type: task
    debug: true
    definitions: Channel|Group|Message|Author|DM|NoMentionMessage
    script:
        - if !<[DM]>:
            - if !<server.flag[tag_parser_validchannels].contains[<[Channel]>]>:
                - stop
        
        - define Message <[Message].unescaped>
        - define NoMentionMessage <[NoMentionMessage].unescaped>
        #- define tag <[NoMentionMessage].replace[<n>].with[<&sp>].trim.escaped>
        - define tag <[NoMentionMessage].trim.escaped>
        - inject locally process_tag player:<server.match_offline_player[Behr_Riley]> npc:<server.list_npcs.get[1]>
        - inject locally crunch_result

        - if <[DM]>:
            - discord id:GeneralBot message user:<[Author]> "Tag parse results for '<[tag].unescaped.replace[`].with[']>'<&co><n>```<n><[final_result].unescaped.replace[`].with[']>```"
        - else:
            - discord id:GeneralBot message channel:<[Channel]> "```ml<n>Tag parse results for: <[tag].unescaped.replace[`].with[']><n><[final_result].unescaped.replace[`].with[']>```"

    process_tag:
        - flag server tag_parser_result_temp:!
        - define samples <server.flag[tag_parser_samples]>|sample_player/<player>|sample_npc/<npc>
        - foreach <[samples]>:
            - define <[value].before[/]> <[value].after[/].unescaped>
        - define help "Tell me any valid Denizen (Bukkit) tags, like <&lt>player.name<&gt> and I'll parse them for you! Alternately, tell me a valid definition name (like 'samples') and I'll tell you its contents."
        - if !<[tag].unescaped.contains[<&lt>]> && <[<[tag].unescaped>].exists>:
            - flag server tag_parser_result_temp:VALID=<[<[tag].unescaped>].escaped.replace[;].with[&sc]>;<server.flag[tag_parser_result_temp]||>
        - else:
            - flag server tag_parser_result_temp:VALID=<[tag].unescaped.parsed.escaped.replace[;].with[&sc]>;<server.flag[tag_parser_result_temp]||>
            #- run locally instantly tag_run_task def:<[tag]>
        - define result <server.flag[tag_parser_result_temp]||FAILED=FLAG_MISSING;>
        - flag server tag_parser_result_temp:!

    crunch_result:
        - define final_result <empty>
        - foreach <[result].split[;]>:
            - if <[value].starts_with[VALID=]>:
                - define final_result "<[final_result]><[value].after[VALID=].replace[&sc].with[;]><n>"
        - foreach <[result].split[;]>:
            - if <[value].starts_with[FAILED=ERROR/]>:
                - define final_result "<[final_result]>Had error: <[value].after[FAILED=ERROR/].replace[&sc].with[;]><n>"
            - else if <[value].starts_with[FAILED=EXCEPTION/]>:
                - define final_result "<[final_result]>Had internal exception: <[value].after[FAILED=EXCEPTION/].replace[&sc].with[;]><n>"
            - else if <[value].starts_with[FAILED=]>:
                - define fail_reason <[value].after[FAILED=]>
                - if <[fail_reason]> == FLAG_MISSING:
                  - define final_result "<[final_result]>Got no result value.<n>"
                - else:
                    - define final_result "<[final_result]>Got failure '<[fail_reason]>'.<n>"
        - if <[final_result].trim.length> == 0:
            - define final_result <empty>
        - if <[final_result].length> > 1500 || <[tag].length.add[<[final_result].length>]> > 1875:
            - define tag "(Spam)"
            - define final_result "Input too long, refused."
        #- if <[final_result].to_list.filter[is[==].to[<n>]].size> > 10:
        #  - define final_result "Newline spam, refused."

tag_run_task:
    type: task
    definitions: tag
    script:
        - flag server tag_parser_result_temp:VALID=<[tag].unescaped.parsed.escaped.replace[;].with[&sc]>;<server.flag[tag_parser_result_temp]||>


