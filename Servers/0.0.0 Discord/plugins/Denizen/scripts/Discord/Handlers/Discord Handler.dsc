Discord_Handler:
  type: world
  debug: false
  events:
  # @ on discord message received for:GeneralBot:
  # ^ inject locally "events.on discord message received for:BehrBot"
    on discord message received for:GeneralBot:
    # @ ██ [ Define Definitions ] ██
      - define Channel <context.channel.id>
      - define Group <context.group>
      - define Message <context.message.escaped||null>
  # ^ - define MessageID <context.message_id||null>
      - define Author <context.author||invalid>
      - define Mentions <context.mentions.escaped||null>
      - define DM <context.is_direct>
      - define Bot <context.bot.self_user>
      - define NoMentionMessage <context.no_mention_message.escaped||invalid>

    # @ ██ [ Verify definitions ] ██
      - if <[Author]> == invalid:
        - stop
      - if <[Author]> == <[Bot]>:
        - stop
      - if <[Author].id.contains[234395307759108106]>:
        - stop
      - if <context.message||invalid> == invalid || <[NoMentionMessage]> == invalid:
        - stop
      - if <[DM]>:
        - ~run TagParser_Task def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>|<[DM]>|<[NoMentionMessage]>
        #^ - ~run Report_DCommand def:<[DM]>|<[Group]>|<[Message]>|<[Author]>
        #^ - ~run Execute_DCommand def:<[DM]>|<[Group]>|<[Message]>|<[Author]>
        #^ - ~run Tag_Parser def:<[DM]>|<[Group]>|<[Message]>|<[Author]>
        - stop

      #@ Mention Commands
      - if <context.mentions.contains[<context.bot.self_user>]>:
        - ~run TagParser_Task def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>|<[DM]>|<[NoMentionMessage]>

    # @ ██ [ Process Scripts ] ██
      #- ~run Execute_DCommand def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>
      - ~run Online_DCommand def:<[Channel]>|<[Group]>|<[Message]>
      #- ~run Help_DCommand def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>
      #- ~run S_DCommand def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>
      #- ~run Yaml_DCommand def:
      - ~run Chat_Relay def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>|<[Mentions]>

            #@ Print for Console
      - announce to_console "<&b>[<&7><context.channel.name.strip_color><&b>] <&7><[Author].name.strip_color><&b>: <&7><context.message>"