Command_Syntax:
  type: task
  debug: false
  script:
    - define Command "<queue.script.yaml_key[aliases].get[1]||<queue.script.yaml_key[Name]>> "
    - define Hover "<proc[Colorize].context[Click to Insert:|Green]><proc[Colorize].context[<&nl> <queue.script.yaml_key[Usage].parsed>|Yellow]>"
    - define Text "<proc[Colorize].context[Syntax: <queue.script.yaml_key[Usage].parsed>|Yellow]>"
    - narrate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
    - stop

Command_Error:
  type: task
  debug: false
  script:
    - define Hover "<proc[Colorize].context[You typed:|red]><&r><&nl><&c>/<context.alias||<context.command>> <context.raw_args><&nl><&2>C<&a>lick to <&2>I<&a>nsert<&nl><&6>Syntax<&co> <queue.script.yaml_key[Usage].parsed>"
    - define Text "<proc[Colorize].context[<[Reason]>|red]>"
    - define Command "<queue.script.yaml_key[aliases].get[1]||<context.alias||<context.command>>> "
    - narrate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
    - stop

Admin_Permission_Denied:
  type: task
  debug: false
  script:
    - if <player.flag[Behrry.Essentials.Rank]> > <[Rank]>
      - define Hover "<proc[Colorize].context[Permission Required:|red]> <&6><queue.script.yaml_key[adminpermission]>"
      - define Message "<proc[Colorize].context[You don't have permission to do that.|red]>"
      - narrate <proc[HoverMsg].context[<[Message]>|<[Hover]>]>
      - stop

Player_Verification:
  type: task
  debug: false
  ErrorProcess:
    - define Message "<proc[Colorize].context[Player is not online or does not exist.|red]>"
    - define Hover "<&6>Y<&e>ou <&6>E<&e>ntered<&co><&nl><&c>/<context.command.to_lowercase> <context.raw_args>"
    - narrate <proc[MsgHover].context[<[Message]>|<[Hover]>]>
    - stop
  script:
    - if <server.match_player[<[User]>]||null> == null:
      - inject locally ErrorProcess Instantly
    - define User <server.match_player[<[User]>]>

Player_Verification_Offline:
  type: task
  debug: false
  ErrorProcess:
    - define Hover "<&6>Y<&e>ou <&6>E<&e>ntered<&e>:<&nl><&c>/<context.command.to_lowercase> <context.raw_args>"
    - define Text "<proc[Colorize].context[Player does not exist.|red]>"
    - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
    - stop
  script:
    - if <server.match_player[<[User]>]||null> == null:
      - if <server.match_offline_player[<[User]>]||null> == null:
        - inject locally ErrorProcess Instantly
      - else:
        - define User <server.match_offline_player[<[User]>]>
    - else:
      - define User <server.match_player[<[User]>]>

User_Display_Simple:
  type: procedure
  debug: false
  definitions: User
  script:
    - if <[User].has_flag[behrry.essentials.display_name]>:
      - determine "<&r><[User].name.display><&r> <proc[Colorize].context[(<[User].name>)|yellow]>"
    - else:
      - determine "<proc[Colorize].context[<[User].name>|yellow]>"
