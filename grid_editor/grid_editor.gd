extends Node2D

var _grid_width:int = 30
var _grid_heght:int = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) == true:
		var pos=get_local_mouse_position()
		


func _on_draw():
	draw_rect(Rect2(32,32,32,32),Color(Color.ANTIQUE_WHITE))
