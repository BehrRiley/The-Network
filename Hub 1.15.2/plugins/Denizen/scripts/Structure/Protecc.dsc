# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██
Deprec_Command:
    type: command
    name: t
    debug: true
    description: aaa
    usage: /aaaa
    permission: behrry.essentials.nickname
    aliases:
        - knee
    tab complete:
    script:
        # | The main file is the Chunk
        - define Key <player.location.cursor_on.chunk>
        # | The spot we're reading is the block's location
        # + we're using the block we're looking at for reference until a stick is made
        # + idea - highlight blocks with particles like BehrEdit selections, click for info on that block
        - define Loc <player.location.cursor_on>
        # | determine number of logs on the referenced block
        - define Size <yaml[<[Key]>].list_keys[<[Loc]>].size>
        # | select the last ten logs after sorting the timestamps
        # + chat controls can flip between pages
        - define Logs "<yaml[<[Key]>].list_keys[<[Loc]>].sort_by_number[in_hours].get[<[Size].sub[10]>].to[<[Size]>]>"
        
        # | Formatting the timestamps for prints
        - foreach <[Logs].parse[replace[tacosauce].with[.].as_duration]> as:Log:
            # define PrintTime [<util.date.time.duration.time.month.pad_left[2].with[0]>/<util.date.time.duration.time.day.pad_left[2].with[0]>/<util.date.time.duration.time.year>]-[<util.date.time.duration.time.hour.pad_left[2].with[0]>:<util.date.time.duration.time.minute.pad_left[2].with[0]>:<util.date.time.duration.time.second.pad_left[2].with[0]>]
            # define PrintTime <util.date.format[[MM:dd:yy]-[KK:mm:hh]]>
            - define Mo <[Log].time.month.pad_left[2].with[0]>
            - define da <[Log].time.day.pad_left[2].with[0]>
            - define yy <[Log].time.year.after[20]>
            - define hh <[Log].time.hour.pad_left[2].with[0]>
            - define mi <[Log].time.minute.pad_left[2].with[0]>
            - define ss <[Log].time.second.pad_left[2].with[0]>
            # [<[mo]>/<[da]>/<[yy]>]-[<[hh]>:<[mi]>:<[ss]>]
            - define TimePrint "<&b>[<&3><[mo]><&b>/<&3><[da]><&b>/<&3><[yy]><&b>]-[<&3><[hh]><&b>:<&3><[mi]><&b>:<&3><[ss]><&b>]"
            - define Hover "<&6>O<&e>ccured<&6>: <&a> <[Log].sub[<util.date.time.duration>].formatted> ago<&nl><proc[Colorize].context[Shift+Click to Insert:|green]><&nl><[TimePrint]>"
            - define Text "<[TimePrint]>"
            - define Insert "[<[mo]>/<[da]>/<[yy]>]-[<[hh]>:<[mi]>:<[ss]>]"
            - narrate <[formattedtime]>

            # | Fix the Log for the next key
            - define nextkey <[Log].replace[.].with[tacosauce]>
            - define PlayerKey <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>]>
            
            # | For the Player Text
            - define Hover "<proc[Colorize].context[Click to Document|Green]>
            - define Text "<&b>[<&a>[<[PlayerName]><&b>]"
            - define Command "help"
            - define Player <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>

Protecc_Handler:
    type: world
    debug: true
    events:
        on player breaks block:
            - define Chunk <context.location.chunk.after[ch@]>
            # - data | 1) Location | 2) Time | 3) Player | 4) Action | 5) Old Material | 6) New Material
            - define Data <list[<context.location>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>|broke|m@air|<context.material>]>
            - if !<server.has_file[data/ProteccData/<[Chunk]>.yml]>:
                - yaml id:<[Chunk]> create
            - yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>:->:<[Data].get[3]>|<[Data].get[4]>|<[Data].get[5]>|<[Data].get[6]>
            - yaml id:<[Chunk]> savefile:data/ProteccData/<[Chunk]>.yml


        on player places block:
            - define Chunk <context.location.chunk.after[ch@]>
            # - data | 1) Location | 2) Time | 3) Player | 4) Action | 5) Old Material | 6) New Material
            - define Data <list[<context.location>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>|placed|<context.material>|<context.old_material>]>
            - if !<server.has_file[data/ProteccData/<[Chunk]>.yml]>:
                - yaml id:<[Chunk]> create
            - yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>:->:<[Data].get[3]>|<[Data].get[4]>|<[Data].get[5]>|<[Data].get[6]>
            #- yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>.0:<[Data].get[3]>
            #- yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>.1:<[Data].get[4]>
            #- yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>.2:<[Data].get[5]>
            #- yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>.3:<[Data].get[6]>
            - yaml id:<[Chunk]> savefile:data/ProteccData/<[Chunk]>.yml
