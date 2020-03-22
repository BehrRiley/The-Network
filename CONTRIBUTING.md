## General Contribution
Contributing to this project should abide as closely as possible to the guidelines published here.

___
## Ownership & License
Contributions to this project forfeit ownership of material and provide permissions of this strong copyleft license and are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights. You are not allowed to claim patents or copyright on the software. Moreover, you are obligated to display a copyright notice, disclaimer of warranty, intact GPL notices, and a copy of the GPL. You are not allowed to change the license or introduce additional terms and conditions. You are under the reciprocity obligation, which means you are obligated to release the source code and all of the rights to modify and distribute the entire code.
___
## Features

#### Requests should be limited per our only network rule, *common sense*. 

### Features should **avoid** the following:
- Inequality: Give substantial benefits to a single player, or small group of individual players. We aren't providing random benefits to anyone who asks. *unless of course, they're a sponsor*. Privileged players typically receive special treatment. Call it a trip on our magic carpet.
- Over-complicated or game-breaking changes; Examples:
  - Pouring milk like water or lava - this is mechanically too complicated without creating complete modifications to the server that all players would have to own to participate playing
  - Instant-killing attacking enemies - this isn't a realistic request, and would slaughter our less skilled or otherwise expecting players, unless it's something incredibly prepped for, such as a final-boss battle of a sort.
- Uncontrollable growth - Such as, 'the entire Diablo III quest series saga'. This is too in-depth and too expandable for a single request, unless you plan on bringing friends in to make it happen.


### **Good** feature requests should provide as many of these notes as possible:
- **The Type of request**: describe if this a one-off feature or a series of features
- **Who is requesting this**: identify yourself and who you represent, so that you can easily follow up with them as a major contributing producer to the idea.
- **Describe the feature** This is key for you to differentiate between people that have deeply thought about what you're requesting, or what this will solve for users versus those that are just in love with their idea.
- **Describe the impact**: Articulate how solving this problem will make yours and the other player’s life better. You can add impact categories that matter to you to ensure consistency.
- **Describe the reach of this feature**: You could describe how many users will be positively impacted or leverage this feature.
- **Describe the cost of not doing this request**: Describe the problems that would occur if this need was not addressed. To ensure consistency add categories that matter to us such as happier players, or adequate equality of other existing features or mechanics of the game.
- **Describe which goals this helps**: Enumerate our current goals and tie the feature to it - Expansion and dynamistic game-play is key for an awesome player-base and game-play environment.
- **Describe the evidence that you have on the need for this request**: Validation of user problem and desired outcome is statistically(no pun intended) the only way to argue with me if you believe I wouldn't agree else-wise. 
- **Describe if you have any ideas on how we may solve this**: Giving the space to help and suggest ideas are great for creating structural or dynamic features, mini-games and commands.
- **Describe how urgent this is and why**: Explain the space to give insight into the urgency of this issue and why.

___
## Commands
Commands should to the best of ability contain the following features if possible, and maintain a consistent usage syntax and design structure.

### **Script naming, usage & description keys**
- The `/help` command specifically requires command script-names to end in `_Command`
  - ie: `Back_Command` or `TPHere_command`
- The usage key is for command syntax, and should escape `<` and `>` characters.
- The usage key should be as short and simple as possible, following a few guidelines:
    - Arguments should be title-case and not contain spaces.
    - Arguments should never use symbols.
    - Numeric arguments can be left as the `#` symbol unless the command relies on very specific numbers or a range of numbers; `#` is preferred regardless.
    - Ranges are acceptable if short - `(1-10)` is okay, `(1000-50000)` is not. Limit to like, 5 digits/`(##-###)` maximum.
    - Exclude decimals, specify `#` instead.
    - Exclude negative ranges, specify `#` instead.
    - \<Arguments in tag-marks are mandatory and non-literal.\>
    - (Arguments in parentheses are optional.)
        - Optimally, wrap notable arguments in tag-marks as they're mandatory if specifying. Example:
            ```ml 
            /Home (<Home> (Remove))
            /Fly (<Player> (On/Off))
            ```
            * Specifying the name of a home is optional, allowing players to open a GUI if unspecified, and where specifying the `remove` arg if removing the home instead of teleporting to it. 
            * Specifying a player to adjust flight for opposed to adjusting your own, optionally triggering it on or off.

A few additional examples of argument usage:
- `<&lt>Player<&gt>` | Requires a player be specified
- `(Player)` | A player may optionally be specified, where the command may offer default replacements if this isn't specified
- `(Arg1 <&lt>Arg2<&gt>)` | Arg1 is optional, but Arg2 is required if specifying Arg1
- `<&lt>ModeName<&gt> (On/Off)` | Requires `ModeName` be specified, however `On` or `Off` may optionally be specified
- `<&lt>ArgName<&gt> <&gt>0-100<&gt>` the `ArgName` is required as well as any number between `0` and `100`

A perfectly good command template would look closely like this:
```yml
Example_Command:
    type: command
    name: example
    description: Short description of a command.
    usage: /example <&lt>Required<&gt> (Optional)
    permission: behrry.essentials.example
    script:
        #@ Check Args
        - if <ArgConditions>
            - inject Command_Syntax Instantly
```

### **Permissions & Flag Names/Nodes**
Commands should be permission locked, **regardless of being a global command**. Commands with flag modes should be consistently named with the permission name. Some general usage guidelines:
- Flag nodes **Cannot** contain sub-nodes. If any given key acts as the parent key to a child key, then that key cannot have it's value changed, set, deleted or read.
- Flag and permission nodes should be lowercase.
- Permission nodes should primarily be the command name (Never the alias), or appropriately reflect the target group. Examples:
  * behrry.essentials.cmdname
  * behrry.essentials.gmc
  * behrry.essentials.gmc.moderation

### **Tab complete**
Tab completion makes utilizing proper command usage easier for players. See [Command Dependencies](https://github.com/BehrRiley/The-Network/blob/master/Servers/1.15.2%20Production/plugins/Denizen/scripts/Structure/Command%20Dependencies.dsc) to best utilize pre-made tab-completions. An example would be `Online_Player_Tabcomplete`, where injecting this script tab-completes all online players. More advanced tab-completion soon to come.

### **Text, script and prompt formatting**
Visible text in chat should utilize the `Colorize` procedure, or formatted utilizing the colorized format scripts. Avoid large strings, the unique color palette is only good for 1-4 words; 5 is pushing it. Anything longer should be solid colors, or appropriately color coordinated. Examples:
- `- narrate "<proc[Colorize].context[Hello there,|green]> <&e><player.name>"`
- `- narrate format:colorize_red "This was an error."`
Commenting should be standard. Avoid large blocks of comment sections, explanations should be skipped as opposed to describing sections of the scripts.
Improper syntax should solely utilize the `- inject Command_Syntax Instantly`. 
Improper arguments alternatively should briefly describe errors, ie: "home names should be alphanumerical" or "number cannot be a decimal".

**Definition guidelines:**
- Define tags and strings (heavy tags especially) used more than two or three times within a script.
- For scripts that involve other players, define the player as `<[User]>` and utilize `- inject Player_Verification Instantly` to verify the player is online. Optionally, use `Offline_Player_Verification` to verify valid offline players.
- In addition to above, define other players as `<[User]>` for consistency.
- When using `foreach`, always utilize an `as:Name:` for consistency.
  - When `foreach`ing a list, keep the name explicitly simple. For example, `foreach <[Blocks]> as:Block:` should be very straightforward.

Lastly, avoid heavy nested `if`/`if else` for argument checks and verification. Utilize a simple 'if bork, stop' concept, such as:
```ml
- if !<[Arg1].is_integer>:
  - narrate format:colorize_red "X must be a number."
  - stop
```

___
## Organization
Material should be properly organized in reasonable categories. Commands should be primarily implemented into categories, such as **Behrry Essentials**, **BehrEdit**, **Gielinor**, **Moderation**, and **De Protecc**. For each command implemented should reflect a note in the [Projects](https://github.com/BehrRiley/The-Network/projects) section, categorized by either the command category they best fit with, or a general progressively advancing custom project that it's involved in. Each note should be provided an [Issue](https://github.com/BehrRiley/The-Network/issues) to track progress and progressiveness of the project. Labels should specify at least one label. 