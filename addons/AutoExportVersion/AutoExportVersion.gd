tool
extends EditorPlugin

const VERSION_SCRIPT_PATH = "res://version.gd"

func _fetch_version(features: PoolStringArray, is_debug: bool, path: String, flags: int) -> String:
	var output := []
	OS.execute("git", PoolStringArray(["rev-list", "--count", "HEAD"]), true, output)
	if output.empty() or output[0].empty():
		push_error("Failed to fetch version. Make sure you have git installed and project is inside valid git directory.")
	else:
		return output[0]
	
	return ""

var exporter: Exporter

func _enter_tree() -> void:
	exporter = Exporter.new()
	exporter.plugin = self
	add_export_plugin(exporter)
	
	if not File.new().file_exists(VERSION_SCRIPT_PATH):
		exporter.store_version(_fetch_version(PoolStringArray(), true, "", 0))
	exporter.store_version(_fetch_version(PoolStringArray(), true, "", 0))

func _exit_tree() -> void:
	remove_export_plugin(exporter)

class Exporter extends EditorExportPlugin:
	var plugin
	
	func _export_begin(features: PoolStringArray, is_debug: bool, path: String, flags: int):
		store_version(plugin._fetch_version(features, is_debug, path, flags))

	func store_version(version: String):
		var script = GDScript.new()
		script.source_code = str("extends Reference\nconst VERSION = \"", version, "\"\n")
		ResourceSaver.save(VERSION_SCRIPT_PATH, script)
