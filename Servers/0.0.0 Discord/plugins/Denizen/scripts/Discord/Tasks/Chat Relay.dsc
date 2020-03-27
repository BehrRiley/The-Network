Chat_Relay:
    type: task
    debug: false
    definitions: Channel|Group|RawMessage|Author|Mentions
    script:
    # @ ██ [ Check Channel ] ██
        - if <[Channel]> != <server.flag[discord.channel.MainChat]>:
            - stop
        
    # @ ██ [ Check if Message is Blank ] ██
        - if <[RawMessage]> == "":
            - stop
        
    # @ ██ [ Check if Message contains a valid Discord emoji or ping ] ██
    # % ██ [ Discord Pong:   <@!12345678901234567> ]
    # % ██ | Emoji:          <:Emoji_Name:1234567> |
    # % ██ | Animated Emoji: <a:Emoji_Name:123456> |
        - foreach <[RawMessage].unescaped.split> as:String:
            # @ ██ [ Check for Ping ] ██
            - define RawUserID <[String].after[@!].before[<&gt>]>
            - define Mentions <[Mentions].unescaped.as_list>
            - if <[Mentions].parse[id].contains[<[RawUserID]>]>:
                - define Index <[Mentions].parse[id].find[<[RawUserID]>]>
                - define User <[Mentions].get[<[Index]>].nickname[<[Group]>]||<[Mentions].get[<[Index]>].name>>
                - define Strings:|:<element[<&3>@<&b><[User]><&r>].escaped>
                - foreach next
        
            # @ ██ [ Check for Emoji] ██
            - else if <[String].starts_with[<&lt>]> && <[String].ends_with[<&gt>]>:
                - define Tag <[String].after_last[:].before[<&gt>]>
                - if <[Tag].is_integer> && <[Tag].length> > 10:
                    - define Strings:|:<&chr[25B2]>
                    - foreach next
            
            # @ ██ [ Check for URL ] ██
            - else if <[String].contains[.]>:
                - foreach <list[https://|http://|www.]> as:protocal:
                    - if <[String].starts_with[<[Protocal]>]>:
                        - define Hover "<&a>Click to follow Link<&2>:<&nl><&b><[String]>"
                        - define Text "<&6><&n>[<&b><&n>Link<&6><&n>]<&r>"
                        - if <[Protocal]> == "www.":
                            - define URL https://<[String]>
                        - else:
                            - define URL <[String]>
                        - define Strings:|:<proc[MsgURL].context[<[Hover]>|<[Text]>|<[URL]>].escaped>
                        - foreach stop
                        
            # @ ██ [ Text is normal ] ██
            - else:
                - define Strings:|:<[String].escaped>
        
    # @ ██ [ Compile message ] ██
        - define User <[Author].nickname[<[Group]>]||<[Author].name>>
        - define UserFormatted <&b>┤<proc[Colorize].context[<[User]>|Blue]>
        - define Message <[Strings].space_separated.unescaped.parse_color||>
        - define Chat "<[UserFormatted]><&3>: <&r><[Message]>"

    # $ ██ [ To-Do: ] ██
    # $ ██ | Add UserLinks as secondary definition for ignoring players

    # @ ██ [ Message Servers ] ██
        - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
            - bungeerun <[Server]> Discord_Relay def:<[Chat].escaped>
                                                                  #$ |<[UserLink]>