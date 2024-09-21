extends Control


var preset_dir = "presets/"
var resource_dir = "res://" + preset_dir

@onready
var preset_item_list: ItemList = $ItemList

var presets: Array[String] = []


signal load_preset(name: String)


func _ready() -> void:
	load_presets()


func _process(_delta: float) -> void:
	pass


func load_presets():
	for file_name in DirAccess.get_files_at(resource_dir):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
			presets.append(file_name.split(".")[0])
	update_preset_list("")


func _on_line_edit_text_changed(new_text:String) -> void:
	update_preset_list(new_text)


func update_preset_list(text: String):
	preset_item_list.clear()
	for preset in presets:
		if preset.to_lower().contains(text.to_lower()) or len(text) == 0:
			preset_item_list.add_item(preset)


func _on_button_pressed() -> void:
	if len(preset_item_list.get_selected_items()) == 0:
		return

	var index: int = preset_item_list.get_selected_items()[0]
	var selected_preset = preset_dir + preset_item_list.get_item_text(index) + ".inc"

	load_preset.emit(selected_preset)