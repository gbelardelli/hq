extends Node2D

@onready var tile_map = $TileMap
@onready var text_edit = $TextEdit

enum MONSTER_CLASS { NOTHING=0, 
	ORC=1, 
	NOT_DEAD=2, 
	MAGIC=4
}

enum MONSTER_FIELDS {
	TYPE,
	QUANTITY,
	SIZE,
	CLASS
}

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.init_game("heroquest")
	var fu=GlobalUtils.load_furnitures("heroquest")
	StaticHqMap.generate_map(12)
	#StaticHqMap.print_game_map()
	var tiles = StaticHqMap.get_game_map()
	var layer=StaticHqMap.get_layer_map()
	var start_y=1
	var cell_x=0
	var cell_y=0

	for y in range(StaticHqMap.MAP_HEIGHT):
		var start_x=1

		for x in range(StaticHqMap.MAP_WIDTH):
			var cell=tiles[y][x]
			cell_y=(cell / 10)+1
			cell_x=(cell%10)

			tile_map.set_cell(0, Vector2i(start_x,start_y),0,Vector2i(cell_x,cell_y))
			tile_map.set_cell(1, Vector2i(start_x,start_y),0,Vector2i(layer[y][x]-1,5))
			start_x += 1

		start_y+=1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_button_pressed():
	StaticHqMap.test_traverse(int(text_edit.text))
