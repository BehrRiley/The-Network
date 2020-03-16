Mining_Handler:
    type: world
    debug: false
    ExpGet:
        - if !<player.has_flag[Behrry.skill.Mining.cd]>:
            - flag player Behrry.skill.Mining.cd:+:<[XP]> duration:2s
            - while true:
                - wait 2s
                - if <player.has_flag[Behrry.skill.Mining.cd]>:
                    - define XP:<player.flag[Behrry.skill.Mining.cd]>
                    - while next
                - run add_xp def:<[XP]>|Mining instantly
                - while stop
        - else:
            - flag player Behrry.skill.Mining.cd:+:<[XP]> duration:2s

    events:
        on player breaks dirt|stone|sand|andesite|cobblestone|end_stone|granite|mossy_cobblestone|nether_bricks|sandstone|stone|diorite|gravel:
            - define XP 1
            - inject Locally ExpGet Instantly
        on player breaks iron_ore|lapis_ore|coal_ore|nether_quartz_ore|redstone_ore|gold_ore|polished_andesite|polished_diorite|stone_bricks|mossy_stone_bricks|obsidian:
            - define XP 5
            - inject Locally ExpGet Instantly
        on player breaks diamond_ore|emerald_ore:
            - define XP 15
            - inject Locally ExpGet Instantly