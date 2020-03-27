Discord_Startup_Handler:
    type: world
    debug: false
    StartBots:
        - yaml id:TempDiscordData load:data/BotData.yml

        - run Locally BehrBotStart
        - run Locally GeneralBotStart

        - flag server discord.botstatus:processed
        - wait 2s
        - yaml unload id:TempDiscordData
    RestartBots:
        - if <server.flag[discord.botstatus]||offline> == "processed":
            - flag server discord.botstatus:offline
            - discord id:BehrBot disconnect
            - discord id:GeneralBot disconnect
        - inject locally StartBots
    BehrBotStart:
        - announce to_console "<proc[colorize].context[BehrBot initiating in 2s|yellow]>"
        - wait 2s
        - ~discord id:BehrBot connect code:<yaml[TempDiscordData].read[bots.discord.BehrBot.token]>
        - wait 2s
    GeneralBotStart:
        - announce to_console "<proc[colorize].context[BehrBot initiating in 2s|yellow]>"
        - wait 2s
        - ~discord id:GeneralBot connect code:<yaml[TempDiscordData].read[bots.discord.GeneralBot.token]>
        - wait 2s
        - discord id:GeneralBot status "you type" "status:ONLINE" "activity:Watching"
        - wait 2s
    StopBots:
        - discord id:BehrBot disconnect
        - discord id:GeneralBot disconnect
        - flag server discord.botstatus:offline
    events:
        on server start:
            - inject locally RestartBots
            - yaml "load:data/Developer Code Blocks.dsc" "id:DeveloperCodeBlocks"

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
