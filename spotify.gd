extends Node

var playing


func _ready():
	if OS.is_debug_build():
		var output = []
		OS.execute("dbus-send", [
			"--print-reply",
			"--dest=org.mpris.MediaPlayer2.spotify",
			"/org/mpris/MediaPlayer2",
			"org.freedesktop.DBus.Properties.Get",
			"string:\"org.mpris.MediaPlayer2.Player\"",
			"string:\"PlaybackStatus\""
		], output, true)
		playing = output[0].find("Playing")
		
		if playing != -1:
			OS.execute("dbus-send", [
				"--print-reply",
				"--dest=org.mpris.MediaPlayer2.spotify",
				"/org/mpris/MediaPlayer2",
				"org.mpris.MediaPlayer2.Player.Pause"
			])

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if OS.is_debug_build():
			var output = []
			OS.execute("dbus-send", [
				"--print-reply",
				"--dest=org.mpris.MediaPlayer2.spotify",
				"/org/mpris/MediaPlayer2",
				"org.freedesktop.DBus.Properties.Get",
				"string:\"org.mpris.MediaPlayer2.Player\"",
				"string:\"PlaybackStatus\""
			], output, true)
			playing = output[0].find("Playing")

			if playing == -1:
				OS.execute("dbus-send", [
					"--print-reply",
					"--dest=org.mpris.MediaPlayer2.spotify",
					"/org/mpris/MediaPlayer2",
					"org.mpris.MediaPlayer2.Player.Play"
				])
