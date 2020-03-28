Cat_Handler:
    type: world
    debug: false
    events:
        on player clicks with Cat_Box:
            - determine cancelled

Cat_Box:
    type: item
    debug: false
    material: spawner
    display name: "<&5>C<&d>at <&5>B<&d>ox"
    mechanisms:
        flags: hide_all

