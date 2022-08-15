@tool
extends EditorPlugin

## Path to the version script file (bruh).
const VERSION_SCRIPT_PATH: String = "res://version.gd"

## Change the code of this method to return a String that will identify your version.
## Two example ways of doing so are provided, just uncomment one of them.
## You can use the arguments to customize your version based on selected platform or something.
func _fetch_version(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> String:
	### Git version ### ---------------------------------------------------------------------------
	
	# Version is number of commits. Requires git installed
	# and project inside git repository with at least 1 commit.
	
#	var output := []
#	OS.execute("git", PackedStringArray(["rev-list", "--count", "HEAD"]), output)
#	if output.is_empty() or output[0].is_empty():
#		push_error("Failed to fetch version. Make sure you have git installed and project is inside valid git directory.")
#	else:
#		return output[0].trim_suffix("\n")
	
	### Git branch version ### --------------------------------------------------------------------
	
	# Version is the current branch name. Useful for feature branches like 'release-1.0.0'
	# Requires git installed and project inside git repository.
	
#	var output := []
#	OS.execute("git", PackedStringArray(["rev-parse", "--abbrev-ref", "HEAD"]), output)
#	if output.is_empty() or output[0].is_empty():
#		push_error("Failed to fetch version. Make sure you have git installed and project is inside valid git directory.")
#	else:
#		return output[0].trim_suffix("\n")
	
	### Git commit hash ### -----------------------------------------------------------------------
	
	# Either full or short hash of the current commit. Useful for versions like '1.0.0-[24386f9]'
	# Requires git installed and project inside git repository.
	
	# Length of the hash. -1 is the whole hash (40 characters) but most of the times is is shortenet to the 7 initial characters
#	var length := 7
#	var output := []
#	OS.execute("git", PackedStringArray(["rev-parse", "HEAD"]), output)
#	if output.is_empty() or output[0].is_empty():
#		push_error("Failed to fetch version. Make sure you have git installed and project is inside valid git directory.")
#	else:
#		return output[0].trim_suffix("\n").substr(0, length)
	
	### Profile version ### -----------------------------------------------------------------------
	
	# Extracts version from an export profile. Requires export_presets.cfg to exist. 
	# The version will be taken from the first profile that contains non-empty value
	# in one of the version_keys.
	
#	var version_keys := ["file_version", "product_version", "version/name"]
#
#	var config := ConfigFile.new()
#	if config.load("res://export_presets.cfg") == OK:
#		var version := ""
#		var found: bool
#
#		for section in config.get_sections():
#			if section.ends_with(".options"):
#				for key in config.get_section_keys(section):
#					for check_key in version_keys:
#						if key.ends_with(check_key):
#							version = str(config.get_value(section, key))
#							found = true
#
#						if found:
#							break
#				if found:
#					break
#			if found:
#				break
#
#		if not found:
#			push_error("Failed to fetch version. No valid version key found in export profiles.")
#		else:
#			return version
#	else:
#		push_error("Failed to fetch version. export_presets.cfg does not exist.")
	
	### Android version ### -----------------------------------------------------------------------
	
	# Similar to profile version, but uses only Android version code and name.
	# Edit it if you want to format the version differently.
	
#	var config := ConfigFile.new()
#	if config.load("res://export_presets.cfg") == OK:
#		var code := ""
#		var vname := ""
#		var found: int
#
#		for section in config.get_sections():
#			if section.ends_with(".options"):
#				for key in config.get_section_keys(section):
#					if key == "version/code":
#						code = str(config.get_value(section, key))
#						found |= 1
#					elif key == "version/name":
#						vname = str(config.get_value(section, key))
#						found |= 2
#
#						if found == 3:
#							break
#				if found == 3:
#					break
#			if found == 3:
#				break
#
#		if found != 3:
#			push_error("Failed to fetch version. No valid version code and name found in export profiles.")
#		else:
#			# Edit formatting here.
#			return "%s %s" % [code, vname]
#	else:
#		push_error("Failed to fetch version. export_presets.cfg does not exist.")
	
	return ""

### Unimportant stuff here.

var exporter: AEVExporter

func _enter_tree() -> void:
	exporter = AEVExporter.new()
	exporter.plugin = self
	add_export_plugin(exporter)
	add_tool_menu_item("Print Current Version", print_version)
	
	if not File.new().file_exists(VERSION_SCRIPT_PATH):
		exporter.store_version(_fetch_version(PackedStringArray(), true, "", 0))

func _exit_tree() -> void:
	remove_export_plugin(exporter)
	remove_tool_menu_item("Print Current Version")

func print_version():
	var v = _fetch_version(PackedStringArray(), true, "", 0)
	if v.is_empty():
		OS.alert("Error fetching version. Check console for details.")
	else:
		OS.alert("Current game version: %s" % v)
		print(v)

class AEVExporter extends EditorExportPlugin:
	var plugin
	
	func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int):
		var version: String = plugin._fetch_version(features, is_debug, path, flags)
		if version.is_empty():
			push_error("Version string is empty. Make sure your _fetch_version() is configured properly.")
		
		store_version(version)

	func store_version(version: String):
		var script = GDScript.new()
		script.source_code = str("extends RefCounted\nconst VERSION: String = \"", version, "\"\n")
		if ResourceSaver.save(script, VERSION_SCRIPT_PATH) != OK:
			push_error("Failed to save version file. Make sure the path is valid.")
