extends Node2D

var amsynth: CsoundGodot
var initialized: bool = false

var strOnMidiMessage = """
function Input() {
	this.name = "midiinput"
    this.processed=false
    this.data = []
}
midiArray = new Input();
function onMIDIMessage (message) {
	/*
	var command = message.data[0];
	var note = message.data[1];
	var velocity = (message.data.length > 2) ? message.data[2] : 0; // a velocity value might not be included with a noteOff command
    switch (command) {
        case 144: // noteOn
            if (velocity > 0) {
                noteOn(note, velocity);
            } else {
                noteOff(note);
            }
            break;
        case 128: // noteOff
            noteOff(note);
            break;
        // we could easily expand this switch statement to cover other types of commands such as controllers or sysex
    }
*/
	midiArray.data.push(message)
}
function failure () {  
	alert('No access to your midi devices.') 
}
function success (midi) { 
	var inputs = midi.inputs.values(); 
	for (var input = inputs.next(); input && !input.done; input = inputs.next()) { 
		input.value.onmidimessage = onMIDIMessage; 
	} 
}
if (navigator.requestMIDIAccess) 
{ 
	navigator.requestMIDIAccess().then(success, failure); 
} else {
	alert('no midi support, you cannot play');
}"""

func _ready() -> void:
	JavaScriptBridge.eval(strOnMidiMessage, true)
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	CsoundServer.csound_layout_changed.connect(csound_layout_changed)

func csound_layout_changed():
	amsynth = CsoundServer.get_csound("amsynth")
	amsynth.csound_ready.connect(initialize)

func initialize() -> void:
	initialized = true


func _input(input_event):
	if input_event is InputEventMIDI:
		_send_midi_info(input_event)


func _send_midi_info(midi_event):
	#print(midi_event)
	#print("Channel ", midi_event.channel)
	#print("Message ", midi_event.message)
	#print("Pitch ", midi_event.pitch)
	#print("Velocity ", midi_event.velocity)
	#print("Instrument ", midi_event.instrument)
	#print("Pressure ", midi_event.pressure)
	#print("Controller number: ", midi_event.controller_number)
	#print("Controller value: ", midi_event.controller_value)

	if midi_event.message == MIDI_MESSAGE_NOTE_ON:
		amsynth.instrument_note_on("hello_midi", 1, midi_event.pitch, midi_event.velocity)

	if midi_event.message == MIDI_MESSAGE_NOTE_OFF:
		amsynth.instrument_note_off("hello_midi", 1, midi_event.pitch)


func _process(_delta: float) -> void:
	var midiinput = _fetch_js_input()
	if midiinput.data == null:
		return
	if midiinput.data.size() == 0:
		return

	for data in midiinput.data:
		var command = data[0] & 0xF0 #Extract command type
		var _channel = data[0] & 0x0F #Extract MIDI channel
		var pitch = data[1]
		var velocity = data[2]

		if command == 0x90:
			amsynth.instrument_note_on("hello_midi", 1, pitch, velocity)

		if command == 0x80:
			amsynth.instrument_note_off("hello_midi", 1, pitch)


func _fetch_js_input():
	var input_action=JavaScriptBridge.eval("""midiArray.name""")
	var input_processed=JavaScriptBridge.eval("""midiArray.processed""")
	var number_of_messages = JavaScriptBridge.eval("""midiArray.data.length""")
	if number_of_messages == null:
		return {"action": input_action, "processed": input_processed, "data": null}
		
	var data = []
	for i in number_of_messages:
		data.append(JavaScriptBridge.eval("midiArray.data[" + str(i) + "].data"))
	JavaScriptBridge.eval("midiArray.data = []", true)
	return {"action": input_action, "processed": input_processed, "data": data}
