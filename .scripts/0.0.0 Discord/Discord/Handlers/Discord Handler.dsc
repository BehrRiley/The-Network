Discord_Handler:
  type: world
  debug: false
  events:
  # @ on discord message received for:GeneralBot:
  # ^ inject locally "events.on discord message received for:BehrBot"
    on discord message received for:BehrBot:
    # @ ██ [ Define Definitions ] ██
      - define Channel <context.channel.id>
      - define Group <context.group>
      - define Message <context.message.escaped||null>
  # ^ - define MessageID <context.message_id||null>
      - define Author <context.author||null>
      - define Mentions <context.mentions.escaped||null>
      - define DM <context.is_direct>
      - define Bot <context.bot.self_user>

    # @ ██ [ Verify definitions ] ██
      - if <[Author]> == Null:
        - stop
      - if <[Author]> == <[Bot]>:
        - stop
      - if <[DM]>:
        #^ - ~run Report_DCommand def:<[DM]>|<[Group]>|<[Message]>|<[Author]>
        #^ - ~run Execute_DCommand def:<[DM]>|<[Group]>|<[Message]>|<[Author]>
        #^ - ~run Tag_Parser def:<[DM]>|<[Group]>|<[Message]>|<[Author]>
        - stop

    # @ ██ [ Process Scripts ] ██
      #- ~run Execute_DCommand def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>
      - ~run Online_DCommand def:<[Channel]>|<[Group]>|<[Message]>
      #- ~run Help_DCommand def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>
      #- ~run S_DCommand def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>
      #- ~run Yaml_DCommand def:
      - ~run Chat_Relay def:<[Channel]>|<[Group]>|<[Message]>|<[Author]>|<[Mentions]>
      