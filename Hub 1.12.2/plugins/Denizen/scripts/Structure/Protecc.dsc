# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
# $ ██  [ TO-DO   ] ██
Deprec_Command:
    type: command
    name: t
    debug: true
    description: Changes your display name.
    usage: /nickname <&lt>Nickname<&gt>
    permission: behrry.essentials.nickname
    aliases:
        - knee
    tab complete:
    script:
        - define Key <player.location.cursor_on.chunk>
        - define Size <yaml[<[Key]>].list_keys[<player.location.cursor_on>].size>
        - define Logs "<yaml[<[Key]>].list_keys[<player.location.cursor_on>].sort_by_number[in_hours].get[<[Size].sub[10]>].to[<[Size]>]>"
        - foreach <[Logs].parse[replace[tacosauce].with[.].as_duration]> as:Log:
            - define Mo <[Log]...pad_left[2].with[0]>
            - define da <[Log]...pad_left[2].with[0]>
            - define yy <[Log]...pad_left[2].with[0]>
            - define hh <[Log]...pad_left[2].with[0]>
            - define mi <[Log]...pad_left[2].with[0]>
            - define ss <[Log]...pad_left[2].with[0]>
            - define formattedtime [<[mo]>/<[da]>/<[yy]>]-[<[hh]>:<[mi]>:<[ss]>]
            - narrate <[formattedtime]>

#-<util.date.format[[MM:dd:yy]-[KK:mm:hh]]>


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
