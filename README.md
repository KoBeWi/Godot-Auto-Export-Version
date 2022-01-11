# <img src="https://github.com/KoBeWi/Godot-Auto-Export-Version/blob/master/Media/Icon.png" width="64" height="64"> Godot Auto Export Version

Ever wanted to display the current version of your game somewhere? You did, but you don't have idea what to display or you forget to update it every time? This plugin is for you.

Every time you export the project, a special script that contains current version will be updated. Use this script anywhere to display the version. Now your version automatically updates and you don't need to remember to update your scenes.

## How does it work

Before enabling the plugin, open `AutoExportVersion.gd` file to configure it. Change the `VERSION_SCRIPT_PATH` to your liking. This file will be used later in your scenes.

Another important thing is `_fetch_version()` method. Perfectly, it should return a String from some external source that contains your current version. 2 "version providers" are included by default:
- Git version. If your project is inside git repository, the plugin will fetch the number of commits and use it as current version.
- Export presets. If you have export presets that contain some version string (e.g. for Android), this will fetch the version from that profile. Normally it's not possible to display this version in the project, hence the plugin is useful.

To use any of these providers, just uncomment the lines starting with `#`. Or you can write a custom one (also if you have some good idea, you can open an issue and it might be officially included with this plugin).

## How to use the version

Upon first activation and then after each project export, the plugin will update your `version.gd` file. The plugin contains a constant value called VERSION, which is the current version string. Example usage goes like this:
```GDScript
extends Label

func _ready():
  text = "v%s" % load("res://version.gd").VERSION
```
Attach it to any Label and it will display the current version and auto-update after each project export. Now you can forget about it, because it's all automatic.

![](https://github.com/KoBeWi/Godot-Auto-Export-Version/blob/master/Media/ReadmeV3.png)
