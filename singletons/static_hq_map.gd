extends Node

const MAP_HEIGHT:int  = 19
const MAP_WIDTH:int   = 26

const MAP_EMPTY:int = 0
const MAP_PASSAGEWAY:int = 1

const DIRECTIONS:Array = ["north","east","south","west"]
const OPPOSITE_VALUE:Dictionary = { "north" : Vector2i(0,-1), 
									"east" : Vector2i(1,0), 
									"south": Vector2i(0,1), 
									"west" : Vector2i(-1,0) }

const BOUNDARIES_KEY:String = "boundaries"

const HQMap = [
	[001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001],
	[001,002,002,002,002,003,003,003,003,004,004,004,001,001,007,007,007,008,008,008,008,009,009,009,009,001],
	[001,002,002,002,002,003,003,003,003,004,004,004,001,001,007,007,007,008,008,008,008,009,009,009,009,001],
	[001,002,002,002,002,003,003,003,003,004,004,004,001,001,007,007,007,008,008,008,008,009,009,009,009,001],
	[001,005,005,005,005,006,006,006,006,004,004,004,001,001,007,007,007,008,008,008,008,009,009,009,009,001],
	[001,005,005,005,005,006,006,006,006,004,004,004,001,001,007,007,007,010,010,010,010,011,011,011,011,001],
	[001,005,005,005,005,006,006,006,006,001,001,001,001,001,001,001,001,010,010,010,010,011,011,011,011,001],
	[001,005,005,005,005,006,006,006,006,001,023,023,023,023,023,023,001,010,010,010,010,011,011,011,011,001],
	[001,005,005,005,005,006,006,006,006,001,023,023,023,023,023,023,001,010,010,010,010,011,011,011,011,001],
	[001,001,001,001,001,001,001,001,001,001,023,023,023,023,023,023,001,001,001,001,001,001,001,001,001,001],
	[001,017,017,017,017,018,018,019,019,001,023,023,023,023,023,023,001,012,012,012,012,013,013,013,013,001],
	[001,017,017,017,017,018,018,019,019,001,023,023,023,023,023,023,001,012,012,012,012,013,013,013,013,001],
	[001,017,017,017,017,018,018,019,019,001,001,001,001,001,001,001,001,012,012,012,012,013,013,013,013,001],
	[001,017,017,017,017,021,021,021,021,022,022,022,001,001,014,014,014,014,012,012,012,013,013,013,013,001],
	[001,020,020,020,020,021,021,021,021,022,022,022,001,001,014,014,014,014,015,015,015,016,016,016,016,001],
	[001,020,020,020,020,021,021,021,021,022,022,022,001,001,014,014,014,014,015,015,015,016,016,016,016,001],
	[001,020,020,020,020,021,021,021,021,022,022,022,001,001,014,014,014,014,015,015,015,016,016,016,016,001],
	[001,020,020,020,020,021,021,021,021,022,022,022,001,001,014,014,014,014,015,015,015,016,016,016,016,001],
	[001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001,001]
]


var _game_rooms_list = {
	2: { "coord" : Vector2i(1,1), "size" : 12, "group" : 1, "valid":false, "doors": { } },
	3: { "coord" : Vector2i(5,1), "size" : 12, "group" : 1, "valid":false, "doors": { } },
	4: { "coord" : Vector2i(9,1), "size" : 15, "group" : 1, "valid":false, "doors": { } },
	5: { "coord" : Vector2i(1,4), "size" : 20, "group" : 1, "valid":false, "doors": { } },
	6: { "coord" : Vector2i(5,4), "size" : 20, "group" : 1, "valid":false, "doors": { } },

	7: { "coord" : Vector2i(14,1), "size" : 15, "group" : 2, "valid":false, "doors": { } },
	8: { "coord" : Vector2i(17,1), "size" : 16, "group" : 2, "valid":false, "doors": { } },
	9: { "coord" : Vector2i(21,1), "size" : 16, "group" : 2, "valid":false, "doors": { } },
	10: { "coord" : Vector2i(17,5), "size" : 16, "group" : 2, "valid":false, "doors": { } },
	11: { "coord" : Vector2i(21,5), "size" : 16, "group" : 2, "valid":false, "doors": { } },

	12: { "coord" : Vector2i(17,10), "size" : 15, "group" : 4, "valid":false, "doors": { } },
	13: { "coord" : Vector2i(21,10), "size" : 16, "group" : 4, "valid":false, "doors": { } },
	14: { "coord" : Vector2i(14,13), "size" : 20, "group" : 4, "valid":false, "doors": { } },
	15: { "coord" : Vector2i(18,14), "size" : 12, "group" : 4, "valid":false, "doors": { } },
	16: { "coord" : Vector2i(21,14), "size" : 16, "group" : 4, "valid":false, "doors": { } },

	17: { "coord" : Vector2i(1,10), "size" : 16, "group" : 8, "valid":false, "doors": { } },
	18: { "coord" : Vector2i(5,10), "size" : 6, "group" : 8, "valid":false, "doors": { } },
	19: { "coord" : Vector2i(7,10), "size" : 6, "group" : 8, "valid":false, "doors": { } },
	20: { "coord" : Vector2i(1,14), "size" : 16, "group" : 8, "valid":false, "doors": { } },
	21: { "coord" : Vector2i(5,13), "size" : 20, "group" : 8, "valid":false, "doors": { } },
	22: { "coord" : Vector2i(9,13), "size" : 15, "group" : 8, "valid":false, "doors": { } },

	23: { "coord" : Vector2i(10,7), "size" : 30, "group" : 16, "valid":false, "doors": { } },
}

var _game_map:Array=[]
var _layer_map:Array=[]
var _fog_map:Array=[]

var _in_game_rooms:Dictionary={}
var _doorId:int = 1

var _astar_grid = AStarGrid2D.new()

# Generation parameters
var _generate_near_center:bool = true
var _max_deep:int = 3
var _max_secret_doors:int = 5
var _chance_of_secret_door:int = 90
var _debug_seed:int = 0
var _rooms_to_generate:int = 0
var _group_mask:int = 0

func generate_map(rooms:int, secret_doors:int, near_center:bool,group_mask:int, debug_seed:int) -> bool:
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
			_print_debug(no_exit_rooms[0])
			_create_passageway_door(no_exit_rooms[0])
		else:
			break
			
		if force_exit>200:
			print("Huston we have a serious problem! We can't fix rooms exits" % [no_exit_rooms])
			break

	_update_game_map()
	_get_passageway_doors_list()

	return true

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

			if door > MAP_PASSAGEWAY:
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

	if door <= MAP_PASSAGEWAY:
		# Prendere le porte di questa stanza ad esclusione di quella di entrata
		# Per ogni porta controllare se le stanze adiacenti hanno uno sbocco
		var rooms:Array = doors.keys()
		var exit_rooms:Dictionary = {}
		var exits_rooms:Array = []
		for room in rooms:
			if room <= MAP_PASSAGEWAY:
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

	#TODO: i corridoi potrebbero non essere identificati solo con 1
	if doors.has(1):
		#print("La stanza [%d] con PS ha sbocchi diretti su 1" % [room_num])
		for room in keys:
			if room > MAP_PASSAGEWAY:
				var exits=[]
				if _find_exits(room, [room_num], exits) > 0:
					if GlobalUtils.roll_d100_chance(50) == true:
						#print("Elimino l'uscita sul corridoio della stanza [%d]" % [room_num])
						_remove_passageway_doors(room_num, _in_game_rooms[room_num])
						break
					else:
						#print("Elimino le uscite sul corridoio delle stanze %s" % [exits])
						for exit in exits:
							_remove_passageway_doors(exit, _in_game_rooms[exit])
	else:
		#print("La stanza [%d] con PS NON ha sbocchi diretti su 1" % [room_num])
		for room in keys:
			if room <= MAP_PASSAGEWAY:
				#print("La stanza [%d] ha un uscita su 1 posso togliere la porta non segreta dalla stanza [%d]" % [room,room_num])
				_remove_normal_doors(room,room_num)
			else:
				var exits=[]
				if _find_exits(room, [room_num], exits) > 0:
					#print("La stanza [%d] ha un uscita su 1" % [room])
					#print("Posso eliminare la porta non segreta tra la stanza [%d] e la stanza [%d]" % [room_num,room])
					_remove_normal_doors(room,room_num)


func _remove_normal_doors(room_num:int, adj:int=0)->void:
	var doors:Dictionary=_in_game_rooms[room_num]["doors"]
	var to_delete:Array = []

	for room in doors:
		for door in doors[room]:
			if door["type"] == "normal":
				var other_room=_get_adjacent_room(door["dir"], door["pos"])
				if other_room > MAP_PASSAGEWAY:
					if adj==0 or adj==other_room:
						var other_doors=_in_game_rooms[other_room]["doors"]
						other_doors.erase(room_num)
				if adj==0 or adj==other_room:
					to_delete.append(door)
				#print("   remove normal door from [%d]" % [room_num])

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

		#print("Start traverse room [%d] doors [%s]" % [room, _in_game_rooms[room]["doors"]])
		_traverse_map(room, 1, neighbor_info, [])
		if visited_rooms.size() == keys.size():
			break


func _traverse_map(room_num:int, deep:int, neighbor_info:Dictionary, walk_history:Array)->void:
	var room:Dictionary=_in_game_rooms[room_num]
	if room["valid"] == true:
		#print("   End traverse room [%d] room is valid" % [room_num])
		return

	if deep > _max_deep:
		#print("   Max deep reached on room [%d]" % [room_num])
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
		#print("   End traverse room [%d] no neighbor found. Deep [%d]" % [room_num, deep])
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
		if room <= MAP_PASSAGEWAY:
			for door in doors[room]:
				if door["type"] == "normal":
					#print("   Remove passageway door on room [%d] door [%s]" % [room_num, door])
					to_delete.append(door)

	for door in to_delete:
		if door in doors[1]:
			doors[1].erase(door)

	if doors.has(1) && doors[1].size() == 0:
		doors.erase(1)


func _find_exits(room_num:int, visited:Array, exits:Array)->int:
	var doors:Dictionary=_in_game_rooms[room_num]["doors"]
	var cnt=0
	for room in doors:
		if room in visited:
			continue

		if room <= MAP_PASSAGEWAY:
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
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			if _game_map[y][x] <= MAP_PASSAGEWAY && _layer_map[y][x] != 0:
				doors_list.append(Vector2i(x,y))

	print_game_map()
	print_layer_map()
	return doors_list


func _build_neighbor_info()->Dictionary:
	var neighbor_info={}

	for key in _in_game_rooms:
		neighbor_info[key] = _get_neighbor_rooms(_in_game_rooms[key])

	return neighbor_info


func _get_neighbor_rooms(room:Dictionary)->Array:
	var neighbor_rooms=[]
	var boundaries=room["boundaries"]
	for dir in boundaries:
		var walls=boundaries[dir]
		for wall in walls:
			if wall > MAP_PASSAGEWAY:
				neighbor_rooms.append(wall)

	return neighbor_rooms


func _add_door(main_room:int, other_room:int)->void:
	if _has_secret_doors(main_room) == true:
		return

	var room_boundaries={}
	var boundaries:Dictionary=_in_game_rooms[main_room]["boundaries"]
	for dir in boundaries:
		var walls=boundaries[dir]
		for wall in walls:
			if wall == other_room:
				room_boundaries[dir]=walls[wall]

	var direction = room_boundaries.keys().pick_random()
	var door_coord:Vector2i
	if _generate_near_center == true:
		var idx=room_boundaries[direction].size()
		idx = idx / 2
		door_coord=room_boundaries[direction][idx]
	else:
		door_coord=room_boundaries[direction].pick_random()
	_create_door(direction, door_coord, main_room)


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
			var room=randi_range(2,23)
			if _game_rooms_list[room]["group"] & group_id == 0:
				continue

			if room not in created_rooms:
				_create_room(room)
				created_rooms.append(room)
				break

	for key in _in_game_rooms:
		_resolve_room_boundaries(key)
		_create_passageway_door(key)


func reset_all() -> void:
	_astar_grid = AStarGrid2D.new()
	_astar_grid.cell_size = Vector2(1, 1)
	_astar_grid.region = Rect2i(0, 0, MAP_WIDTH, MAP_HEIGHT)
	_doorId=1
	_game_map=[]
	_layer_map=[]
	_fog_map=[]
	_in_game_rooms={}

	for y in range(MAP_HEIGHT):
		_game_map.append([])
		_layer_map.append([])
		_fog_map.append([])

		_game_map[y].resize(MAP_WIDTH)
		_layer_map[y].resize(MAP_WIDTH)
		_fog_map[y].resize(MAP_WIDTH)

		for x in range(MAP_WIDTH):
			_game_map[y][x] = 0
			_layer_map[y][x] = 0
			_fog_map[y][x] = 0
			_astar_grid.set_point_solid(Vector2i(x,y),true)

	for key in _game_rooms_list:
		_game_rooms_list[key]["doors"] = {}
		_game_rooms_list[key]["boundaries"] = {}
		_game_rooms_list[key]["valid"] = false


# Copia sulla _game_map la room generata prendendola
# da HQMap. Il ciclo continua per tutta la mappa, così è
# possibile avere room di qualsiasi forma
func _create_room(room_num:int) -> void:
	var room_cells:int=0
	for y in range(MAP_HEIGHT):
		var cells_founded:int=0
		for x in range(MAP_WIDTH):
			if HQMap[y][x] == room_num:
				_game_map[y][x] = room_num
				room_cells += 1
				cells_founded+=1
			elif HQMap[y][x] == 1:
				_game_map[y][x] = 1
				_astar_grid.set_point_solid(Vector2i(x,y),false)

		if room_cells >= 1 and cells_founded == 0:
			break

	# Copia le info della room e aggiunge i boundaries che servono
	# poi per creare le porte sulle pareti
	_in_game_rooms[room_num]=_game_rooms_list[room_num]
	var room:Dictionary = _in_game_rooms[room_num]
	room[BOUNDARIES_KEY] = {}
	room[BOUNDARIES_KEY]["north"] = {}
	room[BOUNDARIES_KEY]["east"] = {}
	room[BOUNDARIES_KEY]["south"] = {}
	room[BOUNDARIES_KEY]["west"] = {}	


func _resolve_room_boundaries(room_num:int) -> void:
	var room = _in_game_rooms[room_num][BOUNDARIES_KEY]
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			if _game_map[y][x] == room_num:
				_resolve_boundaries(Vector2i(x,y),room,room_num)


func _resolve_boundaries(cell_pos:Vector2i, room:Dictionary,room_num:int)->void:
	for dir in DIRECTIONS:
		var pos:Vector2i=cell_pos+OPPOSITE_VALUE[dir]
		var cell=_game_map[pos.y][pos.x]

		if cell == room_num:
			continue

		var cell_room=room[dir]
		if(  cell_room.has(cell)) == false:
			cell_room[cell] = []

		cell_room[cell].append(cell_pos)


func _create_passageway_door(room_num: int)->void:
	var room = _in_game_rooms[room_num]["boundaries"]
	var random_corridor_wall=[]

	for dir in DIRECTIONS:
		for wall in room[dir]:
			if wall > 0 && wall <= MAP_PASSAGEWAY:
				random_corridor_wall.append( { dir: room[dir][MAP_PASSAGEWAY] })

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
	var room_size:int = _in_game_rooms[room_num]["size"]
	if room_size < 10:
		chance = 5 - (modifier*5)
	elif room_size < 15:
		chance = 10 - (modifier*6)
	elif room_size < 25:
		chance = 20 - (modifier*7)
	else:
		chance = 80 - (modifier*2)

	return GlobalUtils.roll_d100_chance(chance)


func _create_door(direction:String, position:Vector2i, room_num:int)->void:
	var room = _in_game_rooms[room_num]
	var adj=_get_adjacent_room(direction,position)

	_create_door_dict(room, direction,position,adj)
	if adj > MAP_PASSAGEWAY:
		var other_room=_in_game_rooms[adj]
		var other_direction=_get_opposite_direction(direction)
		_create_door_dict(other_room, other_direction,position+OPPOSITE_VALUE[direction],room_num)


func _create_door_dict(room:Dictionary, direction:String,position:Vector2i, adj:int)->void:
	var doors:Dictionary=room["doors"]

	if doors.has(adj) == false:
		doors[adj] = [{
			"dir":direction,
			"pos":position,
			"type":"normal"
		}]
	else:
		doors[adj].append( {
			"dir":direction,
			"pos":position,
			"type":"normal"
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
		if _game_rooms_list[key]["group"] == group:
			count+=1

	return count


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
	for y in range(MAP_HEIGHT):
		var map_str=""
		for x in range(MAP_WIDTH):
			map_str += "%02d " % [_game_map[y][x]]
			
		print(map_str)
	print("----------------------------------------------------------------------------")

func print_layer_map() -> void:
	for y in range(MAP_HEIGHT):
		var map_str=""
		for x in range(MAP_WIDTH):
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


func get_game_map() -> Array:
	return _game_map


func get_layer_map() -> Array:
	return _layer_map
	

func is_cell_visible(cell:Vector2i) -> bool:
	return (_fog_map[cell.y][cell.x] > 0)


func _build_paths_test(room_sequence:Array)->void:
	var keys:Array=_in_game_rooms.keys()
	var visited_rooms=[]
	var neighbor_info=_build_neighbor_info()
	#print(neighbor_info)

	for room in room_sequence:
		if room not in visited_rooms:
			visited_rooms.append(room)

		print("Start traverse room [%d] doors [%s]" % [room, _in_game_rooms[room]["doors"]])
		_traverse_map(room, 1, neighbor_info, [])


func tests() -> void:
	reset_all()
	
	_create_room(23)

	for key in _in_game_rooms:
		_resolve_room_boundaries(key)

	_create_door("west", Vector2i(18, 13), 12)
	_create_door("south", Vector2i(19, 13), 12)
	_create_door("north", Vector2i(15,13), 14)
	_create_door("east", Vector2i(19, 17), 15)
