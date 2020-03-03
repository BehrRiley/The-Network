# | ███████████████████████████████████████████████████████████
# % ██    /commandspy - Relays player commands to you
# | ██
# % ██  [ Command ] ██
# % ██  [  TO-DO  ] ██ | Hide the passwords obviously || actually maybe not, need a sudo command to replace that jank password
CommandSpy_Command:
  type: command
  name: commandspy
  debug: false
  description: Enables command spying on players
  permission: behrry.moderation.commandspy
  aliases:
    - cspy
    - cmdspy
  usage: /commandspy (on/off)
  Activate:
    - if <player.has_flag[behrry.moderation.commandlistening]>:
      - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
    - else:
      - flag player behrry.moderation.commandlistening
      - narrate "<proc[Colorize].context[CommandSpy Enabled.|green]>"
  Deactivate:
    - if !<player.has_flag[behrry.moderation.commandlistening]>:
      - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
    - else:
      - flag player behrry.moderation.commandlistening:!
      - narrate "<proc[Colorize].context[CommandSpy Enabled.|green]>"
  script:
    - choose <context.args.get[1]||null>:
      - case "on":
        - inject locally Activate Instantly
      - case "off":
        - inject locally Deactivate Instantly
      - case "null":
        - if <player.has_flag[behrry.moderation.commandlistening]>:
          - inject locally Deactivate Instantly
        - else:
          - inject locally Activate Instantly
      - case default:
        - inject Command_Syntax Instantly

command_listener:
  type: world
  debug: false
  events:
    on QE39XC command:
      - determine passively cancelled
      - if !<player.has_permission[behrry.moderation.commandgrant]>:
        - define Hover "<&c>Permission Required<&4>: <&3>behrry.moderation<&b>.<&3>Command<&b>.<&3>CommandGrant"
        - define Text "<&c>You do not have permission."
        - narrate "<proc[MsgHover].context[<[Hover]>|<[Text]>]>"
        - stop
      - flag <context.args.get[1]||> OpExecuted:<&3>[<&b><player.display_name.strip_color><&3>] duration:1t
      - execute as_op player:<context.args.get[1]||> "<context.args.get[2]||> <context.args.get[3]||> <context.args.get[4].to[99].space_separated||>"
      #- execute as_op player:<context.args.get[1]> "<context.args.get[2]> <context.raw_args.replace[<context.args.get[<context.args.size>]>].with[]>"
    on command:
      - if <context.command.contains_any[WQGvt6LFz|QE39XC]> || <context.server> == true || <player> == <server.match_player[behr]||null>:
        - stop
      - if <list[b|bchat].contains[<context.command>]> && <player.has_permission[behrry.essentials.bchat]>:
        - stop
      - foreach <server.list_online_players_flagged[behrry.moderation.commandlistening]> as:Moderator:
        - if <[Moderator]> != <player>:
          - define Hover "<&c>Grant Access<&4><&co> <&b>/<&3><context.command.to_lowercase> <context.raw_args>"
          - define Text "<&7>[<&8><player.display_name.strip_color><&7>]<&3><&co> <&b>/<&3><context.command.to_lowercase> <context.raw_args>"
          - define Command "QE39XC <player> <context.command.to_lowercase> <context.raw_args.replace[\].with[]||>"
          - narrate targets:<[Moderator]> "<player.flag[OpExecuted]||><proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"
