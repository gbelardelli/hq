extends Node2D

@onready var tile_map = $TileMap
@onready var text_edit = $TextEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_button_pressed()
	#gen_map()


func gen_map():
	#StaticHqMap.generate_map(16,8,22,255)
	#StaticHqMap.print_game_map()
	#StaticHqMap.print_layer_map()
	#StaticHqMap.tests()
	#for i in range(0,36000):
	#	StaticHqMap.generate_map(randi_range(6,20),8,22,255)

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
					tile_map.set_cell(1, Vector2i(start_x,start_y),0,Vector2i(layer[y][x]-1,6))
			start_x += 1

		start_y+=1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var switch=true

func _on_button_pressed():
	#if switch==true:
		StaticHqMap.generate_map(14,8,22,255)
		
		#StaticHqMap.print_layer_map()
	#	switch=false
	#	else:
	#		StaticHqMap._build_paths()
	#		StaticHqMap.print_layer_map()
	#		switch=true

		gen_map()


func _on_button_2_pressed():
	StaticHqMap.print_json()


func _on_button_3_pressed():
	StaticHqMap.print_layer_map()
