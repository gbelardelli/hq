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


func generate_map(rooms:int, min_rooms:int, max_rooms:int,group_mask:int) -> void:
	reset_all()

	if rooms<1:
		rooms=1

	var rooms_in_mask=_get_rooms_for_group_mask(group_mask)
	if rooms > rooms_in_mask:
		rooms=rooms_in_mask

	_generate_rooms(rooms,group_mask)
	_build_paths()
	#_generate_secret_doors(3,20)

	for key in _in_game_rooms:
		var doors=_in_game_rooms[key]["doors"]
		if doors.size() < 1:
			print("Huston we have a problem: the room [%s] has no doors!!" % [key])


func _generate_secret_doors(num_doors:int, chance:int)->void:
	for door in range(0,num_doors):
		if _roll_d100_chance(chance) == true:
			var rooms:Array=_in_game_rooms.keys()

			# Un stanza può avere max 1 porta segreta
			var room=0
			while  true:
				room=rooms.pick_random()
				if _has_secret_doors(room) == false:
					break

			var doors:Dictionary=_in_game_rooms[room]["doors"]
			for dir in doors:
				var doors_wall=doors[dir]["position"]
				var chosed_door=doors_wall.pick_random()
				# Prende a caso la stanza confinante
				var other_room=doors[dir]["rooms"].pick_random()
				var idx=doors[dir]["rooms"].find(other_room)
				if idx==-1:
					print("Huston we have a problem: the door does not exists!!")
					return
					
				doors[dir]["type"][idx]="secret"
				print("Porta segreta: stanza [%d] confine [%d] pos [%s] dir[%s]" % [room,other_room,chosed_door,dir])
				break



func _build_paths()->void:
	var keys:Array=_in_game_rooms.keys()
	var visited_rooms=[]
	var room:int=0
	var neighbor_info=_build_neighbor_info()
	while true:
		while true:
			room=keys.pick_random()
			if visited_rooms.find(room) == -1:
				visited_rooms.append(room)
				break

		_traverse_map(room, 1, neighbor_info, [])
		if visited_rooms.size() == keys.size():
			break


func _traverse_map(room_num:int, deep:int, neighbor_info:Dictionary, walk_history:Array)->void:
	var room:Dictionary=_in_game_rooms[room_num]
	if room["valid"] == true or deep > 4:
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
		#if deep>1:
		#	_remove_passageway_doors(room_num, room)

		return

	walk_history.append(room_num)
	var neighbor_room = neighbor_rooms.pick_random()
	room["valid"]=true
	var leftovers_doors:int = 0

	#if deep>1:
	#	leftovers_doors=_remove_passageway_doors(room_num, room)

	deep+=1
	_add_door(room_num, neighbor_room)
	_traverse_map(neighbor_room,deep,neighbor_info,walk_history)


func _walk(room_num:int, neighbor_info:Dictionary, visited:Array)->void:
	var neighbor_rooms:Array=neighbor_info[room_num]

	# Rimuovo dalla lista delle stanze vicine, quelle già visitate
	for room in visited:
		while true:
			var idx:int = neighbor_rooms.find(room)
			if idx != -1:
				neighbor_rooms.remove_at(idx)
			else:
				break



func _remove_passageway_doors(room_num:int, room:Dictionary)->int:
	var passageways:Dictionary = {}
	var doors_list=room["doors"]
	for dir in doors_list:
		for door in doors_list[dir]["rooms"]:
			if door == MAP_PASSAGEWAY:
				passageways[dir] = doors_list[dir]["position"]

	var keys=passageways.keys()
	var chance=100-(25*keys.size())
	var to_remove=keys.size()-1
	
	for i in to_remove:
		_remove_door(room_num,passageways)
	
	if _roll_d100_chance(chance) == true:
		_remove_door(room_num, passageways)

	return 0


func _remove_door(room_num:int, passageways:Dictionary)->void:
	var room=_in_game_rooms[room_num]
	var doors=room["doors"]

	var direction=passageways.keys().pick_random()
	doors.erase(direction)
	var coord=passageways[direction][0]
	#passageways.erase(direction)
	print("Removed door at [%s] dir[%s] room[%s]" % [coord,direction,room_num])

	_remove_door_from_map(direction, coord)


func _remove_door_from_map(direction:String, door:Vector2i)->void:
	if direction=="north":
		_layer_map[door.y][door.x]-=1
		_layer_map[door.y-1][door.x]-=4
	elif direction=="east":
		_layer_map[door.y][door.x]-=2
		_layer_map[door.y][door.x+1]-=8
	elif direction=="south":
		_layer_map[door.y][door.x]-=4
		_layer_map[door.y+1][door.x]-=1
	else:
		_layer_map[door.y][door.x]-=8
		_layer_map[door.y][door.x-1]-=2


func _roll_d100_chance(percent:int)->bool:
	if randi_range(1,100) < percent:
		return true
	
	return false


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
	var door_coord=room_boundaries[direction].pick_random()

	_create_door(direction, door_coord, main_room)


func _has_secret_doors(room_num:int)->bool:
	var doors:Dictionary=_in_game_rooms[room_num]["doors"]
	for dir in doors:
		var door_wall=doors[dir]
		for door in door_wall["type"]:
			if door=="secret":
				return true

	return false


func _generate_rooms(rooms:int,group_id:int)->void:
	var created_rooms = []
	for i in range(rooms):
		var count=0
		while true:
			var room=randi_range(2,23)
			count+=1
			if count >= 10000:
				print("***************************************")
				break
			if _game_rooms_list[room]["group"] & group_id == 0:
				continue

			if created_rooms.find(room) == -1:
				_create_room(room)
				created_rooms.append(room)
				break

	for key in _in_game_rooms:
		_find_room_boundaries(key)
		_create_passageway_door(key)


func reset_all() -> void:
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

	for key in _game_rooms_list:
		_game_rooms_list[key]["doors"] = {}
		_game_rooms_list[key]["boundaries"] = {}
		_game_rooms_list[key]["valid"] = false


# Copia sulla _game_map la room generata prendendola
# da HQMap. Il ciclo continua per tutta la mappa, così è
# possibile avere room di qualsiasi forma
func _create_room(room_num:int) -> void:
	var room_cells=0
	for y in range(MAP_HEIGHT):
		var cells_founded=0
		for x in range(MAP_WIDTH):
			if HQMap[y][x] == room_num:
				_game_map[y][x] = room_num
				room_cells += 1
				cells_founded+=1
			elif HQMap[y][x] == 1:
				_game_map[y][x] = 1

		if room_cells >= 1 and cells_founded == 0:
			break

	# Copia le info della room e aggiunge i boundaries che servono
	# poi per creare le porte sulle pareti
	_in_game_rooms[room_num]=_game_rooms_list[room_num]
	var room = _in_game_rooms[room_num]
	room[BOUNDARIES_KEY] = {}
	room[BOUNDARIES_KEY]["north"] = {}
	room[BOUNDARIES_KEY]["east"] = {}
	room[BOUNDARIES_KEY]["south"] = {}
	room[BOUNDARIES_KEY]["west"] = {}	


func _find_room_boundaries(room_num:int) -> void:
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
			if wall == MAP_PASSAGEWAY:
				random_corridor_wall.append( { dir: room[dir][MAP_PASSAGEWAY] })

	var prev_dir:Array = []
	var total_doors:int=0
	while true:
		var room_walls:Dictionary = random_corridor_wall.pick_random()
		var dir = room_walls.keys()[0]
		if prev_dir.find(dir) != -1:
			continue

		prev_dir.append(dir)
		var door_position:Vector2i=room_walls[dir].pick_random()

		_create_door(dir, door_position, room_num)
		total_doors+=1

		if random_corridor_wall.size() > 1 && prev_dir.size() < random_corridor_wall.size():
			if _can_add_door(room_num,total_doors) == true:
				continue

		break


func _can_add_door(room_num:int,modifier:int)->bool:
	var d100=randi_range(1,100)
	var chance:int=0
	var room_size:int = _in_game_rooms[room_num]["size"]
	if room_size < 10:
		chance = 10 - (modifier*5)
	elif room_size < 15:
		chance = 20 - (modifier*6)
	elif room_size < 25:
		chance = 30 - (modifier*7)
	else:
		chance = 60 - (modifier*2)

	return _roll_d100_chance(chance)


func _create_door(direction:String, position:Vector2i, room_num:int)->void:
	var room = _in_game_rooms[room_num]
	var adj=_get_adjacent_room(direction,position)
	
	_create_door_dict(room, direction,position,adj)
	if adj != MAP_PASSAGEWAY:
		var other_room=_in_game_rooms[adj]
		var other_doors=other_room["doors"]
		var other_direction=_get_opposite_direction(direction)
		_create_door_dict(other_room, other_direction,position+OPPOSITE_VALUE[direction],room_num)

	_add_door_to_map(direction,position)


func _create_door_dict(room:Dictionary, direction:String,position:Vector2i, adj:int)->void:
	var doors=room["doors"]
	if doors.has(direction) == false:
		doors[direction]={}

	var dir=doors[direction]
	if dir.is_empty() == true:
		dir["position"] = [position]
		dir["rooms"] = [adj]
		dir["type"] = ["normal"]
	else:
		dir["position"].append(position)
		dir["rooms"].append(adj)
		dir["type"].append("normal")


func _get_opposite_direction(dir:String)->String:
	if dir=="north":
		return "south"
	
	if dir=="east":
		return "west"
	
	if dir=="south":
		return "north"
		
	return "east"

func _add_door_to_map(direction:String, door:Vector2i)->void:
	if direction=="north":
		_layer_map[door.y][door.x]|=1
		_layer_map[door.y-1][door.x]|=4
	elif direction=="east":
		_layer_map[door.y][door.x]|=2
		_layer_map[door.y][door.x+1]|=8
	elif direction=="south":
		_layer_map[door.y][door.x]|=4
		_layer_map[door.y+1][door.x]|=1
	else:
		_layer_map[door.y][door.x]|=8
		_layer_map[door.y][door.x-1]|=2


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

func print_validity()->void:
	for key in _in_game_rooms:
		print(key , " -> ", _in_game_rooms[key]["valid"])

func print_total_doors() -> void:
	var tot=0
	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			if _layer_map[y][x] != 0:
				tot+=1
			
	print("Porte totali: %d" % [tot/2])

func print_json() -> void:
	var jstr = JSON.stringify(_in_game_rooms)
	print(jstr)

func get_game_map() -> Array:
	return _game_map

func get_layer_map() -> Array:
	return _layer_map
	
func is_cell_visible(cell:Vector2i) -> bool:
	return (_fog_map[cell.y][cell.x] > 0)

func tests() -> void:
	reset_all()
	
	_create_room(2)
	_create_room(3)
	_create_room(4)
	_create_room(6)

	for key in _in_game_rooms:
		_find_room_boundaries(key)
		_create_passageway_door(key)
