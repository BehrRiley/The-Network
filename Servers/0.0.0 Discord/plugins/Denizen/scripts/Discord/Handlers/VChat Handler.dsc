VChat Handler:
  type: yaml data
#  debug: true
#  events:
#    on discord message received:
#      #@ Check if ran from LogBot
#      - if <context.author.id||null> != 85614143951892480:
#        - stop
#        
#      #@ Check if joining a voice channel
#      - if "<context.message.contains[ joined voice channel]>":
#        - define RawUser "<context.message.before[ joined voice channel]>"
#        - define Action Joined
#      
#      #@ Check if leaving a voice channel
#      - else if "<context.message.contains[ left voice channel]>":
#        - define RawUser "<context.message.before[ left voice channel]>"
#        - define Action Left
#      - else:
#        - stop
#    
#      - define User <discordgroup@tag_parser,315163488085475337.member[<[RawUser]>]>
#
#      #@ Check if player has a playertag attached
#      - define Player <server.flag[1]>
#