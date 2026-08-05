extends Node2D


func _ready() -> void:
	if OS.has_feature("web"):
		CsoundServer.open_web_midi_inputs()
	else:
		OS.open_midi_inputs()
		print(OS.get_connected_midi_inputs())
