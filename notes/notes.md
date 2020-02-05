## Project Ideas
### Procedurally Generating Dungeons

#### **Floors**
50 floors; the higher the floor, the greater the experience upon completion and the higher level of the enemies and the overall difficulty. To access the given floor, all players  must have a level twice as high as the floor number, minus one.

| Floor #  | Level Rq | Floor Req |
| -------- |:--------:|:---------:|
| Floor 1  | 1        | -         |
| Floor 10 | 19       | 9         |
| Floor 30 | 59       | 29        |
| Floor 50 | 99       | 49        |

#### **Complexity**
Complexity is a 6-tier scale that determines how many skills will be involved with the dungeon—the higher the complexity, the more skills accessible. There is a penalty on Dungeoneering experience that diminishes as the complexity is set higher, until it vanishes entirely at complexity 6. 
All skills are incorporated with complexities 5 and 6, and all free-to-play skills are available with 3 and below. 
It is recommended to do small floors on complexity 1 and medium and large floors on complexity 6
#### **Prestige**
Prestige is a crucial element to gaining maximum experience per dungeon. Once all possible floors have been completed (all floors with tick marks) since the player's last reset, the Prestige should be reset to ensure maximum experience gain. 
#### **Guide mode**
Guide mode is an option accessible in the party interface. Enabling it highlights rooms on the dungeon map that are essential for dungeon completion (that is, rooms that are not bonus). However, completing a dungeon with guide mode reduces experience awarded on completion by 5%. Guide mode is always active in complexities 1 to 4. 
#### **Party size difficulty**
Every dungeon is designed for a specific number of players, ranging from 1 to 5. This number affects drops, the combat levels of the monsters, the players required for puzzles, and even characteristics of the boss. The number of players the dungeon is built for can be set manually when beginning a floor. It is not possible to set the number higher than the amount of party members. 
More experience is awarded with a larger party size, although soloing and 2 person are viable options, even if not as efficient. 
It is worth noting that if players leave the dungeon, puzzles requiring the full amount of players can no longer be completed. This can be avoided by setting the dungeon to generate for one less player (for example, setting it to 4 in a 5-man party), but this reduces the Dungeoneering experience earned. The decision is up to the party host.
#### **Dungeon size**
Dungeons are generated in small (4x4 grid), medium (4x8 grid), or large (8x8 grid) sizes. A dungeon may contain up to the maximum number of rooms possible from that grid, but generally the room count is smaller due to blank areas on the map. 

The maximum number of rooms per size is: 
* Small: up to 16 rooms
* Medium: up to 32 rooms
* Large: up to 64 rooms
Dungeon size, coupled with party size and floor depth, are the major factors in experience rewarded upon completion. 

#### **Boss selection**
If the easy Daemonheim achievements have been completed and any version of the Daemonheim aura is owned, then the player can choose once per day to face a specific boss. Though the boss chosen must be a valid choice for that specific floor, this freedom can still allow the player to face a slightly easier or faster boss. 
#### **Concept Arts**

##### Generate Main Layout:

![Dungeoneering1](https://cdn.discordapp.com/attachments/547552615450411011/556603700836302863/entry004-map.png)

##### Convert to Tree layout for easier recursion 

![Dungeoneering2](https://cdn.discordapp.com/attachments/547552615450411011/556603770721533962/entry004-tree.png)

##### Generate place keys blocking off final or exteeding rooms

![Dungeoneering3](https://cdn.discordapp.com/attachments/547552615450411011/556603821346783232/entry004-tree2.png)

##### Recursively place keys blocking off further rooms

![Dungeoneering4](https://cdn.discordapp.com/attachments/547552615450411011/556603887176515609/entry004-tree3.png)

##### Generate room based on final recursion

![Dungeoneering5](https://cdn.discordapp.com/attachments/547552615450411011/556603905018953748/entry004-map2.png)

`Concept arts by Sean Howard`


##### To-Do:

Config: change debug.show loading info (defaults to false)