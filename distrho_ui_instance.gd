extends DistrhoUIInstance


func _init() -> void:
	DistrhoUIServer.set_distrho_ui(self)


func get_some_text() -> String:
	return "godot AMSynth"
