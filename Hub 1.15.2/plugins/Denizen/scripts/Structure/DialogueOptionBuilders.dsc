Trigger_Option_builder:
  type: task
  debug: false
  script:
    - foreach <[Options_List]> as:Option:
      - define Hover "<&6>[<&e>Select<&6>]<&a> <[Option]>"
      - define Message "<&6>[<&e>Click<&6>] <&a><[Option]>"
      - define Command "Dialogue <[Loop_Index]>"
      - narrate <proc[MsgCmd].context[<[Hover]>|<[Message]>|<[Command]>]>
      
