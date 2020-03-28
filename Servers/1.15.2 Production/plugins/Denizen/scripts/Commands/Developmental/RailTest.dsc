testingevent:
    type: world
    debug: false
    events:
        on player enters minecart:
            - define Vehicle <context.vehicle>
            - adjust <[Vehicle]> speed:0.5
