@tool
extends Control
class_name BaseKnob

@export
var min_value: float = 0:
	set(value):
		min_value = value
		if not is_node_ready():
			await ready
		label_min.text = str(min_value)
		update_knob()

@export
var max_value: float = 1:
	set(value):
		max_value = value
		if not is_node_ready():
			await ready
		label_max.text = str(max_value)
		update_knob()

@export
var knob_name: String:
	set(value):
		knob_name = value
		if not is_node_ready():
			await ready
		label_name.text = knob_name

var use_int: bool

@export
var step: float = 0.001:
	set(value):
		step = value
		use_int = step == floor(step)
		if not is_node_ready():
			await ready
		update_knob()

@export_range(0, 1)
var current_value: float:
	set(value):
		current_value = value
		update_knob()

var actual_value: float:
	set(value):
		actual_value = value
		if not is_node_ready():
			await ready
		if use_int:
			label_value.text = "%d" % actual_value
		else:
			label_value.text = "%.2f" % actual_value

var captured: bool = false
var local_mouse_position: Vector2
var saved_current_value: float
var delta: float

@onready
var knob: TextureRect = $knob

@onready
var progress: TextureProgressBar = $progress

@onready
var label_name: Label = $LabelName

@onready
var label_min: Label = $LabelMin

@onready
var label_max: Label = $LabelMax

@onready
var label_value: Label = $LabelValue

signal value_changed(value: float)


func _ready() -> void:
	update_knob()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			captured = true
			local_mouse_position = get_local_mouse_position()
			saved_current_value = current_value
		else:
			captured = false

	if captured and event is InputEventMouseMotion:
		var current_mouse_position = get_local_mouse_position()

		var distance = abs(local_mouse_position.distance_to(current_mouse_position))
		var direction = local_mouse_position.angle_to(current_mouse_position) * -1

		if direction > 0:
			delta = clamp(distance / 100, 0, 1)
			current_value = clamp(saved_current_value + delta, 0, 1)
		if direction < 0:
			delta = -clamp(distance, 0, 1)
			current_value = clamp(saved_current_value + delta, 0, 1)

		update_knob()
		value_changed.emit(snapped(actual_value, step))


func update_actual_value() -> void:
	actual_value = ((current_value * (max_value - min_value))) + min_value


func update_knob() -> void:
	if not is_node_ready():
		await ready
	update_actual_value()
	knob.rotation_degrees = 20 + (current_value) * 320
	progress.value = current_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
