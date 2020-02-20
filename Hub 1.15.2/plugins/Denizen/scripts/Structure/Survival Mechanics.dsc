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
  debug: true
  events:
    on player breaks spawner:
      - define Type <context.location.spawner_type.after[@].to_titlecase>
      - determine "i@spawner[display_name=<[Type]> Spawner;nbt=li@key/<[Type]>]"
    on player places spawner:
        - wait 1t
        - if <context.hand> == HAND:
                - define Type <player.item_in_hand.nbt[key]>
        - else:
                - define Type <player.item_in_offhand.nbt[key]>
        - modifyblock <context.location> spawner
        - adjust <context.location> "spawner_type:<[Type]>"

CreativeCommandChecker:
    type: world
    debug: false
    events:
        on overlay|walls|outline|center|smooth|deform|hollow|regen|move|naturalize|line|curve|forest|flora|custompaste|schematic|schem|generate|generatebiome|hcyl|cyl|sphere|hsphere|pyramid|hpyramid|forestgen|pumpkins|toggleplace|fill|fillr|drain|fixwater|fixlava|removeabove|removebelow|replacenear|removenear|snow|thaw|butcher|remove command:
            - if <player.gamemode> != Creative:
                - narrate "<&c>This command is permitted only in Creative"
                - determine fulfilled
        on cut|set|replace|pos1|pos2|hpos1|hpos2|stack|flip|rotate|copy command:
            - if <player.gamemode> != Creative:
                - if <player.gamemode> == Spectator:
                    - stop
                - narrate "<&c>This command is permitted only in Creative or Spectator Mode."
                - determine fulfilled
        on player drops item:
            - define location "<player.display_name> attempted to drop items at <&6>[<&6>X:<&e><player.location.x.round_down>, <&6>Y:<&e><player.location.y.round_down>, <&6>Z:<&e><player.location.z.round_down><&6>]<&f> in creative mode."
            - define log "<util.date.time.month>/<util.date.time.day>/<util.date.time.year>|<util.date.time.hour>:<util.date.time.minute>:<util.date.time.second>|<player.name> "
            - if <player.gamemode> == creative && <player.groups.contains_any[Coordinator|Administrator|Moderator|Developer|Constructor].not>:
                - narrate "Staff Alerted & Action Documented. You are not allowed to transfer items from Creative."
                - log "<[log]> tried to drop items in creative." type:none file:data/logs/creativerestrictions.log
                - if !<server.has_flag[creativerestrictionspam]>:
                    - flag server creativerestrictionspam duration:2s
                    - narrate targets:<server.list_online_players.filter[groups.contains_any[Coordinator|Administrator|Moderator]]> "<player.name> is trying to transfer items from Creative. [Drop]"
                - determine cancelled
        on player opens inventory:
            - define location "<player.display_name> attempted to open a chest at <&6>[<&6>X:<&e><player.location.x.round_down>, <&6>Y:<&e><player.location.y.round_down>, <&6>Z:<&e><player.location.z.round_down><&6>]<&f> in creative mode."
            - define log "<util.date.time.month>/<util.date.time.day>/<util.date.time.year>|<util.date.time.hour>:<util.date.time.minute>:<util.date.time.second>|<player.name> "
            - if <player.gamemode> == creative && <player.groups.contains_any[Coordinator|Administrator|Moderator|Developer|Constructor].not>:
                - determine passively cancelled
                - narrate targets:<server.list_online_players.filter[groups.contains_any[Coordinator|Administrator|Moderator]]> "<[location]>"
                - narrate "Staff Alerted & Action Documented. You are not allowed to transfer items from Creative."
                - log "<[log]> tried to transfer items in creative at:<[location].strip_color>" type:none file:data/logs/creativerestrictions.log