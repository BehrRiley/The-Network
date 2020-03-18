Discord_Handler:
  type: world
  Usage: /ex <&lt>Server<&gt> <&lt>Command<&gt>
  Description: Executes commands as the specified server.
  events:
    on discord message received:
      - ~run Execute_Command
      - ~run Online_Command
      - ~run Help_Command
