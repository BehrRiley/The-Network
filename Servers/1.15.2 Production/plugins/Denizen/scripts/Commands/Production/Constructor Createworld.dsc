Createworld_Command:
    type: command
    name: createworld
    debug: false
    description: Creates a world.
    usage: /createworld
    permission: Behrry.Constructor.Createworld
    script:
        - narrate hi
    Create or Destroy:
        - if <context.args.size.is_empty>:
            - inject Command_Syntax Instnatly
        
        - if !<context.args.size> < 2:
            - narrate "Must specify a name."
            - inject Command_Syntax Instantly
        
        - if <context.args.get[1]> == Create:
            - if <server.list_worlds.contains[<context.args.get[2]>]>:
                - narrate "World already exists."
                - stop
            - createworld <context.args.get[2]>

        - else if <context.args.get[1]> == Destroy:
            - if !<server.list_worlds.contains[<context.args.get[2]>]>:
                - narrate "World does not exist."
                - stop
            
            - if !<player.has_flag[Behrry.Constructor.WorldDeletePrompt]>:
                - flag player Behrry.Constructor.WorldDeletePrompt duration:1m
                - narrate "Delete world?: <context.args.get[2]>"
                - stop
            - adjust <world[<context.args.get[2]>]> destroy

        - else:
            - inject Command_Syntax Instantly
    Create or Destroy or Load or Unload:
        - if <context.args.size.is_empty>:
            - inject Command_Syntax Instnatly

        - if !<context.args.size> < 2:
            - narrate "Must specify a name."
            - inject Command_Syntax Instantly

        - choose <context.args.get[1]>:
            - case Create:
                - narrate "Check if the world exists already, either in the worlds or if we're over-writing"

            - case Destroy:
                - narrate "Check if the world is a valid world"

            - case Load:
                - narrate "Check if the world is already loaded"
                - narrate "Check if the world file exists to load"
                - narrate "Opt to create non-existant world if not valid"

            - case Unload:
                - narrate "Check if the world is loaded already"