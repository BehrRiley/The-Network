Help_DCommand:
  type: task
  usage: /help
  syntax: /help (#)
  description: Shows you this page of all available commands to you.
  definitions: Channel|Group|Message|Author
  RolePermission:
    - Everyone
  script:
    # @ ██ [ Verify Syntax - "/help" ] ██
    - if !<[Message].starts_with[/help<&sp>]>:
      - stop

    # @ ██ [ Define main definitions ] ██
    - define Commands <server.list_scripts.parse[name].filter[ends_with[_DCommand]].alphabetical>
    - Define RolePermissions <script[<[Command]>].yaml_key[RolePermission]>
    - if !<[Author].roles[<[Group]>].parse[name].contains_any[<[RolePermission]>]||false> || <[RolePermissions].contains[Everyone]>:
      - define Permission true
    
    # @ ██ [ Check for args ] ██
    - define Arg1 <[Message].after[/help<&sp>].split[<&sp>].get[1]||null>
    - if <[Arg1]> != null:
      - if !<[Commands].contains[<[Arg1]>]>:
        - define Reason "`<[Arg1]>` is not a valid command."
        - inject Error_DResponse
        - stop
      - inject locally CommandHelp
    - else:
      - inject Locally GeneralHelp
      
  CommandHelp:
    # @ ██ [ Define definitions ] ██
    - foreach <[Commands]> as:command:
      - define Syntax "<script[<[Command]>].yaml_key[syntax].parsed||>>"
      - define Description "|<script[<[Command]>].yaml_key[description]||>"
    - define CommandLine "<&lt><[usage].pad_right[22].with[<&sp>]> | <[Description]>"
        
  GeneralHelp:
    # @ ██ [ Define definitions ] ██
    - foreach <[Commands]> as:command:
      - define Usage "<script[<[Command]>].yaml_key[usage].parsed||>>"
      - define Description "|<script[<[Command]>].yaml_key[description]||>"
    - define CommandLine "<&lt><[usage].pad_right[22].with[<&sp>]> | <[Description]>"
         
