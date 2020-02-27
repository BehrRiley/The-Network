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


#ListClaims_Command:
#    type: command
#    name: editclaim
#    debug: false
#    description: Lists your claims and information.
#    usage: /listclaims
#    permission: protecc.claim.list
#    script:
#        - if <context.args.get[1]||null> != null:
#            - inject Command_Syntax Instantly
#        - define Header narrate "<&3>+<&b>-------------------<&a>Claim Info<&b>-------------------<&3>+"
#        - repeat <player.flag[protecc.claims].size.div[8]> as:claim:
#            - define Math1 <[Loop_Index].add[<[Loop_Index].sub[1].mul[7]>]>
#            - define Math2 <[Loop_Index].add[<[Loop_Index].sub[1].mul[8]>].add[7]>
#            - foreach <player.flag[protecc.claims].get[<[Math1]>].to[<[Math2]>]> as:Claim:
#                - narrate "<&e>Claim Name <&b>| <proc[CuboidTextFormat].context[<[Claim]>]>"
#
#        - define DP "<element[].pad_left[6].with[x].replace[x].with[<&2>-<&a>-]>"
#        - define PageDisplay "<&6>[<&e>1<&6>/<&e>1<&6>]"
#        - define Footer "<&a>+ <[DP]> <proc[Colorize].context[Q Previous Z Next Y|Green]> <[DP]> +"