#### | ███████████████████████████████████████████████████████████
#### % ██    /
#### | ██
#### % ██  [ Command ] ██
###AddClaim_Command:
###    type: command
###    name: addclaim
###    debug: false
###    description: Claims the selected or named claim.
###    usage: /addclaim (ClaimName)
###    permission: protecc.claim.add
###    script:
###        #@ Check for flag
###        - if !<player.has_flag[protecc.selection.cuboid]>:
###            - narrate format:Colorize_Red "No cuboid found."
###            - stop
###        - define Cuboid <player.flag[protecc.selection.cuboid]>
###
###        #@ Check for name
###        - if <context.args.get[1]||null> != null:
###            - if <player.has_flag[settings.protecc.NamedClaimsPreference]>:
###                - narrate format:Colorize_Red "No name specified. Your current claim settings require a name."
###                - stop
###            - if !<player.has_flag[protecc.claim.VerifyNoName]>:
###                - flag player protecc.claim.VerifyNoName duration:2m
###                - narrate format:Colorize_Yellow "Retype to Verify: Are you sure you don't want a claim name?"
###                - stop
###            #- for after Home rewrite
###                #- define Homes <player.flag[behrry.essentials.homes].parse[after[/]]>
###                #- if <[Cuboid].contains_any[<[Homes]>]>:
###                #    - foreach <[Homes]> as:Home:
###                #        - if <[Home].is_within[<[Cuboid]>]>:
###                #            - if !<player.flag[protecc.claims].parse[before[/]].contains[<[Home]>]||true>:
###                #                - define ClaimName <[Home]>
###                #                - foreach stop
###                #        - else:
###                #            - if <[ClaimName]||null> == null && <[Loop_Index]> == <[Homes].size>:
###                #                - define ClaimCount <player.flag[protecc.claims].size||0>
###                #                - define ClaimName Home<[ClaimCount].add[1]>
###                #- else:
###                #    - define ClaimCount <player.flag[protecc.claims].size||0>
###                #    - define ClaimName Home<[ClaimCount].add[1]>
###            #->  vv and remove these next two for this vv  <-#->
###            - define ClaimCount <player.flag[protecc.claims].size||0>
###            - define ClaimName Home<[ClaimCount].add[1]>
###            #->  ^^                                    ^^  <-#->
###        #@ If arg1 isn't blank
###        - else:
###            - define ClaimName <context.args.get[1]>
###            #@ Check if alphanumerical
###            - if !<[ClaimName].matches[[a-zA-Z0-9-_\&]+]>:
###                - narrate format:Colorize_Red "Claim names should be alphanumerical"
###                - stop
###            #@ Check for length
###            - if <[Nickname].parse_color.strip_color.length> > 16:
###                - narrate format:Colorize_Red "Claim names should be less than 16 charaters"
###                - stop
###                
###        #@ Check for existing claim
###        - if <cuboid[Claims].list_members.contains[<[Cuboid]>]>:
###            - narrate format:Colorize_Red "This claim exists already."
###
###        #@ Check for intersecting claims
###        - if <cuboid[Claims].intersects[<[Cuboid]>]>:
###            - narrate format:Colorize_red "This claim intersects another."
###            - stop
###
###        #@ Narrate info
###        - define CuboidInfo "<proc[CuboidTextFormat].context[<[Cuboid]>]>"
###
###        - define Time <util.date.time.duration>
###        - define Mo <[Time].time.month.pad_left[2].with[0]>
###        - define da <[Time].time.day.pad_left[2].with[0]>
###        - define yy <[Time].time.year.after[20]>
###        - define hh <[Time].time.hour.pad_left[2].with[0]>
###        - define mi <[Time].time.minute.pad_left[2].with[0]>
###        - define ss <[Time].time.second.pad_left[2].with[0]>
###        - define TimeStamp "Time created: <proc[Colorize].context[[<[mo]>/<[da]>/<[yy]>]-[<[hh]>:<[mi]>:<[ss]>]|BlueInverted]>"
###
###        - define Info <list[CuboidInfo|<[TimeStamp]>]>
###        - define Hover "<[ClaimName]><&nl> <&e>Cuboid Info:<&nl><[Info]>"
###        - define Text "<proc[Colorize].context[Claim Created:|green]> <&e><[ClaimName]>"
###        - narrate <proc[HoverMsg].context[<[Hover]>|<[Text]>]>
###
###        #@ Create the Claim
###        #- 1} Cuboid | 2} ClaimName | 3} Time
###        #- 1} Cuboid | 2} Claim Player
###        - flag player protecc.claims:->:<[Cuboid]>/<[ClaimName]>/<[Time]>
###        - flag server protecc.claims:->:<[Cuboid]>/<player>
###        - note <cuboid[Claims].add_member[<[Cuboid]>]> as:Claims
###
###
#### | ███████████████████████████████████████████████████████████
#### % ██    /
#### | ██
#### % ██  [ Command ] ██
###RemoveClaim_Command:
###    type: command
###    name: removeclaim
###    debug: false
###    description: Removes the selected or named claim.
###    usage: /removeclaim (ClaimName)
###    permission: protecc.claim.remove
###    script:
###        #@ Check for name
###        - if <context.args.get[1]||null> != null:
###            - if <player.location.is_within[<cuboid[Claims]>]>:
###                - foreach <cuboid[Claims].list_members> as:Claim:
###                    - if <player.location.is_within[<[Cuboid]>]>:
###                        #- Find the Player - <server.flag[protecc.claims].map_get[<[Claim]>]>
###                        #- Find the Name - <player.flag[protecc.claims].map_get[<server.flag[protecc.claims].map_get[<[Claim]>]>]>
###                        - define 
###                        - define
###                        - foreach stop
###
###        - else:
###            #@ Check for flag
###            - if !<player.has_flag[protecc.selection.cuboid]>:
###                - narrate format:Colorize_Red "No claims saved"
###                - stop
###
###
###
###        - if !<cuboid[Claims].list_members.contains[<[Cuboid]>]>:
###            - narrate format:Colorize_Red "No claim found."
###        - else:
###            - narrate format:Colorize_Green "Removing Claim: {ClaimNameHere}"
###            - flag player protecc.claims:<-:<[Cuboid]>
###            - define Index <cuboid[Claims].list_members.find[<[Cuboid]>]>
###            - note <cuboid[Claims].remove_member[<[Index]>]> as:claims
###
###
#### | ███████████████████████████████████████████████████████████
#### % ██    /
#### | ██
#### % ██  [ Command ] ██
###CheckClaim_Command:
###    type: command
###    name: checkclaim
###    debug: false
###    description: Prints information about a specified claim, or the claim(s) you're in.
###    usage: /checkclaim (ClaimName)
###    permission: protecc.claim.check
###    script:
###        - if <context.args.get[1]||null> != null:
###            - inject Command_Syntax Instantly
###
###
#### | ███████████████████████████████████████████████████████████
#### % ██    /
#### | ██
#### % ██  [ Command ] ██
###ExpandClaim_Command:
###    type: command
###    name: expandclaim
###    debug: false
###    description: Expands specified claim, or the claim(s) you're in in the direction facing, or specified direction.
###    usage: /expandclaim (ClaimName) (Direction)
###    permission: protecc.claim.expand
###    script:
###        - if <context.args.get[1]||null> != null:
###            - inject Command_Syntax Instantly
###
###
#### | ███████████████████████████████████████████████████████████
#### % ██    /
#### | ██
#### % ██  [ Command ] ██
###EditClaim_Command:
###    type: command
###    name: editclaim
###    debug: false
###    description: Edits a specified claim, or the claim you're in.
###    usage: /expandclaim (ClaimName)
###    permission: protecc.claim.expand
###    script:
###        - if <context.args.get[1]||null> != null:
###            - inject Command_Syntax Instantly
###
###
#### | ███████████████████████████████████████████████████████████
#### % ██    /
#### | ██
#### % ██  [ Command ] ██
###ShowClaim_Command:
###    type: command
###    name: showclaim
###    debug: false
###    description: Shows the boundaries of the specified claim, or the claim you're in.
###    usage: /showclaim (ClaimName)
###    permission: protecc.claim.show
###    script:
###        - if <context.args.get[1]||null> == null:
###            - inject ClaimFind_Task Instantly
###        - narrate <[Claim]>
###
###
#### | ███████████████████████████████████████████████████████████
#### % ██    /
#### | ██
#### % ██  [ Command ] ██
###ListClaims_Command:
###    type: command
###    name: editclaim
###    debug: false
###    description: Lists your claims and information.
###    usage: /listclaims
###    adminusage: /listclaims (Player)
###    permission: protecc.claim.list
###    script:
###        - if <context.args.get[1]||null> != null:
###            - inject Command_Syntax Instantly
###        - define Header narrate "<&3>+<&b>-------------------<&a>Claim Info<&b>-------------------<&3>+"
###        - repeat <player.flag[protecc.claims].size.div[8]> as:claim:
###            - define Math1 <[Loop_Index].add[<[Loop_Index].sub[1].mul[7]>]>
###            - define Math2 <[Loop_Index].add[<[Loop_Index].sub[1].mul[8]>].add[7]>
###            - foreach <player.flag[protecc.claims].get[<[Math1]>].to[<[Math2]>]> as:Claim:
###                - narrate "<&e>Claim Name <&b>| <proc[CuboidTextFormat].context[<[Claim]>]>"
###
###        - define DP "<element[].pad_left[6].with[x].replace[x].with[<&2>-<&a>-]>"
###        - define PageDisplay "<&6>[<&e>1<&6>/<&e>1<&6>]"
###        - define Footer "<&a>+ <[DP]> <proc[Colorize].context[Q Previous Z Next Y|Green]> <[DP]> +"
###
###    
#### | ███████████████████████████████████████████████████████████
#### % ██    /
#### | ██
#### % ██  [ Command ] ██
###ClaimSettings_Command:
###    type: command
###    name: claimsettings
###    debug: false
###    description: Shows you your claim
###    usage: /ClaimSettings
###    permission: protecc.settings
###    script:
###        - if <context.args.get[3]||null> != null:
###            - inject ClaimFind_Task Instantly
###        - if <context.args.get[1]||null> == null:
###            - define Arg Help
###        - else:
###            - define Arg <context.args.get[1]>
###        - choose <[Arg]>:
###            - case "Help":
###                - define List <list[Help|NamedClaims]>
###                - foreach <[List]> as:Command:
###                    - define Hover ""
###                    - Define Text ""
###                    - Define Command ""
###                    - narrate <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
###            - case "NamedClaims"
###                - define Arg <context.args.get[2]||null>
###                - define ModeFlag "settings.protecc.NamedClaimsPreference"
###                - define ModeName "Named claims are now"
###                - inject Activation_Arg_Command Instantly
###            - case "MaxHeight"
###                - define Arg <context.args.get[2]||null>
###                - define ModeFlag "settings.protecc.MaxHeight"
###                - define ModeName "Max height mode is now"
###                - inject Activation_Arg_Command Instantly
###
###ClaimHelp_Command:
###    type: command
###    name: claimhelp
###    debug: false
###    description: Shows you your claim
###    usage: /ClaimHelp
###    permission: protecc.help
###    script:
###        - foreach <server.list_commands.filter[ends_with[_Command]].filter[contains[Claim]]>

ClaimFind_Task:
    type: task
    debug: true
    script:
        - if <player.location.is_within[Claims]>:
            - foreach <cuboid[Claims].list_members> as:Cuboid:
                - if <player.location.is_within[<[Cuboid]>]>:
                    - define Claims:->:<[Cuboid]>
        - else:
            - narrate format:Colorize_Red "No claims found."
            - stop
        
        - narrate <[Claim]>
