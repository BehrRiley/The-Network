#@ Usage - bungeerun Discord_Message def:Channel|Message
Discord_Message:
  type: task
  debug: false
  definitions: ChannelKey|Message
  Channels:
    QuietGeneral: 481711026962694148
    LoudGeneral: 593523276190580736
    BotCommands: 488921873908760576
    BotSpam: 623758713056133120
    VoiceButWords: 519612225854504962
    StaffChat: 482938388295712768
    Data: 560503165452288010
    Console: 689200464662626305
  script:
    - define Channel <script.yaml_key[Channels.<[ChannelKey]>]>
    - define Message <[Message].unescaped.replace[`].with[']>
    - discord id:GeneralBot Message channel:<[Channel]> "<[Message]>"
