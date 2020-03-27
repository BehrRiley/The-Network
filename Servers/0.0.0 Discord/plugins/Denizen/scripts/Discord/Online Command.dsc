Online_DCommand:
  type: task
  debug: false
  usage: /Online
  syntax: /Online (Server)
  description: Shows you the players online in a specific server, or all servers.
  definitions: Channel|Group|RawMessage
  RolePermission:
    - Everyone
  script:
    # @ ██ [ Verify Channels ] ██
    - define Channel <[Channel]>
    - define Whitelist <list[481711026962694148/QuietGeneral|593523276190580736/LoudGeneral|488921873908760576/BotCommands|623758713056133120/BotSpam|519612225854504962/VoiceButWords|482938388295712768/StaffChat|560503165452288010/Data|689200464662626305/Console]>
    - if !<[Whitelist].parse[before[/]].contains[<[Channel]>]>:
      - stop

    # @ ██ [ Verify Syntax ] ██
    - define Message <[RawMessage].unescaped>
    - if !<[Message].starts_with[/online]>:
      - stop

    # @ ██ [ Verify Server ] ██
    - define Server <[Message].split[<&sp>].get[2]||null>
    - if <[Server]> == all || <[Server]> == null:
      - define Server <bungee.list_servers>
    - else if <[Server]> != null:
      - if !<bungee.list_servers.contains[<[Server]>]>:
        - stop
      
    # @ ██ [ Run Command ] ██
    - foreach <[Server].as_list> as:Server:
      - ~bungeetag server:<[Server]> <server.list_online_players> save:Players
      - define Players <entry[Players].result>
      - if <[Players].size> == 0:
        - foreach next
      - Foreach <[Players]> as:Player:
        - ~bungeetag server:<[Server]> <[Player].name> save:Name
        - ~bungeetag server:<[Server]> <[Player].has_flag[behrry.essentials.display_name]> save:NicknameCheck
        - if <entry[NicknameCheck].result> == true:
          - ~bungeetag server:<[Server]> <[Player].flag[behrry.essentials.display_name]> save:Nickname
          - define Player<[Loop_Index]> "<entry[Nickname].result.strip_color> ('<entry[Name].result>')"
        - else:
          - define Player<[Loop_Index]> "<entry[Name].result>"

      - define line:!
      - repeat <[Players].size>:
        - if <[Value].is_odd>:
          - define Line:++
        - define PlayerLine<[Line]>:->:<&sp>*<&sp><[Player<[Value]>].pad_right[30].with[<&sp>]>
      - define PlayerLineCount <[Players].size.div[2].round_up>
      - define ServerLine "<element[[ Server: <[Server]> - <[Players].size> Online ]].pad_left[45].with[-].pad_right[60].with[-]>"
      - define Page "<list[<[ServerLine]>]>"
      
      - repeat <[PlayerLineCount]>:
        - define Page:->:<[PlayerLine<[Value]>].separated_by[|]>
      - discord id:GeneralBot message channel:<[Channel]> "```xl<&nl><[Page].separated_by[<&nl>]><&nl>```"


