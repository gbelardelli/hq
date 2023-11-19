extends Node

enum ROOM_TYPES {VOID=0, PASSAGEWAY=1, ROOM=2}

const DIRECTIONS:Array = ["north","east","south","west"]
const OPPOSITE_VALUE:Dictionary = { "north" : Vector2i(0,-1), 
									"east" : Vector2i(1,0), 
									"south": Vector2i(0,1), 
									"west" : Vector2i(-1,0) }

var _game_rooms_list:Dictionary = {}
var _in_game_rooms:Dictionary={}

var _game_map:Array=[]
var _layer_map:Array=[]
var _fog_map:Array=[]

var _astar_grid:AStarGrid2D
var _map_points:AStar2D
var _map_mgr:DictTileMap

# Generation parameters
var _generate_near_center:bool = true
var _max_deep:int = 3
var _max_secret_doors:int = 5
var _chance_of_secret_door:int = 90
var _debug_seed:int = 0
var _rooms_to_generate:int = 0
var _group_mask:int = 0


func generate_map(rooms:int, secret_doors:int, near_center:bool,group_mask:int, debug_seed:int, map_mgr:DictTileMap) -> bool:
	_game_rooms_list = map_mgr._get_map_dict()
	_map_mgr = map_mgr

	reset_all()
	_debug_seed=debug_seed
	_group_mask=group_mask

	if rooms<1:
		rooms=1

	_generate_near_center=near_center
	_max_secret_doors = secret_doors
	
	var rooms_in_mask=_get_rooms_for_group_mask(group_mask)
	if rooms > rooms_in_mask:
		rooms=rooms_in_mask

	if _max_secret_doors > rooms:
		_max_secret_doors = int(rooms/3)

	_rooms_to_generate = rooms
	_generate_rooms(rooms,group_mask)
	_build_paths()
	_generate_secret_doors(_max_secret_doors,_chance_of_secret_door)

	var force_exit=0
	while true:
		var no_exit_rooms:Array = []

		for key in _in_game_rooms:
			var exits:Array=[]
			var res=_find_exits(key, [key], exits)
			if res == 0:
				no_exit_rooms.append(key)

		if no_exit_rooms.size() > 0:
			force_exit+=1
			_create_passageway_door(no_exit_rooms[0])
		else:
			break

		if force_exit>200:
			print("Huston we have a serious problem! We can't fix rooms exits" % [no_exit_rooms])
			break
	print_json()
	_close_passageways()
	_update_game_map()
	_generate_traps()
	_generate_start_end_pos()

	return true


func _generate_start_end_pos()->void:
	# Le posizioni di inizio e fine missione possono trovarsi sia in una
	# stanza sia al bordo del tabellone (scelta randomica).
	# Indipendentemente da dove viene scelta la posizione iniziale,
	# l'algoritmo cercherà la stanza/corridio più lontano per metterci
	# l'uscita.
	var start_room:int=0
	var end_room:int=0
	var group:int=0
	if GlobalUtils.roll_d100_chance(50) == true:
		# Entrata da una stanza
		start_room=_in_game_rooms.keys().pick_random()
		group=_in_game_rooms[start_room]["group"]
		print("Entra dalla stanza %d" % [start_room-31])
	else:
		print("Entra da un corridoio")

	if GlobalUtils.roll_d100_chance(50) == true:
		# Uscita da una stanza
		end_room=_in_game_rooms.keys().pick_random()
		print("Esce dalla stanza %d" % [end_room-31])
	else:
		print("Esce da un corridoio")

func _generate_traps()->void:
	pass


func _close_passageways()->void:
	var doors_list=_get_passageway_doors_list()
	var first_door:Vector2i = doors_list[0]
	var passageways:Dictionary = {}
	
	for key in _game_rooms_list:
		if get_room_type(key) == ROOM_TYPES.PASSAGEWAY:
			passageways[key] = _game_rooms_list[key]

	# Check if passageway has doors
	for key in passageways:
		if _can_close_passageway(key,doors_list) == true:
			var rect:Rect2i = Rect2i(passageways[key]["pos"], passageways[key]["size"])
			var x1=rect.position.x+rect.size.x-1
			var y1=rect.position.y+rect.size.y-1

			_astar_grid.set_point_solid(rect.position,true)
			_astar_grid.set_point_solid(Vector2i(x1,y1),true)
			var expand_x=false
			if rect.position.x != x1:
				expand_x=true
				_astar_grid.set_point_solid(Vector2i(x1,rect.position.y),true)
				_astar_grid.set_point_solid(Vector2i(rect.position.x,y1),true)

			if _can_reach_other_doors(first_door, doors_list) == false:
				_astar_grid.set_point_solid(rect.position,false)
				_astar_grid.set_point_solid(Vector2i(x1,y1),false)
			else:
				_petrifies_map(key)


func _petrifies_map(key:int)->void:
	var room=_game_rooms_list[key]
	var pos:Vector2i = room["pos"]
	var size:Vector2i = room["size"]

	for y in range(size.y):
		for x in range(size.x):
			_game_map[pos.y+y][pos.x+x]=0


func _can_reach_other_doors(start:Vector2i, doors_list:Array)->bool:
	var num_reached=0
	for idx in range(1,doors_list.size()):
		var step_list = _astar_grid.get_id_path(start, doors_list[idx])
		if step_list.size() > 0:
			num_reached+=1
	
	if num_reached == doors_list.size()-1:
		return true
		
	return false


func _can_close_passageway(id:int, doors_list:Array)->bool:
	var passageway:Dictionary = _game_rooms_list[id]
	var has_door=false
	for door in doors_list:
		var rect:Rect2i = Rect2i(passageway["pos"], passageway["size"])
		var x=rect.position.x
		var y=rect.position.y
		var x1=x+rect.size.x
		var y1=y+rect.size.y
		if door.x >= x && door.x <= x1 && door.y >= y && door.y <= y1:
			has_door=true
			break

	if not has_door:
		return true

	return false


func _generate_secret_doors(num_doors:int, chance:int)->void:
	for i in range(0,num_doors):
		if GlobalUtils.roll_d100_chance(chance) == true:
			var rooms:Array=_in_game_rooms.keys()

			# Un stanza può avere max 1 porta segreta
			var room=0
			while  true:
				room=rooms.pick_random()
				if _has_secret_doors(room) == false:
					break

			var door=_in_game_rooms[room]["doors"].keys().pick_random()
			var doors_array:Array
			var chosed_door:Dictionary

			if get_room_type(door) == ROOM_TYPES.ROOM:
				doors_array=_in_game_rooms[door]["doors"][room]
				chosed_door=doors_array[0]
				chosed_door["type"]="secret"

			doors_array=_in_game_rooms[room]["doors"][door]
			chosed_door=doors_array[0]
			chosed_door["type"]="secret"

			_remove_unnecessary_doors(room, door)


func _has_secret_doors(room_num:int)->bool:
	var doors_key:Dictionary=_in_game_rooms[room_num]["doors"]
	for doors in doors_key:
		for door in doors_key[doors]:
			if door["type"]=="secret":
				return true

	return false


func _remove_unnecessary_doors(room_num:int, door:int)->void:
	var doors=_in_game_rooms[room_num]["doors"]
	var can_be_removed_doors:Dictionary = {}

	if get_room_type(door) == ROOM_TYPES.PASSAGEWAY:
		# Prendere le porte di questa stanza ad esclusione di quella di entrata
		# Per ogni porta controllare se le stanze adiacenti hanno uno sbocco
		var rooms:Array = doors.keys()
		var exit_rooms:Dictionary = {}
		var exits_rooms:Array = []
		for room in rooms:
			if get_room_type(room) == ROOM_TYPES.PASSAGEWAY:
				continue

			var visited_rooms:Array = [room_num]
			var num_exits=_find_exits(room, visited_rooms, exits_rooms)
			exit_rooms[room]=num_exits

		var can_remove_all_doors=false
		for room in exit_rooms:
			if exit_rooms[room] == 0:
				can_remove_all_doors=false
				break
			
			can_remove_all_doors=true

		if can_remove_all_doors == true and exit_rooms.size() > 0:
			if GlobalUtils.roll_d100_chance(50) == true:
				for room in exits_rooms:
					_remove_passageway_doors(room, _in_game_rooms[room])
			else:
				_remove_normal_doors(room_num)
		elif can_remove_all_doors == true:
			_remove_normal_doors(room_num)
		elif exit_rooms.size() > 0:
			for room in exits_rooms:
				_remove_passageway_doors(room, _in_game_rooms[room])

		_remove_passageway_doors(room_num, _in_game_rooms[room_num])
	else:
		_remove_room_doors(room_num)	

func _remove_room_doors(room_num:int)->void:
	var doors:Dictionary=_in_game_rooms[room_num]["doors"]
	var keys=doors.keys()
	var door_in_passageway:bool = false

	for key in keys:
		if get_room_type(key) == ROOM_TYPES.PASSAGEWAY:
			door_in_passageway=true
			break

	if door_in_passageway==true:
		for room in keys:
			if get_room_type(room) == ROOM_TYPES.ROOM:
				var exits=[]
				if _find_exits(room, [room_num], exits) > 0:
					if GlobalUtils.roll_d100_chance(50) == true:
						_remove_passageway_doors(room_num, _in_game_rooms[room_num])
						break
					else:
						for exit in exits:
							_remove_passageway_doors(exit, _in_game_rooms[exit])
	else:
		for room in keys:
			if get_room_type(room) == ROOM_TYPES.PASSAGEWAY:
				_remove_normal_doors(room,room_num)
			else:
				var exits=[]
				if _find_exits(room, [room_num], exits) > 0:
					_remove_normal_doors(room,room_num)


func _remove_normal_doors(room_num:int, adj:int=0)->void:
	var doors:Dictionary=_in_game_rooms[room_num]["doors"]
	var to_delete:Array = []

	for room in doors:
		for door in doors[room]:
			if door["type"] == "normal":
				var other_room=_get_adjacent_room(door["dir"], door["pos"])
				if get_room_type(other_room) == ROOM_TYPES.ROOM:
					if adj==0 or adj==other_room:
						var other_doors=_in_game_rooms[other_room]["doors"]
						other_doors.erase(room_num)
				if adj==0 or adj==other_room:
					to_delete.append(door)
				
	for door in to_delete:
		var key=doors.find_key([door])
		if key != null:
			doors.erase(key)
			if _in_game_rooms[room_num]["doors"].size() == 0:
				_in_game_rooms[room_num]["doors"].erase(room_num)


func _build_paths()->void:
	var keys:Array=_in_game_rooms.keys()
	var visited_rooms=[]
	var room:int=0
	var neighbor_info=_build_neighbor_info()

	while true:
		while true:
			room=keys.pick_random()
			if room not in visited_rooms:
				visited_rooms.append(room)
				break

		_traverse_map(room, 1, neighbor_info, [])
		if visited_rooms.size() == keys.size():
			break


func _traverse_map(room_num:int, deep:int, neighbor_info:Dictionary, walk_history:Array)->void:
	var room:Dictionary=_in_game_rooms[room_num]
	if room["valid"] == true:
		return

	if deep > _max_deep:
		room["valid"]=true
		return

	var neighbor_rooms:Array=neighbor_info[room_num]

	# Rimuovo dalla lista delle stanze vicine, quelle già visitate
	for walked in walk_history:
		while true:
			var idx:int = neighbor_rooms.find(walked)
			if idx != -1:
				neighbor_rooms.remove_at(idx)
			else:
				break

	if neighbor_rooms.size() == 0:
		# La stanza non confina con altre stanze
		room["valid"]=true
		# ... ma se è stata aperta una porta dalla
		# stanza precedente è possibile rimuovere
		# le porte sui corridoi
		if deep>1:
			_remove_passageway_doors(room_num, room)

		return

	walk_history.append(room_num)
	var neighbor_room = neighbor_rooms.pick_random()
	room["valid"]=true

	if deep>1:
		_remove_passageway_doors(room_num, room)

	deep+=1
	#print("   Open door on room [%d] to room [%d]" % [room_num,neighbor_room])
	_add_door(room_num, neighbor_room)
	_traverse_map(neighbor_room,deep,neighbor_info,walk_history)


func _remove_passageway_doors(room_num:int, room_dict:Dictionary)->void:
	var doors=_in_game_rooms[room_num]["doors"]
	var to_delete:Array = []

	for room in doors:
		if get_room_type(room) == ROOM_TYPES.PASSAGEWAY:
			for door in doors[room]:
				if door["type"] == "normal":
					#print("   Remove passageway door on room [%d] door [%s]" % [room_num, door])
					to_delete.append(room)
					_map_points.disconnect_points(room_num,room)

	for door in to_delete:
		doors.erase(door)
		


func _find_exits(room_num:int, visited:Array, exits:Array)->int:
#	room_num=room_num+31
#	if not _in_game_rooms.has(room_num):
#		#print("Room not exists")
#		return 0

	var doors:Dictionary=_in_game_rooms[room_num]["doors"]
	var cnt=0
	for room in doors:
		if room in visited:
			continue

		if get_room_type(room) == ROOM_TYPES.PASSAGEWAY:
			#print("  Find exit in [%d]"%[room_num])
			exits.append(room_num)
			cnt+=1
			continue

		visited.append(room_num)
		cnt += _find_exits(room, visited, exits)

	return cnt


func _update_game_map()->void:
	for room_num in _in_game_rooms:
		var doors=_in_game_rooms[room_num]["doors"]
		for door_num in doors:
			for door in doors[door_num]:
				_add_door_to_map(door["dir"],door["pos"], door["type"] == "secret")


func _get_passageway_doors_list()->Array:
	var doors_list:Array=[]

	for room_num in _in_game_rooms:
		var doors=_in_game_rooms[room_num]["doors"]
		for door_num in doors:
			if get_room_type(door_num) == ROOM_TYPES.PASSAGEWAY:
				for door in doors[door_num]:
					var pos:Vector2i = door["pos"]+OPPOSITE_VALUE[door["dir"]]
					_astar_grid.set_point_solid(pos,false)
					doors_list.append(pos)

	return doors_list


func _build_neighbor_info()->Dictionary:
	var neighbor_info={}
	for key in _in_game_rooms:
		neighbor_info[key] = _get_neighbor_rooms(_in_game_rooms[key])

	return neighbor_info


func _get_neighbor_rooms(room:Dictionary)->Array:
	var neighbor_rooms=[]
	var boundaries=room["boundaries"]
	#for dir in boundaries:
	#var walls=boundaries[dir]
	for wall in boundaries:
		if get_room_type(wall) == ROOM_TYPES.ROOM:
			neighbor_rooms.append(wall)

	return neighbor_rooms


func _add_door(main_room:int, other_room:int)->void:
	if _has_secret_doors(main_room) == true:
		return

	var room_boundaries={}
	var boundaries:Array=_in_game_rooms[main_room]["boundaries"][other_room]
#	for dir in boundaries:
#		var walls=boundaries[dir]
#		for wall in walls:
#			if dir == other_room:
#				room_boundaries[dir]=walls[wall]

	var direction = room_boundaries.keys().pick_random()
	var door_coord:Vector2i
	if _generate_near_center == true:
		var idx=boundaries.size()
		idx = idx / 2
		door_coord=boundaries[idx]
	else:
		door_coord=boundaries.pick_random()
	_create_door(other_room, door_coord, main_room)


func _has_door_in_room(room_num:int, adj:int)->bool:
	if room_num<2:
		return false

	var doors:Dictionary=_in_game_rooms[room_num]["doors"]
	for dir in doors:
		var door_wall=doors[dir]
		for door in door_wall["rooms"]:
			if door == adj:
				return true

	return false


func _generate_rooms(rooms:int,group_id:int)->void:
	var created_rooms = []
	for i in range(rooms):
		while true:
			var id=_game_rooms_list.keys().pick_random()
			var room=_game_rooms_list[id]
			if int(room["group"]) & group_id == 0:
				continue

			if id not in created_rooms:
				_create_room(id,2)
				created_rooms.append(id)
				break

	for key in _in_game_rooms:
		_discovery_boundaries(key)
		print_json()
		_create_passageway_door(key)


func reset_all() -> void:
	_astar_grid = AStarGrid2D.new()
	_astar_grid.cell_size = Vector2(1, 1)
	_astar_grid.size = Vector2(_map_mgr._get_map_width(), _map_mgr._get_map_height())
	_astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar_grid.update()

	_map_points = AStar2D.new()
	
	_game_map=[]
	_layer_map=[]
	_fog_map=[]
	_in_game_rooms={}

	for y in range(_map_mgr._get_map_height()):
		_game_map.append([])
		_layer_map.append([])
		_fog_map.append([])

		_game_map[y].resize(_map_mgr._get_map_width())
		_layer_map[y].resize(_map_mgr._get_map_width())
		_fog_map[y].resize(_map_mgr._get_map_width())

		for x in range(_map_mgr._get_map_width()):
			_game_map[y][x] = 0
			_layer_map[y][x] = 0
			_fog_map[y][x] = 0
			_astar_grid.set_point_solid(Vector2i(x,y),true)

	for key in _game_rooms_list:
		_game_rooms_list[key]["doors"] = {}
		_game_rooms_list[key]["boundaries"] = {}
		_game_rooms_list[key]["valid"] = false
		
		if _game_rooms_list[key]["type"] == ROOM_TYPES.PASSAGEWAY:
			_map_points.add_point(key, _game_rooms_list[key]["pos"])


# Copia sulla _game_map la room generata prendendola
# da _game_board_map_ref. Il ciclo continua per tutta la mappa, così è
# possibile avere room di qualsiasi forma
func _create_room(room_num:int,type:int) -> void:
	var room_cells:int=0
	_map_points.add_point(room_num,_game_rooms_list[room_num]["pos"])
	for y in range(_map_mgr._get_map_height()):
		var cells_founded:int=0
		for x in range(_map_mgr._get_map_width()):
			var id=_map_mgr._get_tile(x,y)
			if id == room_num:
				_game_map[y][x] = room_num
				room_cells += 1
				cells_founded+=1
			elif _game_rooms_list[id]["type"] == 1:
				_game_map[y][x] = id
				_astar_grid.set_point_solid(Vector2i(x,y),false)

		if room_cells >= 1 and cells_founded == 0:
			break

	# Copia le info della room e aggiunge i boundaries che servono
	# poi per creare le porte sulle pareti
	_in_game_rooms[room_num]=_game_rooms_list[room_num]
	var room:Dictionary = _in_game_rooms[room_num]
#	room["boundaries"]["north"] = {}
#	room["boundaries"]["east"] = {}
#	room["boundaries"]["south"] = {}
#	room["boundaries"]["west"] = {}


func _discovery_boundaries(room_num:int) -> void:
	var room = _in_game_rooms[room_num]["boundaries"]
	for y in range(_map_mgr._get_map_height()):
		for x in range(_map_mgr._get_map_width()):
			if _game_map[y][x] == room_num:
				_resolve_boundaries(Vector2i(x,y),room,room_num)


func _resolve_boundaries(cell_pos:Vector2i, room:Dictionary,room_num:int)->void:
	for dir in DIRECTIONS:
		var pos:Vector2i=cell_pos+OPPOSITE_VALUE[dir]
		var cell=_game_map[pos.y][pos.x]

		if cell == room_num:
			continue

		#var cell_room=room[dir]
		if(  room.has(cell)) == false:
			room[cell] = []

		room[cell].append(cell_pos)


func _create_passageway_door(room_num: int)->void:
	var room = _in_game_rooms[room_num]["boundaries"]
	var random_corridor_wall=[]

	#for dir in DIRECTIONS:
	for wall in room:
		if get_room_type(wall) == ROOM_TYPES.PASSAGEWAY:
			random_corridor_wall.append( {wall: room[wall]})

	var prev_dir:Array = []
	var total_doors:int=0
	while true:
		var room_walls:Dictionary = random_corridor_wall.pick_random()
		
		var dir = room_walls.keys()[0]
		if dir in prev_dir:
			continue

		prev_dir.append(dir)
		var door_position:Vector2i
		if _generate_near_center == true:
			var idx=room_walls[dir].size()
			idx = idx / 2
			door_position=room_walls[dir][idx]
		else:
			door_position=room_walls[dir].pick_random()

		_create_door(dir, door_position, room_num)
		total_doors+=1

		if random_corridor_wall.size() > 1 && prev_dir.size() < random_corridor_wall.size():
			if _can_add_door(room_num,total_doors) == true:
				continue

		break


func _can_add_door(room_num:int,modifier:int)->bool:
	var chance:int=0
	var room_size:int = _in_game_rooms[room_num]["area"]
	if room_size < 10:
		chance = 5 - (modifier*5)
	elif room_size < 15:
		chance = 10 - (modifier*6)
	elif room_size < 25:
		chance = 20 - (modifier*7)
	else:
		chance = 80 - (modifier*2)

	return GlobalUtils.roll_d100_chance(chance)


func _create_door(adj:int, position:Vector2i, room_num:int)->void:
	var room = _in_game_rooms[room_num]
	#var adj=_get_adjacent_room(direction,position)

	_create_door_dict(room, "direction",position,adj)
	_map_points.connect_points(room_num,adj)
	if get_room_type(adj) == ROOM_TYPES.ROOM:
		var other_room=_in_game_rooms[adj]
		var direction=_find_room_direction(position, adj)
		#var other_direction=_get_opposite_direction(direction)
		_create_door_dict(other_room, "other_direction",position-OPPOSITE_VALUE[direction],room_num)


func _find_room_direction(position:Vector2i, adj:int)->String:
	for dir in DIRECTIONS:
		var direction=position+OPPOSITE_VALUE[dir]
		if _game_map[direction.y][direction.x] == adj:
			return dir

	return ""
	
func _create_door_dict(room:Dictionary, direction:String,position:Vector2i, adj:int)->void:
	var doors:Dictionary=room["doors"]

	if doors.has(adj) == false:
		doors[adj] = [{
			#"dir":direction,
			"pos":position,
			"type":"normal",
			"status":"closed"
		}]
	else:
		doors[adj].append( {
			#"dir":direction,
			"pos":position,
			"type":"normal",
			"status":"closed"
		} )


func _get_opposite_direction(dir:String)->String:
	if dir=="north":
		return "south"
	
	if dir=="east":
		return "west"
	
	if dir=="south":
		return "north"
		
	return "east"


func _add_door_to_map(direction:String, door:Vector2i, secret:bool)->void:
	var bit_mask_door:int = 0
	var bit_mask_opposite:int = 0
	var opposite_coord:Vector2i = door+OPPOSITE_VALUE[direction]
	if direction=="north":
		bit_mask_door=1
		bit_mask_opposite=4
	elif direction=="east":
		bit_mask_door=2
		bit_mask_opposite=8
	elif direction=="south":
		bit_mask_door=4
		bit_mask_opposite=1
	else:
		bit_mask_door=8
		bit_mask_opposite=2
		
	if secret==true:
		bit_mask_door<<=4
		bit_mask_opposite<<=4

	_layer_map[door.y][door.x]|=bit_mask_door
	_layer_map[opposite_coord.y][opposite_coord.x]|=bit_mask_opposite


func _get_adjacent_room(direction:String, position:Vector2i)->int:
	var pos:Vector2i=position+OPPOSITE_VALUE[direction]
	return _game_map[pos.y][pos.x]


func _get_rooms_in_group(group:int)->int:
	var count:int=0
	for key in _game_rooms_list:
		if int(_game_rooms_list[key]["group"]) == group:
			count+=1

	return count


func get_room_type(id:int)->int:
	if id==0:
		return ROOM_TYPES.VOID

	return _game_rooms_list[id]["type"]


func _get_rooms_for_group_mask(group_mask:int)->int:
	var bit=1
	var total_rooms=0
	while true:
		if group_mask & bit > 0:
			total_rooms+=_get_rooms_in_group(bit)

		bit <<= 1
		if bit == 0x80000000:
			break

	return total_rooms


func print_game_map() -> void:
	for y in range(_map_mgr._get_map_height()):
		var map_str=""
		for x in range(_map_mgr._get_map_width()):
			map_str += "%02d " % [_game_map[y][x]]

		print(map_str)
	print("----------------------------------------------------------------------------")


func print_layer_map() -> void:
	for y in range(_map_mgr._get_map_height()):
		var map_str=""
		for x in range(_map_mgr._get_map_width()):
			map_str += "%02d " % [_layer_map[y][x]]
			
		print(map_str)
	print("----------------------------------------------------------------------------")


func print_json() -> void:
	var jstr = JSON.stringify(_in_game_rooms)
	print(jstr)


func _print_debug(room:int)->void:
	print("=====================================")
	print("create passageway door in room [%d]" % [room])
	print("_generate_near_center: %s" % [_generate_near_center])
	print("_max_deep: %d" % [_max_deep])
	print("_max_secret_doors: %d" % [_max_secret_doors])
	print("_debug_seed: %d" % [_debug_seed])
	print("_rooms_to_generate: %d" % [_rooms_to_generate])
	print("_group_mask: %d" % [_group_mask])


func _print_astarmap()->void:
	for y in range(_map_mgr._get_map_height()):
		var map_str=""
		for x in range(_map_mgr._get_map_width()):
			if _astar_grid.is_point_solid(Vector2i(x,y)) == true:
				map_str += "%001 "
			else:
				map_str += "%000 "
		print(map_str)
	print("----------------------------------------------------------------------------")


func _point_list(room:int)->void:
	print("La stanza %d è connessa con %s" % [room,_map_points.get_point_connections(room)])
func get_game_map() -> Array:
	return _game_map


func get_layer_map() -> Array:
	return _layer_map


func is_cell_visible(cell:Vector2i) -> bool:
	return (_fog_map[cell.y][cell.x] > 0)
