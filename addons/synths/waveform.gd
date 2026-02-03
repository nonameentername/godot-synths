@tool
extends Control
class_name Waveform

@export
var waveform: int:
	set(value):
		waveform = value
		if not is_node_ready():
			await ready
		waveform_sprite.region_rect.position.y = value * 32
		

var waveform_sprite: Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	waveform_sprite = $Panel/waveform


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
