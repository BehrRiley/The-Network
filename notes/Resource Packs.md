It's a commonly asked question in the Denizen discord, so I've decided to throw a guide together on creating a custom resource pack and implementing it into Denizen. There's plenty of guides referencing 'how to make a resource pack', less commonly 'how to implement custom model data into my resource pack', but this guide specifically will walk you through:
- How to create one (for `1.15.X`)
- what your files should look like inside
- How to give yourself Custom Items in-game using commands and scripts
- How to play your custom sounds in-game using commands and scripts

## Syntax References
#### JSON
Most of the data managed within Resource Packs utilize JSON syntax. JSON is a subset of the JavaScript syntax, in which data is in name/value pairs and are separated by commas, wrapped in `"`double-quotes`"`. Objects are held within `{`Braces`}`, and Arrays are held within `[`Square Brackets`]`.<br>
In JSON, Values must be a `string`, a `number`, an `object`, an `array`, a `boolean` or `null`.

For your resource packs, the file type for JSON files is `.json`.<br>
For web related content if you use pieces of your resource pack for `Webizen`[^1], the MIME type for JSON text is "`application/json`".<br>
We'll discuss how data should be formatted in each file in their respective category below.

#### Denizen
Denizen Syntax and Usage should be referrenced from the Meta or the guide, both can be found here[^2]:<br>
| https://one.denizenscript.com/denizen/lngs/<br>
| https://guide.denizenscript.com/

# Directories
## Inside The Root: 
### Directory: "`.minecraft\resourcepacks\MyResourcePack\`"
The main directory within your resource pack folder should contain both:
1) `Assets` Folder - This is where all your files are placed.
2) `pack.mcmeta' - This is how Minecraft knows what format your Resource Pack is.

Optimally, you can also include:
* `pack.png` - This is a `64x64` custom image for your pack!

### File: `"pack.mcmeta"`
Inside, you'll find this is formatted in a json format. You need two named strings: `pack_format` and `description`. <br>
Here's what it looks like inside: 
```json
{
   "pack": {
      "pack_format": 5,
      "description": "My Fancy Resource Pack"
   }
}
```

### Pack key: "`pack_format`"
This is the indicator to Minecraft what version this pack is.<br>
`1` indicates versions `1.6` - `1.8`.<br>
`2` indicates versions `1.9` - `1.10`,<br>
`3` indicates versions `1.11` - `1.12`,<br>
`4` indicates versions `1.13` - `1.14`,<br>
`5` indicates version `1.15`.

Note: In pack format 3 and higher (`1.11` and higher) all of the file names in the resource pack must strictly be lowercase)

### Pack key: "`description`"
This can be blank, or you can optimally fill this with something fancy. Unicode characters must be written pre-escaped, like this: `\uCODE`; two examples being: `\u2588` for `█`, and `\u00A7` for `§`, the section sign symbol which parses valid color tags[^3] you use to parse colors in minecraft chat. If you want red text, your text would look something like `\u00A74Dark Red!`.<br>
Note: Color before formatting; Formatting codes persist after a color code, Not vise-versa!

you can find a special characters in your Character Map if you're on a Windows operating system. `Start` > `Windows Accessories`. You can also google search for unicode characters.

___
## Inside the ASSETS folder:
### Directory: "`.minecraft\resourcepacks\MyResourcePack\assets\`"
this directory should be empty except for the one folder directory: `minecraft`<br>
toss it in, and leave everything else out of here.

___
## Inside the MINECRAFT folder: 
### Directory: "`.minecraft\resourcepacks\MyResourcePack\assets\minecraft\`"
Depending on what content you plan on changing, you need to opt to creating these folders:
1) blockstates - This is where each block-state of items are saved.
2) models - This is where the model data and files are saved 
3) textures - This is where the texture image files are saved
4) fonts - This is where your font data is saved
5) sounds - This is where your sounds are saved
6) optifine - This is where your optifine data is saved. This guide doesn't cover this.

If you opted to create custom sounds, you also must create a json file: `sounds.json`. If you are changing existing sounds, this is not required. <br>
Note: Where some sounds play multiple different sounds, if you are adding to this list, you fall under the "creating custom sounds" category, not "changing existing sounds" and need the specified `sounds.json` file.

### File: "`sounds.json`"
This file indexes where Minecraft should look for your sounds. Below is an example of a setup for two custom sounds, `defence_levelup0` and `defence_levelup1`.
```json
{
  "entity.player.defence.level": {
    "sounds": [
      {
        "name": "custom/defence_levelup0"
      },
      {
        "name": "custom/defence_levelup1"
      }
    ],
    "subtitle": "Excited Trumpet Noises"
  }
}
```
The first key is the name for the command; in this example, `entity.player.defence.level`<br>
The only data object within the command we need to specify are `sounds`. Optionally, you can specify the subtitle that displays if subtitles are enabled in-game. If you place multiple sounds within the `"sounds":[]` array, the sound will randomize between them based on their weight.<br>
For each file, you will need the data: `"name":"FILEPATH/FILENAME"`, excluding the file's extension.<br>
Optionally, you can manually adjust the following valid properties of the sound:
1) volume - The volume the sound will be played as. 
    - Default is `1.0`; Valid volume ranges from `0.0` to `1.0`; where `1.0` is the loudest it may be played at.
    - The Volume value accepts higher values using Denizen's PlaySound, however not by increasing the volume. It increases the audible distance the sound may be heard from. Ie; volume 5 can be heard from five chunks away.
2) pitch - The pitch the sound plays at, altered from it's original `.ogg` form.
    - Default is `1.0`; Valid pitches range from `0.0` to `2.0`; where `0.0` is high-pitched and `1.0` will be low-pitched.
3) weight - The chance that this sopund will be selected as opposed to randomly.
    - Default is 0; Only accepts valid integers, not adjustable within Denizen.
4) stream - Determines if the sound should be streamed from it's file.
    - Default is false
    - Recommended to set this value as `true` if the sound is longer than two seconds to avoid lag.
    - Use this sparingly; it's not optimal to specify everything true.
    - This is used with all music disks.
5) preload - Determines if the sound should be loaded when loading the pack, as opposed to when the player plays the sound. 
    - Default is false
    - Used for ambient noises.
6) attenuation_distance - Determines the reduction rate based on distance.
    - Default is `1.0`
    - Used by portals, beacons, conduits
7) type - determines if an pre-defined event fires this sound.
    - Default is `sound`
    - used for things like being under-water, in a cave, near a beacon, near a beehive.

___
## Inside the BLOCKSTATES folder: 
### Directory: "`.minecraft\resourcepacks\MyResourcePack\assets\minecraft\blockstates\`"
To modify each individual block-state of an item, you must specify each individual blockstate. <br>
Additional blockstates cannot be specified. When specifying blockstate models, the relative folder directs to the `Models` directory, located at `\assets\minecraft\models\`<br>
Adjusting these are not traditional, therefor not covered further in this guide.

___
## Inside the MODELS folder: 
### Directory: "`.minecraft\resourcepacks\MyResourcePack\assets\minecraft\models\`"
To "Create" new items, you'll need to modify existing items within Minecraft. This can be done with Durability, but optimally done with `custom_model_data`. 

### File: "`wooden_sword.json`"
Existing files, `wooden_sword` in this example, should look like this:
```json
{
    "parent": "item/handheld",
    "textures": {
        "layer0": "item/wooden_sword"
    }
}
```
The above example is `wooden_sword.json`, which is located at `
The `parent` key indicates the model data this file injects data for. The data's value for parent specified are the `FILEPATH/FILENAME` from the `MODELS` directory if specifying a model file, and the `textures` directory if specifying a texture. 

In the above example, the `wooden_sword` utilizes the parent model located at: `\assets\minecraft\textures\item\handheld.json`<br>
In the above example, the `wooden_sword` utilizes the texture image located at: `\assets\minecraft\textures\item\wooden_sword.png`

Note that removing `parent` keys if you aren't specifying all display properties of an item will return unexpected results. The `wooden_sword`, for example, utilizes the parent file `\assets\minecraft\textures\item\generated.json`; which also utilizes a parent file at `\assets\minecraft\textures\builtin\generated.json`. If these files do not exist altered in the pack, they utilize the respective existing file within Minecraft's default resource.
To add the `custom_model_data` predicate, we specify this in the `Overrides` key.<br>
Here's an example of the override, and the `custom_model_data` specified.
```json
{
    "parent": "item/handheld",
    "textures": {
        "layer0": "item/wooden_sword"
    },
    "overrides": [
        { "predicate": { "custom_model_data": 1}, "model": "item/custom/bandos_godsword" }
    ]
}
```
Note: remember that objects and arrays are separated by commas<br>
The above example extends the item `wooden_sword` to have an additional item model when the item in-game has the mechanism applied. This file is located at: `\assets\minecraft\models\item\custom\bandos_godsword.json`. Valid `custom_model_data` entries are integers, up to larger integers available as opposed to the durability predicate. An example of this file with multiple custom model data's specified looks like this:

```json
{
    "parent": "item/handheld",
    "textures": {
        "layer0": "item/wooden_sword"
    },
    "overrides": [
        { "predicate": { "custom_model_data": 1}, "model": "item/custom/bandos_godsword" },
        { "predicate": { "custom_model_data": 2}, "model": "item/custom/zamorakian_godsword" },
        { "predicate": { "custom_model_data": 3}, "model": "item/custom/saradomin_godsword" },
        { "predicate": { "custom_model_data": 4}, "model": "item/custom/armadyl_godsword" }
    ]
}
```

### File: "`custom_item.json`"
Your custom item's model data file is something you may or may not adjust yourself. There's plenty of options for modeling software available, two of which I personally recommend are Cubik Pro and BlockBench[^4]. Note that they must be able to export the model to a `.json` file format. Cubik Pro specifically saves the model, and the respective image file, into it's correct locations and formats the model file correctly. When you place your custom item's model data into the location you direct it to in the above example, the top of your model file should look something like this:<br>
```json
{
	"textures": {
		"particle": "item/custom/handheld/bandos_godsword",
		"texture": "item/custom/handheld/bandos_godsword"
	},
```
where the `particle` and `texture` keys both point to the image files we'll be saving at the directory: `\assets\minecraft\models\item\custom\bandos_godsword.png`
___
## Inside the TEXTURES folder: 
### Directory: "`.minecraft\resourcepacks\MyResourcePack\assets\minecraft\textures\`"
This is where your image files are saved. These files should be in the relative filepath specified within the model file that it corresponds to.

___
### Inside the SOUNDS folder: `.minecraft\resourcepacks\MyResourcePack\assets\minecraft\sounds\`
The sound format Minecraft uses is `.ogg`. Free converting tools can be found online[^5]. For organization's sake, if you're adding new sounds, I recommend placing them in a folder named `Custom`. Minecraft's default resource organizes it's sounds by category[^6]. You can find Minecraft's default resource sound index here: `\.minecraft\assets\indexes\1.15.json`; where `1.15` is the version we're using in this guide.<br>
All of your sound files (`.ogg` files) should be saved in this directory.

___
## Implementing into the game with Denizen
### Custom Items
Giving yourself the item is simple. If it's a one-off time you need the thing or you're just generally testing, you can use the `/ex` command[^7] like this:<br>
`/ex give wooden_sword[custom_model_data=1]`

The item script simply looks something like this:
```yml
BandosSword:
    type: item
    material: wooden_sword
    mechanisms:
        custom_model_data: 1
```
The `custom_model_data` is in-line with any other mechanisms you choose to specify with the custom item. You can give yourself the custom item just like any other item script, `/ex give BandosSword` or in any script with the `give` or `inventory` command.

### Custom Sounds
Playing your sound is relative to the unique custom name you gave it. In our example, we specified the name of the sound as `entity.player.defence.level`. You can play this sound with the `playsound` command like this: `/ex playsound <player> entity.player.defence.level custom`<br>
In a script, this would look something like this:<br>
```yml
MyCustomSound:
    type: task
    script:
        - playsound <player> sound:entity.player.defence.level custom
```
___
## Tips, Tricks and & Notes while you Create
A very handy trial-and-error debugging tricks for creating resource packs is that you can actively edit the pack and view your changes in-game. One of the most common misconceptions of resource packs is that you need to have it saved as a `.ZIP`. FALSE! You can save this directly in your resource packs folder, edit and just reload!<br>
The default hotkey to reload your resource packs is `F3 + T`

If you run across a flat purple and black square texture, this is the default Minecraft missing data replacement. 
- if your item is flat with the purple/black texture, your item's model file path is misconfigured or is missing.
- If your item has shape but no texture, your model file's image path is misconfigured or you're missing the image file.
- if your item is normal, your resource pack is not registering any changes made to the item.

Custom textures, models and sounds can be placed within as many sub-folders as you would like. Remember to abide the lowercase sensitivity.

Your default Resource Packs folder is located in your default minecraft directory, and looks something like this:<br>
`C:\Users\Bear\AppData\Roaming\.minecraft\resourcepacks` <br>
Optimally, you can directly open the folder directory with the `Open Resource Pack Folder` button in the `Resource Packs...` section of your in-game menu.

The best template for modifying existing models and textures for Minecraft is the default resource, which can be found in your Version Jar directly located in the directory: `\.minecraft\versions\`. You can extract this to it's respective file, and locate the `Assets` folder within. Note that if you copy the entire `assets` folder as a template, you may consider removing material you don't change, as it's extra file storage you don't need to contribute to the resource pack.

___
#### Source Links
[^1]: https://ci.citizensnpcs.co/job/Webizen/ - For running a web server hosted off your server<br>
      https://docs.google.com/document/d/11E1asJ92cpsTG1I8nUvFnfgv_duVgul8U1f2_59PBlA - Documentation on usage  for Webizen<br>
[^2]: https://one.denizenscript.com/denizen/lngs/ - Denizen Language Meta<br>
      https://guide.denizenscript.com/ - Denizen Beginner's Guide<br>
[^3]: https://minecraft.gamepedia.com/Formatting_codes - Formatting codes for minecraft<br>
[^4]: https://blockbench.net/ - Free modeling software for creating custom item models<br>
      https://cubik.studio/ - Advanced modeling software for creating custom item models<br>
[^5]: https://audio.online-convert.com/convert-to-ogg - Converts sounds to ogg for usage in minecraft.<br>
[^6]: https://hub.spigotmc.org/javadocs/bukkit/org/bukkit/SoundCategory.html - Valid Sound Categories<br>
[^7]: https://guide.denizenscript.com/guides/first-steps/ex-command.html - Guide on the `/ex` command<br>