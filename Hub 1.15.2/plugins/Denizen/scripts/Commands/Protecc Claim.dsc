# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
AddClaim_Command:
    type: command
    name: addclaim
    debug: false
    description: Claims the selected or named claim.
    usage: /addclaim
    permission: protecc.claim.add
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - choose <context.args.get[1]>:
            - case add:
                - if <cuboid[Claims].list_members.contains[<[Cuboid]>]>:
                    - narrate format:Colorize_Red "This claim exists already."
                - else:
                    - if <cuboid[Claims].intersects[<[Cuboid]>]>:
                        - narrate format:Colorize_red "This claim intersects another."
                        - stop
                    - narrate format:Colorize_Green "{ClaimNameHere} Claim Created."
                        #- define Hover <[ClaimName]><&nl> <&e>Cuboid Info:<&nl><proc[CuboidTextFormat].context[<[Cuboid]>]>
                    - flag player protecc.claims:->:<[Cuboid]>
                    - note <cuboid[Claims].add_member[<[Cuboid]>]> as:Claims
            - case remove:
                - if !<cuboid[Claims].list_members.contains[<[Cuboid]>]>:
                    - narrate format:Colorize_Red "No claim found."
                - else:
                    - narrate format:Colorize_Green "Removing Claim: {ClaimNameHere}"
                    - flag player protecc.claims:<-:<[Cuboid]>
                    - define Index <cuboid[Claims].list_members.find[<[Cuboid]>]>
                    - note <cuboid[Claims].remove_member[<[Index]>]> as:claims
            - case narrate:
                - choose <context.args.get[2]>:
                    - case Members_Size:
                        - narrate "<&a><&lt>cuboid[Claims].members_size<&gt><&b>:<&nl> <&e><cuboid[Claims].members_size>"
                    - case List_Members:
                        - narrate "<&a><&lt>cuboid[Claims].List_Members<&gt><&b>:<&nl> <&e><cuboid[Claims].List_Members>"
                    - case PlayerClaimFlag:
                        - narrate "<&a><&lt>player.flag[protecc.claims]<&gt><&b>:<&nl> <&e><player.flag[protecc.claims].separated_by[<&nl>]>"


# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
RemoveClaim_Command:
    type: command
    name: removeclaim
    debug: false
    description: Removes the selected or named claim.
    usage: /removeclaim
    permission: protecc.claim.remove
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly


# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
CheckClaim_Command:
    type: command
    name: checkclaim
    debug: false
    description: Prints information about a specified claim, or the claim(s) you're in.
    usage: /checkclaim (ClaimName)
    permission: protecc.claim.check
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly


# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
ExpandClaim_Command:
    type: command
    name: expandclaim
    debug: false
    description: Expands specified claim, or the claim(s) you're in in the direction facing, or specified direction.
    usage: /expandclaim (ClaimName) (Direction)
    permission: protecc.claim.expand
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly


# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
EditClaim_Command:
    type: command
    name: editclaim
    debug: false
    description: Edits a specified claim, or the claim you're in.
    usage: /expandclaim (ClaimName)
    permission: protecc.claim.expand
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly


# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
ShowClaim_Command:
    type: command
    name: showclaim
    debug: false
    description: Shows the boundaries of the specified claim, or the claim you're in.
    usage: /showclaim (ClaimName)
    permission: protecc.claim.exp
    
# | ███████████████████████████████████████████████████████████
# % ██    /
# | ██
# % ██  [ Command ] ██
ListClaims_Command:
    type: command
    name: editclaim
    debug: false
    description: Lists your claims and information.
    usage: /listclaims
    adminusage: /listclaims (Player)
    permission: protecc.claim.list
    script:
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        - define Header narrate "<&3>+<&b>-------------------<&a>Claim Info<&b>-------------------<&3>+"
        - repeat <player.flag[protecc.claims].size.div[8]> as:claim:
            - define Math1 <[Loop_Index].add[<[Loop_Index].sub[1].mul[7]>]>
            - define Math2 <[Loop_Index].add[<[Loop_Index].sub[1].mul[8]>].add[7]>
            - foreach <player.flag[protecc.claims].get[<[Math1]>].to[<[Math2]>]> as:Claim:
                - narrate "<&e>Claim Name <&b>| <proc[CuboidTextFormat].context[<[Claim]>]>"

        - define DP "<element[].pad_left[6].with[x].replace[x].with[<&2>-<&a>-]>"
        - define PageDisplay "<&6>[<&e>1<&6>/<&e>1<&6>]"
        - define Footer "<&a>+ <[DP]> <proc[Colorize].context[Q Previous Z Next Y|Green]> <[DP]> +"
