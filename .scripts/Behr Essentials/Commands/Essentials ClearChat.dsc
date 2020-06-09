clearchat_Command:
    type: command
    name: clearchat
    debug: false
    description: Clears your chat, like pressing (F3+D)
    usage: /clearchat or F3+D
    permission: Behr.Essentials.Clearchat
    script:
        - narrate <element[].repeat[100].with[<&nl>]>
