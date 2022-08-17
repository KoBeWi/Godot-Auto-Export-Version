# <img src="https://github.com/KoBeWi/Godot-Auto-Export-Version/blob/master/Media/Icon.png" width="64" height="64"> Godot Auto Export Version

Ever wanted to display the current version of your game somewhere? You did, but you don't have idea what to display or you forget to update it every time? This plugin is for you.

Every time you export the project, a special script that contains current version will be updated. Use this script anywhere to display the version. Now your version automatically updates and you don't need to remember to update your scenes.

## How does it work

*Before enabling the plugin*, open `AutoExportVersion.gd` file to configure it. You have several options:
- `STORE_LOCATION` - this constant defines where the version will be stored. By default the version is stored in a special script, but can be also in Project Settings.
- `SCRIPT_PATH` - if you use the script option, this defines where the script will be located.
- `PROJECT_SETTING_NAME` - if you use Project Settings option, the version will be stored under this setting.

The **most important** thing is `get_version()` method. Perfectly, it should return a String from some external source that contains your current version. A few "version providers" are included by default:
- Git version (`get_git_commit_count()`) - If your project is inside git repository, the plugin will fetch the number of commits and use it as current version.
- Git branch version (`get_git_branch_name()`) - If your project is inside git repository, the plugin will fetch the current branch's name.
- Git hash version (`get_git_commit_hash()`) -  If your project is inside git repository, the plugin will fetch the latest commit's hash.
- Profile version (`get_export_preset_version()`) - If you have export presets that contain some version string (e.g. for Android), this will fetch the version from that profile. Normally it's not possible to display this version in the project, hence the plugin is useful.
- Android version (`get_export_preset_android_version_code()`, `get_export_preset_android_version_name()`) - same as above, but specialized for Android. Instead of version field, it uses both version code and version name and you can customize what format is used to display it.

To use any of these providers just uncomment the line starting with `#`. All of them are methods that return a String, so you can combine them to your liking. Or you can write a custom one (also if you have some good idea, you can open an issue and it might be officially included with this plugin; the plugin originally started with only 2 providers).

## How to use the version

Upon first activation and then after each project export, the plugin will update your `version.gd` file. The plugin contains a constant value called VERSION, which is the current version string. Example usage goes like this:
```GDScript
extends Label

func _ready():
  text = "v%s" % load("res://version.gd").VERSION
```
Attach it to any Label and it will display the current version and auto-update after each project export. Now you can forget about it, because it's all automatic.

![](https://github.com/KoBeWi/Godot-Auto-Export-Version/blob/master/Media/ReadmeV3.png)

If you use the Project Settings version location, the code will be instead:
```GDScript
extends Label

func _ready():
  text = "v%s" % ProjectSettings.get_setting("application/config/AutoExport/version")
```

Script/setting path and version script format are configurable. You can refer to the script's built-in documentation for more details about all methods and constants.

If you want to print the current version without exporting the project, you can use the option in Project -> Tools menu called 'Print Current Version'.

Special thanks to [@Kubulambula](https://github.com/Kubulambula) for refactoring the plugin and porting it to Godot 4.0.

___
You can find all my addons on my [profile page](https://github.com/KoBeWi).

<a href='https://ko-fi.com/W7W7AD4W4' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
