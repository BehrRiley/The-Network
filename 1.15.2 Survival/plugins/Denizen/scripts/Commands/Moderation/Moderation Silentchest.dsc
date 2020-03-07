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
    - choose <context.args.get[1]||null>:
      - case "on":
        - inject locally Activate Instantly
      - case "off":
        - inject locally Deactivate Instantly
      - case "null":
        - if <player.has_flag[behrry.moderation.silentchest]>:
          - inject locally Deactivate Instantly
        - else:
          - inject locally Activate Instantly
      - case default:
        - inject Command_Syntax Instantly

silentchest_listener:
  type: world
  debug: false
  events:
    on player right clicks chest|*shulker*|trapped_chest:
        - if <player.has_flag[behrry.moderation.silentchest]>:
            - determine passively cancelled
            - inventory open <player.location.cursor_on>
