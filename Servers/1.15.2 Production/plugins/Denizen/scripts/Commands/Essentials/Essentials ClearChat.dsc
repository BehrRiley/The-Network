clearchat_Command:
    type: command
    name: clearchat
    debug: false
    description: Clears your chat, like pressing (F3+D)
    usage: /clearchat or F3+D
    permission: behrry.essentials.clearchat
    script:
        - narrate "<element[].pad_left[100].with[<&nl>]>"