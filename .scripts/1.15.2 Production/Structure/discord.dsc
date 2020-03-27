#Discord_Handler:
#    type: world
#    debug: false
#    StartBots:
#        - yaml id:TempDiscordData load:data/BotData.yml
#
#        - run Locally BehrBotStart
#        - run Locally GeneralBotStart
#
#        - flag server discord.botstatus:processed
#        - wait 2s
#        - yaml unload id:TempDiscordData
#    RestartBots:
#        - if <server.flag[discord.botstatus]||offline> == "processed":
#            - flag server discord.botstatus:offline
#            - discord id:BehrBot disconnect
#            - discord id:GeneralBot disconnect
#        - inject locally StartBots
#    BehrBotStart:
#        - announce to_console "<proc[colorize].context[BehrBot initiating in 2s|yellow]>"
#        - wait 2s
#        - ~discord id:BehrBot connect code:<yaml[TempDiscordData].read[bots.discord.BehrBot.token]>
#        - wait 2s
#    GeneralBotStart:
#        - announce to_console "<proc[colorize].context[BehrBot initiating in 2s|yellow]>"
#        - wait 2s
#        - ~discord id:GeneralBot connect code:<yaml[TempDiscordData].read[bots.discord.GeneralBot.token]>
#        - wait 2s
#        - discord id:GeneralBot status "you type" "status:ONLINE" "activity:Watching"
#        - wait 2s
#    StopBots:
#        - discord id:BehrBot disconnect
#        - discord id:GeneralBot disconnect
#        - flag server discord.botstatus:offline
#    events:
#        on server start:
#            - inject locally RestartBots
#        on discord message received for:BehrBot:
#            #@ if the message is from BehrBot
#            - if <context.author> == <context.bot.self_user>:
#
#                #@ if the message is a server relay FROM TEST SERVER
#                - if <context.message.starts_with[►◄]>:
#
#                    #@ but also only if this is the MAIN server
#                    - if <bungee.server||null> == Null:
#
#                        #@ print to MAIN SERVER
#                        - announce "<context.message.after[►◄].unescaped>"
#
#                        #@ log the chat
#                        - define Log <context.message.after[►◄]>
#                        - inject Chat_Logger Instantly
#
#                #@ if the message is a server relay FROM MAIN SERVER
#                - if <context.message.starts_with[◄►]>:
#
#                    #@ but also only if this is the TEST SERVER
#                    - if <bungee.server||null> == Hub2:
#
#                        #@ print to TEST SERVER
#                        - announce "<context.message.after[◄►].unescaped>"
#
#                        #@ log the chat
#                        - define Log <context.message.after[◄►]>
#                        - inject Chat_Logger Instantly
##            - else:
##                #@ channel verification
##                - if <context.channel.id> == 481711026962694148:
##
##                    #@ format the message
##                    - define Message "<&b>┤<proc[Colorize].context[<context.author.nickname[<context.group>]||<context.author.name>>|Blue]><&3>:<&r> <context.message.parse_color>"
##
##                    #@ log the chat
##                    - define Log <[Message].escaped>
##                    - inject Chat_Logger Instantly
##
##                    #@ print to game chat
##                    - announce "<[Message]>"
#        on discord message received for:GeneralBot:
#            #@ if the message is from BehrBot
#            - if <context.author> != <context.bot.self_user> && <context.channel.id> == 593523276190580736:
#
#                    #@ format the message
#                    - define Message "<&b>┤<proc[Colorize].context[<context.author.nickname[<context.group>]||<context.author.name>>|Blue]><&3>:<&r> <context.message.parse_color>"
#
#                    #@ log the chat
#                    - define Log <[Message].escaped>
#                    - inject Chat_Logger Instantly
#
#                    #@ print to game chat
#                    - announce "<[Message]>"




Discordc_Command:
    type: command
    name: discordc
    usage: /discordc restart
    permission: behrry.essentials.discordc
    description: Controls the discordbots.
    aliases:
        - dc
    script:
        - choose <context.args.get[1]||null>:
            - case start:
                - inject Discord_Handler path:StartBots
            - case restart:
                - inject Discord_Handler path:RestartBots
            - case stop:
                - inject Discord_Handler path:StopBots

            - case Test:
                - if <context.args.get[3]||null> == null:
                    - inject Command_Syntax Instantly
                - discord id:<context.args.get[2]> message channel:623758713056133120 "<context.raw_args.after[<context.args.get[2]><&sp>]>"
            - case default:
                - inject Command_Syntax Instantly
