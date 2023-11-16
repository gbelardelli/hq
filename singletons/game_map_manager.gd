extends Node

class_name MapManager


var _game_tile_map:Array = []
var _game_rooms_dict:Dictionary = {}

var _layer_map:Array=[]
var _fog_map:Array=[]

var _map_height:int=0
var _map_width:int=0

func init_game_map(rooms:Dictionary, width:int, height:int, num_layers:int)->void:
	_map_height=height
	_map_width=width
	_game_rooms_dict = rooms
	_reset_map()
	_build_tile_map()


func _reset_map()->void:
	for y in range(_map_height):
		_game_tile_map.append([])
		_layer_map.append([])
		_fog_map.append([])

		_game_tile_map[y].resize(_map_width)
		_layer_map[y].resize(_map_width)
		_fog_map[y].resize(_map_width)

		for x in range(_map_width):
			_game_tile_map[y][x] = 0
			_layer_map[y][x] = 0
			_fog_map[y][x] = 0


func _build_tile_map()->void:
	for key in _game_rooms_dict:
		var room=_game_rooms_dict[key]
		var pos:Vector2i = room["pos"]
		var size:Vector2i = room["size"]
		var cells:Array = room["cells"]
		
		for y in range(size.y):
			for x in range(size.x):
				_game_tile_map[pos.y+y][pos.x+x]=cells[y][x]


func print_game_map() -> void:
	print("----------------------- GAME TILE MAP -----------------------------")

	for y in range(_map_height):
		var map_str=""
		for x in range(_map_width):
			map_str += "%02d " % [_game_tile_map[y][x]]
			
		print(map_str)


func print_layer_map() -> void:
	print("----------------------- GAME TILE LAYER MAP -----------------------------")
	for y in range(_map_height):
		var map_str=""
		for x in range(_map_width):
			map_str += "%02d " % [_layer_map[y][x]]
			
		print(map_str)
