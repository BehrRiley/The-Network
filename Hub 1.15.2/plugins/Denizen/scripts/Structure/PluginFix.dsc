Uperms_Fix:
    type: world
    debug: false
    events:
        on console output:
            - if "<context.message.contains[#playerInGroup null]>":
                - determine cancelled