extends Node

class_name DictTileMap

var _tile_map:Array = []
var _dict_map:Dictionary = {}

var _layer_map:Array=[]
var _fog_map:Array=[]

var _map_height:int=0:
	get = _get_map_height

var _map_width:int=0:
	get = _get_map_width


func init_game_map(rooms:Dictionary, width:int, height:int, num_layers:int)->void:
	_map_height=height
	_map_width=width
	_dict_map = rooms
	_reset_map()
	_build_tile_map()


func _reset_map()->void:
	for y in range(_map_height):
		_tile_map.append([])
		_layer_map.append([])
		_fog_map.append([])

		_tile_map[y].resize(_map_width)
		_layer_map[y].resize(_map_width)
		_fog_map[y].resize(_map_width)

		for x in range(_map_width):
			_tile_map[y][x] = 0
			_layer_map[y][x] = 0
			_fog_map[y][x] = 0


func _build_tile_map()->void:
	for key in _dict_map:
		var room=_dict_map[key]
		var pos:Vector2i = room["pos"]
		var size:Vector2i = room["size"]
		var cells:Array = room["cells"]
		
		for y in range(size.y):
			for x in range(size.x):
				_tile_map[pos.y+y][pos.x+x]=cells[y][x]


func _get_tile(x:int, y:int)->int:
	return _tile_map[y][x]


func _get_tile_map()->Array:
	return _tile_map


func _get_map_dict()->Dictionary:
	return _dict_map


func _get_map_height()->int:
	return _map_height


func _get_map_width()->int:
	return _map_width


func print_game_map() -> void:
	print("----------------------- GAME TILE MAP -----------------------------")

	for y in range(_map_height):
		var map_str=""
		for x in range(_map_width):
			map_str += "%02d " % [_tile_map[y][x]]
			
		print(map_str)


func print_layer_map() -> void:
	print("----------------------- GAME TILE LAYER MAP -----------------------------")
	for y in range(_map_height):
		var map_str=""
		for x in range(_map_width):
			map_str += "%02d " % [_layer_map[y][x]]
			
		print(map_str)
