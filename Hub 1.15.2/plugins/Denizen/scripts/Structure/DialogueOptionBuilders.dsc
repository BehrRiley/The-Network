Trigger_Option_builder:
  type: task
  debug: false
  script:
    - foreach <[Options_List]>:
      - define Hover "<&6>[<&e>Select<&6>]<&a> <[value]>"
      - define Message "<&6>[<&e>Click<&6>] <&a><[value]>"
      #- define SendMessage <[Trigger_List].get[<[loop_index]>]>
      - define Command <[Trigger_List].get[<[loop_index]>]>
      #- narrate <proc[MsgCmd].context[<[Hover]>|<[Message]>|<[SendMessage]>]>
      - narrate <proc[MsgCmd].context[<[Hover]>|<[Message]>|<[Command]>]>
      
