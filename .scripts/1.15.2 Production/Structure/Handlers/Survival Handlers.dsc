Survival_Mechanics:
    type: world
    debug: false
    events:
        on dispenser dispenses item:
            - if <context.item.contains[Concrete_Powder]>:
                - determine passively cancelled
                - define Loc <context.location.add[<context.location.block_facing>]>
                - if <[Loc].material.name.contains_any[air|water|lava]>:
                    - modifyblock <[Loc]> <context.item.material> naturally

Silk_Spawners:
  type: world
  debug: false
  events:
    on player breaks spawner:
      - define Type <context.location.spawner_type.after[@].to_titlecase>
      - determine "i@spawner[display_name=<[Type]> Spawner;nbt=li@key/<[Type]>]"
    on player places spawner:
        - if <context.hand> == HAND:
            - define Type <player.item_in_hand.nbt[key]>
        - else:
            - define Type <player.item_in_offhand.nbt[key]>
        - wait 1t
        - modifyblock <context.location> spawner
        - adjust <context.location> "spawner_type:<[Type]>"

Bed_Fix:
    type: world
    debug: false
    events:
        on player enters bed:
            - flag player behrry.essentials.inbed
            - wait 1s
            - while <player.has_flag[behrry.essentials.inbed]>:
                - if <player.world.time.div[1000].round_up> < 13:
                    - define timeh <player.world.time.div[1000].round_up.pad_left[2].with[0]>
                - else:
                    - define timeh <player.world.time.div[1000].round_up.sub[12].pad_left[2].with[0]>
                - define timem <player.world.time.duration.time.second.pad_left[2].with[0]>

                - time <player.world.time.add[5]>t
                - actionbar "<proc[Colorize].context[time: <[timeh]>:<[timem]>|green]>"
                - wait 1t
        on player leaves bed:
            - flag player behrry.essentials.inbed:!