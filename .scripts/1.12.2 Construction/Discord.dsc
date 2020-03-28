# ███████████████████████████████████████████████████████████
# ██ [           dDiscord Chat Relay                     ] ██
# ██ [                                                   ] ██
# ██ [   The config for this file should be              ] ██
# ██ [   SEPARATE from this script; you do               ] ██
# ██ [   NOT want to keep your bot token in ram,         ] ██
# ██ [   keep it separate. Anyone with your              ] ██
# ██ [   token has full access to your bot.              ] ██
# ██ [                                                   ] ██
# ██ [   Step one: Create a discord bot. If you          ] ██
# ██ [     need further instructions, you should         ] ██
# ██ [     seek a guide online.                          ] ██
# ██ [                                                   ] ██
# ██ [   You need to obtain # ID's:                      ] ██
# ██ [   * Your Bot Token. Can be obtained here:         ] ██
# ██ [   https://discordapp.com/developers/applications/ ] ██
# ██ [   * Your Discord Channel ID's.                    ] ██
# ██ [   Right click the channel > Copy ID               ] ██
# ██ [                                                   ] ██
# ██ [   Create a directory in your denizen folder:      ] ██
# ██ [   * /plugins/denizen/Data/                        ] ██
# ██ [                                                   ] ██
# ██ [   Create the external file inside:                ] ██
# ██ [   * Discord_Chat_Relay_Config.yml                 ] ██
# ██ [                                                   ] ██
# ██ [   Paste the bot's information                     ] ██
# ██ [                                                   ] ██
# ███████████████████████████████████████████████████████████

# ███ [ Discord chat format             ] ███
DiscordRelayChatFormat:
  type: format
  debug: false
  format: "<&2><&l>[<&r><&a>Discord<&2><&l>]<&r><&f><text>"

# ███ [ DiscordBot | Discord Control    ] ███
Discord_Relay_Chat_Handler:
  type: world
  debug: true
  events:

# ███ [ Server Startup                  ] ███
    on server start:
      - wait 5s
      - run Discord_Chat_Relay_Config instantly context:-a
      - wait 1s
      - discord id:discord_chat_relay message channel:<server.flag[discord.channel.mainchat]> "<&co>white_check_mark<&co> **Server has started**"

# ███ [ Ingame Chat Relay               ] ███
    on player chats:
      - discord id:discord_chat_relay channel:<server.flag[discord.channel.mainchat]> message "**<player.groups.get[1]||>** <player.display_name.strip_color>: <context.message.strip_color>"
      - announce to_console "<&2>####### - <context.bot>"
      - announce to_console "<&2>####### - <context.author>"
      - announce to_console "<&2>####### - "
    #$                                                     Don't have Permission Groups? Remove: <player.groups.get[1]>
# ███ [ Discord Chat Relay              ] ███
    on discord message received for:discord_chat_relay:
      - if <context.channel> == <server.flag[discord.channel.mainchat]> && <context.message> != "" && <context.author_id> != <context.self>:
        - announce format:DiscordRelayChatFormat " | <context.author_name><&3><&l>]<&r> <&8>»<&f> <context.message.parse_color>"

# ███ [ Discord Player Events           ] ███
    on player first logs in:
      - discord id:discord_chat_relay message channel:<server.flag[discord.channel.mainchat]> "<&co>confetti_ball<&co> **<player.name> has logged in for the first time. Welcome them!** <&co>confetti_ball<&co>"
    on player joins:
      - discord id:discord_chat_relay message channel:<server.flag[discord.channel.mainchat]> "<&co>heavy_plus_sign<&co> **<player.display_name.strip_color> has logged in.**"
    on player quits:
      - discord id:discord_chat_relay message channel:<server.flag[discord.channel.mainchat]> "<&co>heavy_multiplication_x<&co> **<player.display_name.strip_color> has left the server.**"
    on player dies:
      - discord id:discord_chat_relay message channel:<server.flag[discord.channel.mainchat]> "<&co>skull<&co> **<context.message>**"
    on shutdown:
      - discord id:discord_chat_relay message channel:<server.flag[discord.channel.mainchat]> "<&co>octagonal_sign<&co> **Server is restarting - Please wait**"
      - flag server discord.botstatus:!

# ███ [ Discord Player Events | Addons  ] ███
    on votifier vote:
      - discord id:discord_chat_relay message channel:<server.flag[discord.channel.mainchat]> "<&co>diamond_shape_with_a_dot_inside<&co> **<context.username>** voted!"

# ███ [ Discord Channel Command/Update  ] ███
Discord_Link_And_Configuration_Command:
  type: command
  name: discord
  debug: true
  description: Sends you the discord join link
  permission: discord.command
  permission message: "You do not have permission"
  usage: /discord
  aliases:
    - disc
  tab complete:
    - if <player.is_op>:
      - define Args <list[reload|message]>
      - define messageArgs <server.flag[discord.channels]||>
    # @ ██ [  /discord█ ] ██
      - if <context.args.size> == 0:
        - determine <[Args]>
    # @ ██ [  /discord█Arg ] ██
      - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
        - determine <[Args].filter[starts_with[<context.args.get[1]>]]>
      - if <context.args.get[1]> != Message:
        - stop
    # @ ██ [  /discord█Arg█ ] ██
      - if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
        - determine <[messageArgs]>
    # @ ██ [  /discord█Arg█Arg ] ██
      - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
        - determine <[messageArgs].filter[starts_with[<context.args.get[2]>]]>
        
  syntax message:
  # @ ██ [  Message Hint event - inserts /discord ] ██
    - define Hover0 "<&a>Click to enter<&2>:<&nl><&6>/<&e>Discord"
    - define Text0 "<&6>/<&e>discord"
    - define Hint0 "discord"
    - define ClickEvent0 <&hover[<[Hover0]>]><&click[/<[Hint0]>].type[suggest_command]><[Text0]><&end_click><&end_hover>
  # @ ██ [  Check if Player is Operator for Command Syntax ] ██
    - if <player.is_op>:
    # @ ██ [  Message Hint event - inserts /discord reload ] ██
      - define Hover1 "<&a>Click to enter<&2>:<&nl><&6>/<&e>Discord Reload"
      - define Text1 "<&6>(<&e>reload<&6>)"
      - define Hint1 "discord reload"
      - define ClickEvent1 <&hover[<[Hover1]>]><&click[/<[Hint1]>].type[suggest_command]><[Text1]><&end_click><&end_hover>
    # @ ██ [  Message Hint event - inserts /discord reload -a ] ██
      - define Hover2 "<&a>Click to enter Reload All command!"
      - define Text2 "<&6>(<&e>-a<&6>)"
      - define Hint2 "discord reload -a"
      - define ClickEvent2 <&hover[<[Hover2]>]><&click[/<[Hint2]>].type[suggest_command]><[Text2]><&end_click><&end_hover>
    # @ ██ [  Message Hint event - inserts /discord message ] ██
      - define Hover3 "<&a>Click to enter Message Channel command!"
      - define Text3 "<&6>(<&e>Message ChannelName<&6>)"
      - define Hint3 "discord message "
      - define ClickEvent3 <&hover[<[Hover3]>]><&click[/<[Hint3]>].type[suggest_command]><[Text3]><&end_click><&end_hover>
  # @ ██ [  Narrate Syntaxes ] ██
      - narrate "<&e>Syntax<&co> <[ClickEvent0]> <[ClickEvent1]> <[ClickEvent2]>/<[ClickEvent3]><&nl><&3><script.yaml_key[description]> as well as reloads the discord configuration if specified to reload, optionally includes reloading the discord bot token (-a)."
    - else:
      - narrate "<&e>Syntax<&co> <[ClickEvent0]><&nl><&3><script.yaml_key[description]>"
  script:
  # @ ██ [  Check args; "/discord" or "/discord link" ] ██
    - define Arg1 <context.args.get[1]||null>
    - if <context.args.size> == 0 || <[Arg1]> == "link":
      - if !<server.has_flag[discord.link]>:
        - narrate "<&c>No link has been set up! Contact your server administrator to have them fix this!"
        - stop
      - define Hover "<&a>Click to follow the discord link!<&nl><&b><&n><server.flag[discord.link]>"
      - define Text " <&a>Link<&2>: <&b><&n><server.flag[discord.link]>"
      - define URL "<server.flag[discord.link]>"
      - narrate format:DiscordRelayChatFormat "<&hover[<[Hover]>]><&click[<[URL]>].type[OPEN_URL]><[Text]><&end_click><&end_hover>"
      - stop
  # @ ██ [  Check args; "/discord ARG" requires operator ] ██
    - else if <context.args.size> > 1 && !<player.is_op>:
      - inject locally "syntax message" instantly
      - stop
  # @ ██ [  Check args; "/discord reload -a" or "/discord reload" ] ██
    - else if <[Arg1]> == reload:
      - if <list[-a|null].contains[<context.args.get[2]||null>]>:
        - run Discord_Chat_Relay_Config instantly context:<context.args.get[2]||null>
        - stop
      - else:
        - inject locally "syntax message" instantly
  # @ ██ [  Check args; "/discord message" ] ██
    - else if <[Arg1]> == "message":
    # @ ██ [  Check args; did the player only specify "/discord message"? ] ██
      - if <context.args.size> == 1:
        - narrate "<&c>You must specify a channel to message!"
        - stop
    # @ ██ [  Check args; did the player only specify "/discord message channelname"? ] ██
      - else if <context.args.size> == 2:
      # @ ██ [  Does the channel even exist? ] ██
        - if <server.flag[discord.channels].contains[<context.args.get[2]>]>:
        # @ ██ [  Okay, the channel exists but you still typed it wrong ] ██
          - narrate "<&c>You must specify a message to send!"
        - else:
        # @ ██ [  Not only did you type a bad channel, you didn't even type a message ] ██
          - narrate "<&6>[<&e><context.args.get[2]><&6>]<&c> is an invalid channel, and you must specify a message to send!"
        - stop
      - else:
      # @ ██ [  Check if the bot running ] ██
        - if <server.has_flag[discord.botstatus]>:
          - if <server.flag[discord.botstatus]> == running:
          # @ ██ [  Check if the channel exists ] ██
            - define Channel <context.args.get[2]>
            - if <server.flag[discord.channels].contains[<[Channel]>]>:
            # @ ██ [  Send! ] ██
              - discord id:discord_chat_relay message channel:<server.flag[discord.channel.<[Channel]>]> <context.args.remove[1|2].separated_by[<&sp>].parse_color.strip_color>
            - else:
              - narrate "<&6>[<&e><[Channel]><&6>]<&c> is an invalid channel!"
          - else:
            - narrate "<&c>Bot is not running!"
            - stop
        - else:
          - narrate "<&c>Bot is not running!"
          - stop
    - else:
      - narrate "<&6>[<&e><[Arg1]><&6>]<&c> is an invalid Discord Command!"
      - stop

# ███ [ DiscordBot | Configuration      ] ███
Discord_Chat_Relay_Config:
  type: task
  debug: true
  definitions: Arg2
  script:
  # @ ██ [  Check if the Configuration file exists ] ██
    - if !<server.list_files[data].contains[Discord_Chat_Relay_Config.yml]>:
      - announce to_console "<&2>ERROR: CONFIGURATION FILE NOT FOUND.<&nl>For Support, ask in the <&e>Denizen Discord<&6>:<&nl> <&b>https://discord.gg/Q6pZGSR"
      - stop
  # @ ██ [  Load the Configuration file ] ██
    - yaml load:data/Discord_Chat_Relay_Config.yml id:discord_chat_relay_temp
    - flag server discord.key:loaded
  # @ ██ [  Check if doing a full reload ] ██
    - if <[Arg2]> == "-a":
    # @ ██ [  Check if the bot is running; Disconnect if it is ] ██
      - if <server.flag[discord.botstatus]||false> == "running":
        - flag server discord:!
        - discord id:discord_chat_relay disconnect
    # @ ██ [  Connect the bot ] ██
      - discord id:discord_chat_relay connect code:<yaml[discord_chat_relay_temp].read[bots.discord.botToken]>
      - flag server discord.botstatus:running
  # @ ██ [  Flag the link and channels ] ██
    - flag server discord.link:<yaml[discord_chat_relay_temp].read[bots.discord.discordlink]>
    - flag server discord.channels:!
    - define Channels <yaml[discord_Chat_relay_temp].list_keys[bots.discord.channel]>
    - flag server discord.channels:|:<[Channels]>
    - foreach <[Channels].exclude[mainchat]> as:Channel:
      - flag server discord.channel.<[Channel]>:<yaml[discord_chat_relay_temp].read[bots.discord.channel.<[Channel]>]>
    - flag server discord.channel.mainchat:<yaml[discord_chat_relay_temp].read[bots.discord.channel.mainchat]>
    - yaml unload id:discord_chat_relay_temp
    - flag server discord.key:!