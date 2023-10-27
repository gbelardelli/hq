extends Node2D

@onready var tile_map = $TileMap
@onready var text_edit = $TextEdit
@onready var label_3 = $Label3
@onready var spin_box = $SpinBox
@onready var spin_box_2 = $SpinBox2
@onready var check_box = $CheckBox
@onready var text_edit_2 = $TextEdit2
@onready var text_edit_3 = $TextEdit3

var _group = 1
var _max_rooms=5
var _random_seed =int(Time.get_unix_time_from_system())
# Called when the node enters the scene tree for the first time.
func _ready():
	seed(_random_seed)
	print(_random_seed)
	check_box.button_pressed = true
	text_edit_3.text=str(_random_seed)
	spin_box_2.min_value=0
	spin_box.value = _max_rooms
	_set_max_rooms()
	_on_button_pressed()
	#gen_map()


func _set_max_rooms()->void:
	var max=0
	if _group & 1 > 0:
		max+=5
	if _group & 2 > 0:
		max+=5
	if _group & 4 > 0:
		max+=6
	if _group & 8 > 0:
		max+=5
	if _group & 16 > 0:
		max+=1

	_max_rooms=max
	spin_box.max_value=_max_rooms
	spin_box_2.max_value=_max_rooms/3

	label_3.text=str(_max_rooms)

func run_test(num_tests:int)->void:
	for i in range(0,num_tests):
		_random_seed =int(Time.get_unix_time_from_system())
		var num_rooms=randi_range(6,20)
		if StaticHqMap.generate_map(num_rooms,num_rooms/3,true,255,_random_seed) == false:
			break
		if i % 5000==0:
			print(i)
	
func gen_map():
	#run_test(10000)
	var tiles = StaticHqMap.get_game_map()
	var layer=StaticHqMap.get_layer_map()
	var start_y=1
	var cell_x=0
	var cell_y=0
	tile_map.clear()
	for y in range(StaticHqMap.MAP_HEIGHT):
		var start_x=1
		for x in range(StaticHqMap.MAP_WIDTH):
			var cell=tiles[y][x]
			cell_y=(cell / 10)+1
			cell_x=(cell%10)

			tile_map.set_cell(0, Vector2i(start_x,start_y),0,Vector2i(cell_x,cell_y))
			if layer[y][x] > 0:
				if layer[y][x] < 16:
					tile_map.set_cell(1, Vector2i(start_x,start_y),0,Vector2i(layer[y][x]-1,5))
				else:
					tile_map.set_cell(1, Vector2i(start_x,start_y),0,Vector2i((layer[y][x]>>4)-1,6))
			start_x += 1
		start_y+=1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	_random_seed =int(Time.get_unix_time_from_system())
	seed(_random_seed)
	print(_random_seed)
	text_edit_3.text=str(_random_seed)
	StaticHqMap.generate_map(spin_box.value,spin_box_2.value,check_box.button_pressed,_group,_random_seed)
	gen_map()


func _on_button_2_pressed():
	print("--------------------------------------------")
	StaticHqMap.print_json()


func _on_button_3_pressed():
	print("--------------------------------------------")
	StaticHqMap.print_layer_map()


func _on_button_4_pressed():
	var room_num:int = int(text_edit_2.text)
	var visited_rooms:Array = [room_num]
	var exits_rooms:Array = []
	var exits=StaticHqMap._find_exits(room_num,visited_rooms,exits_rooms)
	print("Room [%d] has exits on [%s] rooms" % [room_num, exits_rooms])


func _on_check_button_toggled(button_pressed):
	if button_pressed==true:
		_group|=1
	else:
		_group-=1
		
	_set_max_rooms()


func _on_check_button_5_toggled(button_pressed):
	if button_pressed==true:
		_group|=2
	else:
		_group-=2

	_set_max_rooms()

func _on_check_button_4_toggled(button_pressed):
	if button_pressed==true:
		_group|=4
	else:
		_group-=4
	
	_set_max_rooms()

func _on_check_button_3_toggled(button_pressed):
	if button_pressed==true:
		_group|=8
	else:
		_group-=8

	_set_max_rooms()

func _on_check_button_2_toggled(button_pressed):
	if button_pressed==true:
		_group|=16
	else:
		_group-=16

	_set_max_rooms()


func _on_button_5_pressed():
	var _seed=int(text_edit_3.text)
	seed(_seed)
	print(_seed)
	StaticHqMap.generate_map(spin_box.value,spin_box_2.value,check_box.button_pressed,_group,_seed)
	gen_map()
