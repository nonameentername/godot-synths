extends "res://addons/godot-package/package.gd"


func _requirements():
	var distrho_version = "v0.1.0-beta.14"

	dependency("nonameentername/godot-csound", {"tag": "v0.1.0-beta.159"})
	dependency("nonameentername/godot-distrho", {"tag": distrho_version})

	for template in ["linux", "macos", "windows"]:
		dependency("nonameentername/godot-distrho", {
			"tag": distrho_version,
			"name": "templates_%s_godot-distrho_%s.zip" % [template, distrho_version]}
		)
