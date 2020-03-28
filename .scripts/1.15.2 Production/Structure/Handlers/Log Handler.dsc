Login_Handler:
    type: world
    debug: false
    events:
        on player joins:
        # @ ██ [ Adjust Flags ] ██
            - define BlackFlags <list[behrry.protecc.prospecting]>
            - foreach <[BlackFlags]> as:BlackFlag:
                - if <player.has_flag[<[BlackFlag]>]>:
                    - flag player <[BlackFlag]>:!

        # @ ██ [ Flags for Server ] ██
        # $ Why is this here?
            - flag server behrry.essentials.save.playertrack:++

        # @ ██ [ Print the chat history ] ██
            - narrate <server.flag[Behrry.Essentials.ChatHistory.Global].parse[unescaped].separated_by[<&nl><&r>]>

        # @ ██ [ Format the message ] ██
            - choose <bungee.server>:
                - case BanditCraft:
                    - define Server "Bandit Craft"
                - case Discord:
                    - define Server "Discord | Test Server"
                - case 1152Construction:
                    - define Server "Test Server | 1.15.2"
                - case 1122Construction:
                    - define Server "Test Server | 1.15.2"
                - case default:
                    - define Server "A Test Server"
            - define Message "<player.flag[behrry.essentials.display_name]||<player.name>> <proc[Colorize].context[joined the network on:|yellow]> <&a><[Server]><&6>."

        # @ ██ [ Log the chat ] ██
            - define Log <[Message].escaped>
            - inject Chat_Logger Instantly

        # @ ██ [ Print to Other Servers ] ██
            - if <bungee.list_servers.size||1> > 1:
                - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
                    - bungee <[Server]>:
                        - announce <[Message]>

        # @ ██ [ Print to game chat ] ██
            - determine <[Message]>

        on player logs in:
        # @ ██ [ Displayname ] ██
            - wait 1s
            - if <player.has_flag[behrry.essentials.display_name]>:
                - adjust <player> display_name:<player.flag[behrry.essentials.display_name]>
            - if <player.in_group[Silent]>:
                - while !<player.groups.contains[Public]>:
                    - execute as_server "upc addgroup <player.name> Public"
                    - wait 5t

        on player quits:
        # @ ██ [ Remove Flags ] ██
            - flag player behrry.chat.lastreply:!
    
        # @ ██ [ Cancel if player was kicked ] ██
            - if <player.has_flag[behrry.moderation.kicked]>:
                - determine NONE
                
        # @ ██ [Format the Message ] ██
            - define Message "<player.flag[behrry.essentials.display_name]||<player.name>> <proc[Colorize].context[left the network.|yellow]>"

        # @ ██ [Log to global chat ] ██
            - if <server.flag[Behrry.Essentials.ChatHistory.Global].size||0> > 24:
                - flag server Behrry.Essentials.ChatHistory.Global:<-:<server.flag[Behrry.Essentials.ChatHistory.Global].first>
            - flag server Behrry.Essentials.ChatHistory.Global:->:<[Message].escaped>
            
        # @ ██ [ Print to Other Servers ] ██
            - if <bungee.list_servers.size||1> > 1:
                - foreach <bungee.list_servers.exclude[<bungee.server>]> as:Server:
                    - bungee <[Server]>:
                        - announce <[Message]>

        # @ ██ [ Join Message Main Server ] ██
            - determine <[Message]>