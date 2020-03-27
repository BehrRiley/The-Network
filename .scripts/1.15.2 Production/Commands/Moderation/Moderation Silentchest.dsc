# | ███████████████████████████████████████████████████████████
# % ██    /silentchest - Silently and discretely opens chests
# | ██
# % ██  [ Command ] ██
silentchest_Command:
  type: command
  name: silentchest
  debug: false
  description: Silently and discretely opens chests
  permission: behrry.moderation.silentchest
  usage: /silentchest (on/off)
  Syntax:
  Activate:
    - if <player.has_flag[behrry.moderation.silentchest]>:
      - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
    - else:
      - flag player behrry.moderation.silentchest
      - narrate "<proc[Colorize].context[Silent Chest Mode Enabled.|green]>"
  Deactivate:
    - if !<player.has_flag[behrry.moderation.silentchest]>:
      - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
    - else:
      - flag player behrry.moderation.silentchest:!
      - narrate "<proc[Colorize].context[Silent Chest Mode Enabled.|green]>"
  script:
    - define Arg <context.args.get[1]||null>
    - define ModeFlag behrry.moderation.silentchest
    - define ModeName "Silent Chest"
    - inject Activation_Arg_Command Instantly


silentchest_listener:
  type: world
  debug: false
  events:
    on player right clicks chest|*shulker*|trapped_chest:
        - if <player.has_flag[behrry.moderation.silentchest]>:
            - determine passively cancelled
            - inventory open <player.location.cursor_on.inventory>
