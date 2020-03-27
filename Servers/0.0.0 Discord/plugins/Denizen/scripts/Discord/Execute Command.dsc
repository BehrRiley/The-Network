Execute_DCommand:
  type: task
  usage: /ex <&lt>Commands<&gt>
  syntax: /ex <&lt>Command<&gt> <&lt>Server<&gt> (Args)(|<&lt>Command<&gt> (Args))*
  description: Executes a command on a specified server.
  definitions: Channel|Group|Message|Author
  RolePermission:
    - Developer
    - Coordinator
  script:
    # @ ██ [ Verify Role ] ██
    - if !<[Author].roles[<[Group]>].parse[name].contains_any[Coordinator|Developer]||false>
      - stop
      
    # @ ██ [ Verify Channels ] ██
    - define Whitelist <list[689200464662626305/Console|482938388295712768/StaffChat]>
    - if !<[Whitelist].parse[before[/]].contains[<[Channel]>]>:
      - stop
      
    # @ ██ [ Verify Server ] ██
    - define Server <[Message].split[<&sp>].get[2]||null>
    - if !<bungee.list_servers.contains[<[Server]>]>:
      - stop
        
    # @ ██ [ Verify Syntax - "/ex" ] ██
    - if !<[Message].starts_with[/ex<&sp>]>:
      - stop
      
    # @ ██ [ Define Commands and Arguments ] ██
    - define RawCommandline <[Message].after[/ex<&sp><[Server]><&sp>]>
    - define Commands <[RawCommandLine].escaped.split[<&sp>].remove[1].filter[contains[&pipe]].parse[after[&pipe]].insert[<[RawCommandLine].escaped.split[<&sp>].get[1]>].at[1]>
    - define CommandLines <[RawCommandLine].split[<&pipe>]>
      
    # @ ██ [ Run Command ] ██
    - foreach <[Commands]> as:Command:
      - bungee <[Server]>:
        #- <[Command]> <[CommandLines].get[<[Loop_Index]>].after[<[Command]><&sp>]>
        - execute as_server "ex <[Command]> <[CommandLines].get[<[Loop_Index]>].after[<[Command]><&sp>]>"
