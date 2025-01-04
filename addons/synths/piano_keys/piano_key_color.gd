extends ColorRect

@onready var parent: PianoKey = get_parent()


var _is_active: bool = false
var _is_playing: bool = false


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _input(input_event: InputEvent) -> void:
	if _is_active:	
		if input_event is InputEventMouseButton and input_event.pressed:
			_midi_note_on()
		if input_event is InputEventMouseButton and not input_event.pressed:
			_midi_note_off()


func _on_mouse_entered() -> void:
	_is_active = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_midi_note_on()


func _on_mouse_exited() -> void:
	_is_active = false
	_midi_note_off()


func _midi_note_on() -> void:
	if not _is_playing:
		_is_playing = true
		var input_event_midi: InputEventMIDI = InputEventMIDI.new()
		input_event_midi.device = 0
		input_event_midi.channel = 0
		input_event_midi.message = MIDI_MESSAGE_NOTE_ON
		input_event_midi.pitch = parent.pitch_index
		input_event_midi.velocity = 64

		parent.activate()
		Input.parse_input_event(input_event_midi)


func _midi_note_off() -> void:
	if _is_playing:
		_is_playing = false
		var input_event_midi: InputEventMIDI = InputEventMIDI.new()
		input_event_midi.device = 0
		input_event_midi.channel = 0
		input_event_midi.message = MIDI_MESSAGE_NOTE_OFF
		input_event_midi.pitch = parent.pitch_index
		input_event_midi.velocity = 0

		parent.deactivate()
		Input.parse_input_event(input_event_midi)
