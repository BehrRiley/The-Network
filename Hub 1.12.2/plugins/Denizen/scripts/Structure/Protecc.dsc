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
        - narrate <&b>+<&3>-----------------<&b>ProteccData<&3>-----------------<&b>+
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
            - choose <[ActionKey]>:
                - case "Placed" "Broke":
                    - define OldMaterialKey <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[3]>
                    - define NewMaterialKey <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[4]>

                    - define Hover3 "<&6>P<&e>ayer<&6>: <proc[User_Display_Simple].context[<[PlayerKey]>]><&nl><&6>A<&e>ction<&6>: <&a><[ActionKey]> block<&nl><proc[Colorize].context[Old Material:|yellow]> <&a><[OldMaterialKey]><&nl><proc[Colorize].context[New Material:|yellow]> <&a><[NewMaterialKey]>"
                    - define Text3 "[<&e><[ActionKey]><&b>]-[<&e><[OldMaterialKey]><&b>]"
                - case "Exchanged" "Removed" "Deposited" "Opened":
                    - define ContentsBefore <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[3].unescaped>
                    - define ContentsAfter <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[4].unescaped>
                    - define Removed <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[5].unescaped>
                    - define Deposited <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[6].unescaped>
                    - define Block <yaml[<[Key]>].read[<[Loc]>.<[NextKey]>].get[7]>

                    - define RemovedNote:!
                    - repeat <[Removed].size.min[4]>:
                        - if <[Removed].size> == 0:
                            - repeat stop
                        - if <[Value]> == 4:
                            - if <[Removed].size> > 4:
                                - define RemovedNote:->:<&6>(<&a>+<[Removed].size.sub[3]><&2>x<&6>)...
                            - else:
                                - define RemovedNote:->:<&a><[Removed].get[<[Value]>].material.name.replace[_].with[<&sp>].to_titlecase><&sp><&2>x<&e><[Removed].get[<[Value]>].quantity>
                        - else:
                            - if <[Removed].size> >= <[Value]>:
                                - define RemovedNote:->:<&a><[Removed].get[<[Value]>].material.name.replace[_].with[<&sp>].to_titlecase><&sp><&2>x<&e><[Removed].get[<[Value]>].quantity>
                            - else:
                                - repeat stop
                    - define DepositedNote:!
                    - repeat <[Deposited].size.min[4]>:
                        
                        - if <[Deposited].size> == 0:
                            - repeat stop
                        - if <[Value]> == 4:
                            - if <[Deposited].size> > 4:
                                - define DepositedNote:->:<&6>(<&a>+<[Deposited].size.sub[3]><&2>x<&6>)...
                            - else:
                                - define DepositedNote:->:<&a><[Deposited].get[<[Value]>].material.name.replace[_].with[<&sp>].to_titlecase><&sp><&2>x<&e><[Deposited].get[<[Value]>].quantity>
                        - else:
                            - if <[Deposited].size> >= <[Value]>:
                                - define DepositedNote:->:<&a><[Deposited].get[<[Value]>].material.name.replace[_].with[<&sp>].to_titlecase><&sp><&2>x<&e><[Deposited].get[<[Value]>].quantity>
                            - else:
                                - repeat stop
                            

                    - choose <[ActionKey]>:
                        - case "Exchanged":
                            - define SubAction "<proc[Colorize].context[Remove List:|yellow]><&nl><&a><[RemovedNote].separated_by[<&nl>]>"
                            - define SubAction "<proc[Colorize].context[Deposit List:|yellow]><&nl><&a><[DepositedNote].separated_by[<&nl>]>"
                        - case "Removed":
                            - define SubAction "<proc[Colorize].context[Remove List:|yellow]><&nl><&a><[RemovedNote].separated_by[<&nl>]>"
                        - case "Deposited":
                            - define SubAction "<proc[Colorize].context[Deposit List:|yellow]><&nl><&a><[DepositedNote].separated_by[<&nl>]>"
                        - case "Opened":
                            - define SubAction "<proc[Colorize].context[Opened and Viewed|yellow]>"
                    #- define SubAction Placeholder

                    - define Hover3 "<&6>P<&e>ayer<&6>: <proc[User_Display_Simple].context[<[PlayerKey]>]><&nl><&6>A<&e>ction<&6>: <&a><[ActionKey]> inventory<&nl><[SubAction]>"
                    - define Text3 "[<&e><[ActionKey]><&b>]-[<&e><[Block].to_titlecase><&b>]"
            
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
            - if <context.inventory.location||null> == null:
                - stop
            - if <player.has_flag[Protecc.Recording_Inventory]>:
                - flag <player> Protecc.Recording_Inventory:!
            - flag <player> "Protecc.Recording_Inventory:|:<context.inventory.location>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>|Opened Inventory|<context.inventory.list_contents.escaped>"
        on player closes inventory:
            - if <context.inventory.location||null> == null:
                - stop
            - if <player.has_flag[Protecc.Recording_Inventory]>:
                - if <player.flag[Protecc.Recording_Inventory].get[1].as_location> == <context.inventory.location>:
                    - define Chunk <context.inventory.location.chunk.after[ch@]>
                    - define OpenData:|:<player.flag[Protecc.Recording_Inventory].get[5].unescaped>
                    - define CloseData:|:<context.inventory.list_contents>
                    - if <[OpenData].size> > 0:
                        - define RemoveList:|:<inventory[blank_inventory].include[<[OpenData]>].exclude[<[CloseData]>].list_contents.exclude[i@air]>
                        - define DepositList:|:<context.inventory.exclude[<[OpenData]>].list_contents.exclude[i@air]>
                    - else:
                        - if <[CloseData].size> == 0:
                            - define RemoveList li@
                        - else:
                            - define RemoveList:|:<inventory[blank_inventory].exclude[<[CloseData]>].list_contents.exclude[i@air]>
                        - define DepositList:|:<context.inventory.list_contents.exclude[i@air]>

                    
                    
                    # - data | 1) Inventory Location | 2) Time | 3) Player | 4) Action | 5) Contents Before | 6) Contents After | 7) List of Removed | 8) List of Deposited | 9) Block Type
                    - define Data:|:<context.inventory.location>|<util.date.time.duration.replace[.].with[tacosauce]>|<player>|<[OpenData].escaped>|<[CloseData].escaped>|<[RemoveList].escaped>|<[DepositList].escaped>|<context.inventory.inventory_type>
                    
                    - if <[RemoveList].Size> != 0 && <[DepositList].size> != 0:
                        - define Data "<[Data].insert[Exchanged].at[4]>"
                    - else if <[RemoveList].size> != 0:
                        - define Data <[Data].insert[Removed].at[4]>
                    - else if <[DepositList].size> != 0:
                        - define Data <[Data].insert[Deposited].at[4]>
                    - else:
                        - define Data <[Data].insert[Opened].at[4]>

                    - if !<server.has_file[data/ProteccData/<[Chunk]>.yml]>:
                        - yaml id:<[Chunk]> create
                    - yaml id:<[Chunk]> set <[Data].get[1]>.<[Data].get[2]>:|:<[Data].get[3].to[9]>
                    - yaml id:<[Chunk]> savefile:data/ProteccData/<[Chunk]>.yml

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