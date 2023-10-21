extends Control

@onready var file_dialog = $FileDialog
@onready var texture_rect = $MC/HBoxContainer/Panel/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	file_dialog.current_dir ="."
	file_dialog.show()


func _on_file_dialog_file_selected(path):
	print(path)
	texture_rect.set_texture (load(path))
