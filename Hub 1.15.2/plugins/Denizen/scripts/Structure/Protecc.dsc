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
        - define Key <player.location.cursor_on.chunk.after[@]>
        # | The spot we're reading is the block's location
        # + we're using the block we're looking at for reference until a stick is made
        # + idea - highlight blocks with particles like BehrEdit selections, click for info on that block
        - define Loc <player.location.cursor_on>
        # | determine number of logs on the referenced block
        - define Size <yaml[<[Key]>].list_keys[<[Loc]>].size>
        # | select the last ten logs after sorting the timestamps
        # + chat controls can flip between pages
        - define Logs "<yaml[<[Key]>].list_keys[<[Loc]>].parse[replace[tacosauce].with[.].as_duration].sort_by_number[in_ticks].get[<[Size].sub[10]>].to[<[Size]>]>"
        
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
            # define TimePrint "<&b>[<&3><[mo]><&b>/<&3><[da]><&b>/<&3><[yy]><&b>]-[<&3><[hh]><&b>:<&3><[mi]><&b>:<&3><[ss]><&b>]"
            - define Timestamp [<[mo]>/<[da]>/<[yy]>]-[<[hh]>:<[mi]>:<[ss]>]
            - define TimePrint <proc[Colorize].context[<[Timestamp]>|BlueInverted]>
            - define Hover1 "<&6>O<&e>ccured<&6>: <&a> <util.date.time.duration.sub[<[Log]>].formatted> ago<&nl><proc[Colorize].context[[Click] to Document<&nl>[Shift] + [Click] to Insert:|green]><&nl><[TimePrint]>"
            - define Text1 "<[TimePrint]>"
            - define Command1 "Placeholder"
            - define Insert1 "[<[mo]>/<[da]>/<[yy]>]-[<[hh]>:<[mi]>:<[ss]>]"
            - Define TimeKey <proc[MsgCmdIns].context[<[Hover1]>|<[Text1]>|<[Command1]>|<[Insert1]>]>

            # | Fix the Log for the next key
            - define nextkey <[Log].replace[.].with[tacosauce]>
            - define PlayerKey <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[1].as_player>
            
            # | For the Player Text
            - define Hover2 "<&6>P<&e>ayer<&6>: <proc[User_Display_Simple].context[<[PlayerKey]>]><&nl><proc[Colorize].context[[Click] to Document<&nl>[Shift] + [Click] to Manage|Green]>
            - define Text2 "<&b>[<&a><[PlayerKey].name><&b>]"
            - define Command2 "placeholder"
            - define Insert2 "/mod <[PlayerKey].name> "
            - define Player <proc[MsgCmdIns].context[<[Hover2]>|<[Text2]>|<[Command2]>|<[Insert2]>]>

            # | For the objects
            - define ActionKey <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[2]>
            - define OldMaterialKey <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[3]>
            - define NewMaterialKey <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[4]>

            - define Hover3 "<&6>P<&e>ayer<&6>: <proc[User_Display_Simple].context[<[PlayerKey]>]><&nl><&6>A<&e>ction<&6>: <&a><[ActionKey]> block<&nl><proc[Colorize].context[Old Material:|yellow]> <&a><[OldMaterialKey]><&nl><proc[Colorize].context[New Material:|yellow]> <&a><[NewMaterialKey]>"
            - define Text3 "[<&e><[ActionKey]><&b>]-[<&e><[OldMaterialKey]><&b>]"
            - define Command3 "placeholder"
            - define Action <proc[MsgCmd].context[<[Hover3]>|<[Text3]>|<[Command3]>]>
            
            - narrate <[TimeKey]><&b>-<[Player]>-<[Action]>
Protecc_Handler:
    type: world
    debug: true
    events:
        on player breaks block:
            - define Chunk <context.location.chunk.after[ch@]>
            # - data | 1) Location | 2) Time | 3) Player | 4) Action | 5) Old Material | 6) New Material
            - define Data <list[<context.location>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>|Broke|<context.material.name>|air]>
            - if !<server.has_file[data/ProteccData/<[Chunk]>.yml]>:
                - yaml id:<[Chunk]> create
            - yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>:|:<[Data].get[3]>|<[Data].get[4]>|<[Data].get[5]>|<[Data].get[6]>
            - yaml id:<[Chunk]> savefile:data/ProteccData/<[Chunk]>.yml

        on player places block:
            - define Chunk <context.location.chunk.after[ch@]>
            # - data | 1) Location | 2) Time | 3) Player | 4) Action | 5) Old Material | 6) New Material
            - define Data <list[<context.location>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>|Placed|<context.material.name>|<context.old_material.name>]>
            - if !<server.has_file[data/ProteccData/<[Chunk]>.yml]>:
                - yaml id:<[Chunk]> create
            - yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>:|:<[Data].get[3]>|<[Data].get[4]>|<[Data].get[5]>|<[Data].get[6]>
            - yaml id:<[Chunk]> savefile:data/ProteccData/<[Chunk]>.yml

        #-chest|trapped_chest|*_shulker*|shulker_box:
        on player opens inventory:
            # - data | 1) Inventory | 2) Time | 3) Player | 4) Action | 5) Contents
            - flag <player> "Protecc.Recording_Inventory:|:<context.inventory>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>|Opened Inventory|<context.inventory.list_contents.escaped>"
        on player closes inventory:
            - if <player.has_flag[Protecc.Recording_Inventory]>:
                - if <player.flag[Protecc.Recording_Inventory].get[1].as_inventory.location> == <context.inventory.location>:
                    - define OpenData:|:<player.flag[Protecc.Recording_Inventory].get[5].unescaped>
                    - define CloseData:|:<context.inventory.list_contents>
                    
                    - narrate <&b><inventory[blank_inventory].list_contents>
                    - narrate <&c><inventory[blank_inventory].include[<[OpenData]>].list_contents>
                    - narrate <&b><inventory[blank_inventory].include[<[OpenData]>].exclude[<[CloseData]>].list_contents>
                    - narrate <&c><inventory[blank_inventory].include[<[OpenData]>].exclude[<[CloseData]>].list_contents.exclude[air]><&nl>

                    - define RemoveList:|:<inventory[blank_inventory].include[<[OpenData]>].exclude[<[CloseData]>].list_contents.exclude[air]>
                    - define DepositList:|:<context.inventory.exclude[<[OpenData]>].list_contents.exclude[air]>

                    #- narrate <&a><[RemoveList]>
                    #- narrate <&e><[DepositList]>
                    
                    # - data | 1) Inventory | 2) Time | 3) Player | 4) Action | 5) Contents Before | 6) Contents After | 7) List of Removed | 8) List of Deposited
                    - define Key:|:<context.inventory>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>|<[OpenData].escaped>|<[CloseData].escaped>|<&a><[RemoveList]><&r>|<&e><[DepositList]>
                    
                    - if <[RemoveList].Size> != 0 && <[DepositList].size> != 0:
                        - define Key "<[Key].insert[Removed and Deposited].at[4]>"
                    - else if <[RemoveList].size> != 0:
                        - define Key <[Key].insert[Removed].at[4]>
                    - else if <[DepositList].size> != 0:
                        - define Key <[Key].insert[Deposited].at[4]>
                    - else:
                        - define Key <[Key].insert[Opened].at[4]>

                    - narrate "- <[Key].separated_by[<&nl> -].unescaped>"

                    #
                    #- foreach <[OpenData]> as:Item:
                    #    - define "BeforeList:|:<[Item].material.name>/<inventory[blank_inventory].include[<[OpenData].after[li@]>].quantity.material[<[Item].material.name>]>"
                    #- foreach <[CloseData]> as:Item:
                    #    - define "AfterList:|:<[Item].material.name>/<context.inventory.quantity.material[<[Item].material.name>]>"
                    #
                    ## -Take List
                    #- foreach <[BeforeList].deduplicate> as:Item:
                    #    - if <[item].before[/]> == air:
                    #        - foreach next
                    #    - define Math <[BeforeList].deduplicate.map_get[<[Item].before[/]>].sub[<[AfterList].deduplicate.map_get[<[Item].before[/]>]>]>
                    #    - if <[Math]> <= 0:
                    #        - foreach next
                    #    - define RemoveList:->:<[Item].before[/]>/<[Math]>
                    ## -Deposit List
                    #- foreach <[AfterList].deduplicate> as:Item:
                    #    - if <[item].before[/]> == air:
                    #        - foreach next
                    #    - define Math <[AfterList].deduplicate.map_get[<[Item].before[/]>].sub[<[BeforeList].deduplicate.map_get[<[Item].before[/]>]>]>
                    #    - if <[Math]> <= 0:
                    #        - foreach next
                    #    - define DepositList:->:<[Item].before[/]>/<[Math]>
                    ## - data | 1) Inventory | 2) Time | 3) Player | 4) Action | 5) Contents Before | 6) Contents After | 7) List of Removed | 8) List of Deposited
                    #- define Key:|:<context.inventory>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>
                    #- if <[RemoveList].Size||0> != 0 && <[DepositList].size||0> != 0:
                    #    - define "Key:->:Removed and Deposited"
                    #- else if <[RemoveList].size||0> != 0:
                    #    - define "Key:->:Removed"
                    #- else if <[DepositList].size||0> != 0:
                    #    - define "Key:->:Deposited"
                    #- else:
                    #    - define "Key:->:Opened"
                    #- define Key:->:<[OpenData].escaped>|<[CloseData].escaped>|<[RemoveList].escaped||null>|<[DepositList].escaped||null>
                    #- narrate <[Key]>
                    #
                    - flag <player> Protecc.Recording_Inventory:!
        on player right clicks orange_shulker_box with stick:
            - determine passively cancelled
            - define Inventory <player.location.cursor_on.inventory>
            - foreach <[Inventory].list_contents> as:item:
                - define "List:|:<[Inventory].quantity.material[<[Item].material.name>]> <[Item].material.name>"
            - narrate "- <[List].deduplicate.exclude[0 air].separated_by[<&nl>- ]>"
        on player changes sign:
        - narrate "<context.location> returns the LocationTag of the sign."
        - narrate "<context.new> returns the new sign text as a ListTag."
        - narrate "<context.old> returns the old sign text as a ListTag."
        - narrate "<context.material> returns the MaterialTag of the sign."

        
        on player enters <notable cuboid>:
            - narrate "<context.from> returns the block location moved from."
            - narrate "<context.to> returns the block location moved to."
            - narrate "<context.cuboids> returns a list of cuboids entered/exited (when no cuboid is specified in the event name)."
            - narrate "<context.cause> returns the cause of the event. Can be: WALK, WORLD_CHANGE, JOIN, LEAVE, TELEPORT, VEHICLE"
        on player exits <notable cuboid>:
            - narrate "<context.from> returns the block location moved from."
            - narrate "<context.to> returns the block location moved to."
            - narrate "<context.cuboids> returns a list of cuboids entered/exited (when no cuboid is specified in the event name)."
            - narrate "<context.cause> returns the cause of the event. Can be: WALK, WORLD_CHANGE, JOIN, LEAVE, TELEPORT, VEHICLE"
        on player enters notable cuboid:
            - narrate "<context.from> returns the block location moved from."
            - narrate "<context.to> returns the block location moved to."
            - narrate "<context.cuboids> returns a list of cuboids entered/exited (when no cuboid is specified in the event name)."
            - narrate "<context.cause> returns the cause of the event. Can be: WALK, WORLD_CHANGE, JOIN, LEAVE, TELEPORT, VEHICLE"
        on player exits notable cuboid:
            - narrate "<context.from> returns the block location moved from."
            - narrate "<context.to> returns the block location moved to."
            - narrate "<context.cuboids> returns a list of cuboids entered/exited (when no cuboid is specified in the event name)."
            - narrate "<context.cause> returns the cause of the event. Can be: WALK, WORLD_CHANGE, JOIN, LEAVE, TELEPORT, VEHICLE"