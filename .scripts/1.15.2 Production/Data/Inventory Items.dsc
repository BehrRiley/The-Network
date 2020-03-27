# | ███████████████████████████████████████████████████████████
# % ██        All Inventories
# | ██
Blank:
    type: item
    debug: false
    material: black_stained_glass_pane
    display name: "<&f>"
  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀
LastPageArrow:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 131
    #potion_effects: "INSTANT_HEAL,false,false"
    #flags: hide_all
    display name: <&2><&chr[25c0]> <&2>L<&a>ast <&2>P<&a>age <&2><&chr[25c0]>
  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀
NextPageArrow:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 132
      #potion_effects: "INSTANT_HEAL,false,false"
        flags: hide_all
    display name: <&a><&chr[27a4]> <&2>N<&a>ext <&2>P<&a>age <&2><&chr[27a4]>
  #display name: <&a><&chr[25b6]> <&2>N<&a>ext <&2>P<&a>age <&2><&chr[25b6]>
  #<&a>◀ <&2>L<&a>ast <&2>P<&a>age <&2>◀

# | ███████████████████████████████████████████████████████████
# % ██        Bank Inventories
# | ██
Deposit_All:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 134
        flags: hide_all
    display name: <&2>D<&a>eposit <&2>A<&a>ll
Deposit_Equipement:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 133
        flags: hide_all
    display name: <&2>D<&a>eposit <&2>A<&a>ll <&2>E<&a>quipment
Equipment_Slot:
    type: item
    debug: false
    material: music_disc_11
    mechanisms:
        custom_model_data: 136
        flags: hide_all
    display name: <&2>E<&a>quipment <&2>M<&a>enu

# | ███████████████████████████████████████████████████████████
# % ██        Trade Inventories
# | ██
Accept_Button:
    type: item
    debug: false
    material: lime_stained_glass_pane
    mechanisms:
        flags: hide_all
    display name: <&2>A<&a>ccept <&2>T<&a>rade
Decline_Button:
    type: item
    debug: false
    material: red_stained_glass_pane
    mechanisms:
        flags: hide_all
    display name: <&4>D<&c>ecline <&4>T<&c>rade
Confirm_Blank0:
    type: item
    debug: false
    material: orange_stained_glass_pane
    display name: "<&f>"
Confirm_Blank1:
    type: item
    debug: false
    material: green_stained_glass_pane
    display name: "<&f>"