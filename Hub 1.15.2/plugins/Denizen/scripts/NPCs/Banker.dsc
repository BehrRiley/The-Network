# | ███████████████████████████████████████████████████████████
# % ██        /npc assignment --set BankerNPC
# | ██
# % ██    [ Assignment Script ] ██
# $ ██    [ To-Do ] | Pin Settings | Grand Exchange                        ██
Banker:
    type: assignment
    debug: false
    actions:
        on assignment:
            - trigger name:click state:true
            - trigger name:proximity state:true radius:4
            - trigger name:chat state:true
            - if <server.has_flag[npc.skin.<script.name>]>:
                - adjust <npc> skin_blob:<server.flag[npc.skin.<script.name>]>
            - else:
                - narrate "<proc[Colorize].context[No NPC skin saved for:|red]> <&6>'<&e><script.name><&6>'"
        on exit proximity:
            - if <player.flag[interacting_npc]||> == <script.name>:
                - flag player interacting_npc:!
                - if <script[<script.name>_Interact].step[<player>]> != Normal:
                        - zap Banker_Interact Normal
        on click:
            - if <player.flag[interacting_npc]||> != <script.name>:
                - flag player interacting_npc:<script.name>
            
    # $ - if <player.has_flag[GrandExchange.collection.alert]>:
    # $     - narrate format:npc "Good day. Before we go any further, I should inform you that you have items ready for collection from the Grand Exchange. How may i help you?"
    # $ - else:
            - narrate format:npc "Good day. How may i help you?"
            - inject locally GenericGreeting Instantly
    GenericGreeting:
        - wait 2s
    # $ - define Options_List "<list[I'd like to access my bank account, please|I'd like to check my pin settings|i'd like to see my collection box|What is this place?]>"
        - define Options_List "<list[I'd like to access my bank account, please|What is this place?]>"
    # $ - define Trigger_List "<list[access|pin|collection|place]>"
        - define Trigger_List <list[access|place]>
        - if <script[<script.name>_Interact].step[<player>]> != Normal:
            - zap Banker_Interact Normal
        - inject Trigger_Option_builder Instantly
    interact scripts:
        - Banker_Interact

# | ██    [ Banker Interact Script ] ██
Banker_Interact:
    type: interact
    debug: false
    speed: 0
    steps:
        Normal*:
            chat trigger:
                Bank:
                    trigger: "/access|bank|account/"
                    hide trigger message: true
                    script:
                        - flag player interacting_npc:!
                        - run open_bank instantly
                Pin:
                    trigger: "/check|pin|settings/"
                    hide trigger message: true
                    script:
                        - flag player interacting_npc:!
                        - narrate format:npc "The banking PIN security system currently is not implented it appears actually, sorry. Please try again later."
                Collection:
                    trigger: "/collection|box/"
                    hide trigger message: true
                    script:
                        - flag player interacting_npc:!
                        - narrate format:npc "The Grand Exchange currently is not implented it appears actually, sorry. Please try again later."
                Location:
                    trigger: "/what|where|place/"
                    hide trigger message: true
                    script:
                        - narrate format:npc "this is a branch of the bank of Runescape. We have branches in many towns."
                        - define Options_List "<list[And what do you do?|didn't you used to be called the Bank of Varrock?]>"
                        - define Trigger_List "<list[what|Varrock]>"
                        - zap Inquire
                        - inject Trigger_Option_builder Instantly
                Blacklist:
                    trigger: "/what|do|called|varrock/"
                    hide trigger message: true
                    script:
                        - stop
        Inquire:
            chat trigger:
                Introduction:
                    trigger: "/what|do/"
                    hide trigger message: true
                    script:
                        - narrate format:npc "We will look after your items and money for you. Leave your valuables with us if you want to keep them safe."
                        - wait 3s
                        - inject Banker path:GenericGreeting Instantly
                Location:
                    trigger: "/called|varrock/"
                    hide trigger message: true
                    script:
                        - narrate format:npc "Yes we did, but people kept on coming into our branches outside of Varrock and telling us that our signs were wrong. They acted as if we didn't know what town we were in or something."
                        - wait 4s
                        - inject Banker path:GenericGreeting Instantly
                Blacklist:
                    trigger: "/access|pin|collection|place/"
                    hide trigger message: true
                    script:
                        - stop


# | ███████████████████████████████████████████████████████████
# | ██        Open Bank Task
# % ██        - run open_bank (def:#) instantly
# % ██        - run open_bank_admin [def:#|player] instantly
# | ██
# % ██    [ Player Bank ] ██
Open_Bank:
    type: task
    debug: false
    definitions: BankID
    script:
        - define BankID <[BankID]||1>
        - define pBank <player.uuid>pBank_<[BankID]>
        - define slots1 <[BankID].sub[1].mul[45].add[1]>
        - define slots2 <[BankID].sub[1].mul[45].add[45]>
        - define title "Bank|Items <[slots1]>-<[slots2]>/450"
        - note "in@generic[title=<[title]>;size=54]" as:<[pBank]>
        - define items <yaml[pBankKey].read[<player.uuid>.<[BankID]>]||null>
        - if <[BankID]> > 1:
            - define LeftArrow i@LastPageArrow[nbt=BankID/<[BankID].sub[1]>]
        - else:
            - define LeftArrow i@blank
        - if <[bankID]> == 10:
            - define RightArrow i@blank
        - else:
            - define RightArrow i@NextPageArrow[nbt=BankID/<[BankID].add[1]>]
        - define SoftMenu "li@<[LeftArrow]>|i@Blank|i@Blank|i@Blank|i@Blank|i@Deposit_All|i@equipment_slot|i@Deposit_Equipement|<[RightArrow]>"
        - inventory set d:in@<[pBank]> o:<[SoftMenu]> slot:46
        - if <[items]> != null:
            - inventory set d:in@<[pBank]> o:<[items]>
        - inventory open d:in@<[pBank]>

# | ██    [ Admin Bank ] ██
Open_Bank_Admin:
    type: task
    debug: false
    definitions: BankID|Player
    UserVerification:
    - if <server.match_player[<[Player]>]||null> != "null":
        - define User <server.match_Player[<[Player]>]>
    - else if <server.match_player_offline[<[Player]>]||null> != "null":
        - define User <server.match_Player_offline[<[Player]>]>
    - else:
        - inject locally ErrorObjection instantly
    ErrorObjection:
        - define key "<&4>invalid character<&co><&nl><&c><[Player]||null>"
        - narrate format:bbf "Internal error <&pipe> <&c><proc[msgHover].context[<&c>Invalid Character|<[key]>]>"
        - stop
    script:
    - inject locally UserVerification instantly
    - define BankID <[BankID]||1>
    - define pBank <[User].uuid>pBank_<[BankID]>
    - define slots1 <[BankID].sub[1].mul[45].add[1]>
    - define slots2 <[BankID].sub[1].mul[45].add[45]>
    - define title "Bank<&pipe>Items <[slots1]>-<[slots2]>/450"
    - note "in@generic[title=<[title]>;size=54]" as:<[pBank]>
    - define items <yaml[pBankKey].read[<[User].uuid>.<[BankID]>]||null>
    - if <[BankID]> > 1:
        - define LeftArrow i@LastPageArrow[nbt=li@BankID/<[BankID].sub[1]>|PlayerID/<[Player]>]
    - else:
        - define LeftArrow i@blank
    - if <[bankID]> == 10:
        - define RightArrow i@blank
    - else:
        - define RightArrow i@NextPageArrow[nbt=li@BankID/<[BankID].add[1]>|PlayerID/<[Player]>]
    - define SoftMenu "li@<[LeftArrow]>|i@Blank|i@Blank|i@Blank|i@Blank|i@Blank|i@Deposit_All|i@Deposit_Equipement|<[RightArrow]>"
    - inventory set d:in@<[pBank]> o:<[SoftMenu]> slot:46
    - if <[items]> != null:
        - inventory set d:in@<[pBank]> o:<[items]>
    - inventory open d:in@<[pBank]>

# | ███████████████████████████████████████████████████████████
# % ██        Bank Handlers
# | ██
# % ██    [ Events ] ██
PlayerBank_Handler:
    type: world
    debug: false
    Inventory_Load:
        - if <server.has_file[data/pBank/pBankKey.yml].not>:
            - yaml create "id:pBankKey"
            - yaml "savefile:data/pBank/pBankKey.yml" "id:pBankKey"
        - else:
            - yaml "load:data/pBank/pBankKey.yml" "id:pBankKey"
    Inventory_Save:
        - if <context.inventory.replace[<player.uuid>].starts_with[in@pBank].not||true>:
            - stop
        - define BankID <context.inventory.after[_]>
        - define dvlist <context.inventory.list_contents.get[1].to[45]>
        - yaml set id:pBankKey "<player.uuid>.<[BankID]>:<[dvlist]>"
        - yaml "savefile:data/pBank/pBankKey.yml" "id:pBankKey"
        - define id "<player.uuid>pBank_<[BankID]>"
        - note remove as:<[id]>
    events:
        on server start:
            - inject Locally Inventory_Load
        on reload scripts:
            - inject Locally Inventory_Load
        on player closes inventory:
            - inject Locally Inventory_Save
        on player clicks blank in inventory:
            - determine cancelled
        on player clicks LastPageArrow|NextPageArrow in inventory:
            - determine passively cancelled
            - inject locally Inventory_Save
            - run Open_Bank def:<context.item.nbt[bankid]> Instantly

  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀
LastPageArrow:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 131
    #potion_effects: "INSTANT_HEAL,false,false"
    #flags: "li@HIDE_POTION_EFFECTS|HIDE_ENCHANTS|HIDE_ATTRIBUTES|HIDE_UNBREAKABLE|HIDE_DESTROYS|HIDE_PLACED_ON"
    display name: <&2><&chr[25c0]> <&2>L<&a>ast <&2>P<&a>age <&2><&chr[25c0]>
  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀
NextPageArrow:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 132
      #potion_effects: "INSTANT_HEAL,false,false"
        flags: "li@HIDE_POTION_EFFECTS|HIDE_ENCHANTS|HIDE_ATTRIBUTES|HIDE_UNBREAKABLE|HIDE_DESTROYS|HIDE_PLACED_ON"
    display name: <&a><&chr[27a4]> <&2>N<&a>ext <&2>P<&a>age <&2><&chr[27a4]>
  #display name: <&a><&chr[25b6]> <&2>N<&a>ext <&2>P<&a>age <&2><&chr[25b6]>
  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀
Deposit_All:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 134
        flags: "li@HIDE_POTION_EFFECTS|HIDE_ENCHANTS|HIDE_ATTRIBUTES|HIDE_UNBREAKABLE|HIDE_DESTROYS|HIDE_PLACED_ON"
    display name: <&2>D<&a>eposit <&2>A<&a>ll
Deposit_Equipement:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 133
        flags: "li@HIDE_POTION_EFFECTS|HIDE_ENCHANTS|HIDE_ATTRIBUTES|HIDE_UNBREAKABLE|HIDE_DESTROYS|HIDE_PLACED_ON"
    display name: <&2>D<&a>eposit <&2>A<&a>ll <&2>E<&a>quipment
Blank:
    type: item
    debug: false
    material: black_stained_glass_pane
    display name: " "
Equipment_Slot:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 136
        flags: "li@HIDE_POTION_EFFECTS|HIDE_ENCHANTS|HIDE_ATTRIBUTES|HIDE_UNBREAKABLE|HIDE_DESTROYS|HIDE_PLACED_ON"
    display name: <&2>E<&a>quipment <&2>M<&a>enu



# | ███████████████████████████████████████████████████████████
# % ██    /npc assignment --set Grand Exchange ClerkNPC
# | ██
# % ██  [ Assignment Script ] ██
# $ ██  [ To-Do ] | Pin Settings | Grand Exchange            ██
Grand_Exchange_Clerk:
    type: assignment
    debug: false
    actions:
        on assignment:
            - trigger name:click state:true
            - trigger name:proximity state:true radius:4
            - trigger name:chat state:true
            - if <server.has_flag[npc.skin.<script.name>]>:
                - adjust <npc> skin_blob:<server.flag[npc.skin.<script.name>]>
            - else:
                - narrate "<proc[Colorize].context[No NPC skin saved for:|red]> <&6>'<&e><script.name><&6>'"
        on exit proximity:
            - if <player.flag[interacting_npc]||> == <script.name>:
                - flag player interacting_npc:!
                - if <script[<script.name>_Interact].step[<player>]> != Normal:
                        - zap "Grand Exchange Clerk_Interact" Normal
        on click:
            - if <player.flag[interacting_npc]||> != <script.name>:
                - flag player interacting_npc:<script.name>
            - narrate format:npc "Welcome to the Grand Exchange. Would you like to trade now, or exchange item sets?
            - inject locally GenericGreeting Instantly
    GenericGreeting:
        - wait 2s
        #|How do I use the Grand Exchange?
        #|I'd like to set up trade offers please.
        #|Can you help me with item sets?
        #|I'd like Exchange collection reminders on login, please.
        #|I'm fine, thanks.
        - define Options_List "<list[How do I use the Grand Exchange?|I'd like to set up trade offers please.|Can you help me with item sets?|I'd like Exchange collection reminders on login, please.|I'm fine, thanks.]>"
        - define Trigger_List <list[How|Trade|Sets|Reminder|Bye]>
        - if <script[<script.name>_Interact].step[<player>]> != Normal:
            - zap "Grand Exchange Clerk_Interact" Normal
        - inject Trigger_Option_builder Instantly
    interact scripts:
        - Grand_Exchange_Clerk_Interact

# | ██  [ Grand Exchange Clerk Interact Script ] ██
Grand_Exchange_Clerk_Interact:
    type: interact
    debug: false
    speed: 0
    steps:
        Normal*:
            chat trigger:
                Bank:
                    trigger: hi
                    hide trigger message: true
                    script:
                    - narrate format:npc "hi"
                    - wait 2s
                    - define Options_List "<list[And what do you do?|didn't you used to be called the Bank of Varrock?]>"
                    - define Trigger_List "<list[what|Varrock]>"