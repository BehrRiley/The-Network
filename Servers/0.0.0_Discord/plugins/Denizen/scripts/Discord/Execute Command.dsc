Execute_Command:
  type: task
  script:
    #@ Verify Role
    - if !<context.author.roles[481711026962694146].parse[name].contains_any[Coordinator|Developer]||false>
      - stop
      
    #@ Verify Channels
    - define Whitelist <list[689200464662626305/Console|482938388295712768/StaffChat]>
    - if !<[Whitelist].parse[before[/]].contains[<context.channel>]>:
      - stop
      
    #@ Verify Server
    - define Server <context.message.split[<&sp>].get[2]||null>
    - if !<bungee.list_servers.contains[<[Server]>]>:
      - stop
        
    #@ Verify Syntax
    - if !<context.message.starts_with[/ex<&sp>]>:
      - stop
      
    #@ Define Commands and Arguments
    - define RawCommandline <context.message.after[/ex<&sp><[Server]><&sp>]>
    - define Commands <[RawCommandLine].escaped.split[<&sp>].remove[1].filter[contains[&pipe]].parse[after[&pipe]].insert[<[RawCommandLine].escaped.split[<&sp>].get[1]>].at[1]>
    - define CommandLines <[RawCommandLine].split[<&pipe>]>
      
    #@ Run Command
    - foreach <[Commands]> as:Command:
      - bungee <[Server]>:
        #- <[Command]> <[CommandLines].get[<[Loop_Index]>].after[<[Command]><&sp>]>
        - execute as_server "ex <[Command]> <[CommandLines].get[<[Loop_Index]>].after[<[Command]><&sp>]>"
