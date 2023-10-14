extends Node

const MAP_HEIGHT:int  = 19
const MAP_WIDTH:int   = 26
const MAX_HQ_ROOM:int = 22
const MIN_HQ_ROOM:int = 8

const MAP_EMPTY:int = 0
const MAP_PASSAGEWAY:int = 1

const DIRECTIONS:Array = ["north","east","south","west"]
const OPPOSITE_VALUE:Dictionary = { "north" : Vector2i(0,-1), 
									"east" : Vector2i(1,0), 
									"south": Vector2i(0,1), 
									"west" : Vector2i(-1,0) }

var HQMap = [
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

var HQRooms = {
	2: { "coord" : Vector2i(1,1), "size" : 12, "group" : 1, "valid":true, "doors": { } },
	3: { "coord" : Vector2i(5,1), "size" : 12, "group" : 1, "valid":true, "doors": { } },
	4: { "coord" : Vector2i(9,1), "size" : 15, "group" : 1, "valid":true, "doors": { } },
	5: { "coord" : Vector2i(1,4), "size" : 20, "group" : 1, "valid":true, "doors": { } },
	6: { "coord" : Vector2i(5,4), "size" : 20, "group" : 1, "valid":true, "doors": { } },

	7: { "coord" : Vector2i(14,1), "size" : 15, "group" : 2, "valid":true, "doors": { } },
	8: { "coord" : Vector2i(17,1), "size" : 16, "group" : 2, "valid":true, "doors": { } },
	9: { "coord" : Vector2i(21,1), "size" : 16, "group" : 2, "valid":true, "doors": { } },
	10: { "coord" : Vector2i(17,5), "size" : 16, "group" : 2, "valid":true, "doors": { } },
	11: { "coord" : Vector2i(21,5), "size" : 16, "group" : 2, "valid":true, "doors": { } },

	12: { "coord" : Vector2i(17,10), "size" : 15, "group" : 4, "valid":true, "doors": { } },
	13: { "coord" : Vector2i(21,10), "size" : 16, "group" : 4, "valid":true, "doors": { } },
	14: { "coord" : Vector2i(14,13), "size" : 20, "group" : 4, "valid":true, "doors": { } },
	15: { "coord" : Vector2i(18,14), "size" : 12, "group" : 4, "valid":true, "doors": { } },
	16: { "coord" : Vector2i(21,14), "size" : 16, "group" : 4, "valid":true, "doors": { } },

	17: { "coord" : Vector2i(1,10), "size" : 16, "group" : 8, "valid":true, "doors": { } },
	18: { "coord" : Vector2i(5,10), "size" : 6, "group" : 8, "valid":true, "doors": { } },
	19: { "coord" : Vector2i(7,10), "size" : 6, "group" : 8, "valid":true, "doors": { } },
	20: { "coord" : Vector2i(1,14), "size" : 16, "group" : 8, "valid":true, "doors": { } },
	21: { "coord" : Vector2i(5,13), "size" : 20, "group" : 8, "valid":true, "doors": { } },
	22: { "coord" : Vector2i(9,13), "size" : 15, "group" : 8, "valid":true, "doors": { } },

	23: { "coord" : Vector2i(10,7), "size" : 30, "group" : 16, "valid":true, "doors": { } },
}

var _game_map:Array=[]
var _layer_map:Array=[]
var _fog_map:Array=[]

var _in_game_rooms:Dictionary={}
var _doorId:int = 1

'''
Vie di uscita da una stanza:
	Porta
	Porta segreta
	Portale
	Botola ?
'''

func tests() -> void:
	reset_all()
	
	create_room(2)
	create_room(3)
	create_room(4)
	create_room(6)
	
	create_door("east", Vector2i(4,1), 2, _doorId)
	create_door("west", Vector2i(5,1), 3, _doorId)
	_doorId+=1
	create_door("east", Vector2i(8,1), 3,_doorId)
	create_door("west", Vector2i(9,1), 4,_doorId)
	_doorId+=1
	create_door("west", Vector2i(9,5), 4,_doorId)
	create_door("east", Vector2i(8,5), 6,_doorId)
	_doorId+=1
	create_door("north", Vector2i(5,4), 6,_doorId)
	create_door("south", Vector2i(5,3), 3,_doorId)
	print_keys()
	traverse_room(2,[])
	add_passageway(2)
	
func test_traverse(room_num:int)->void:
	traverse_room(room_num,[])

func generate_map(rooms:int) -> void:
	#tests()


	#var HQSolo = Functions.HQSOLO

	generate_rooms(rooms)
	for key in _in_game_rooms:
		traverse_room(key,[])

	print_validity()
	fix_closed_rooms()
	generate_additional_doors()
	print("=================")
	print_validity()
	#print_keys()

func generate_rooms(rooms:int)->void:
	reset_all()
	rooms=clampi(rooms, MIN_HQ_ROOM, MAX_HQ_ROOM)	
	var created_rooms = []
	for i in range(rooms):
		while true:
			var room=randi_range(2,23)
			var founded=false
			for x in created_rooms:
				if x==room:
					founded=true
					break

			if !founded:
				create_room(room)
				created_rooms.append(room)
				break

	var prev_room:Array = []
	for key in _in_game_rooms:
		find_room_borders(key)
		generate_doors(key)


func fix_closed_rooms()->void:
	while true:
		var invalid_rooms:Array = []
		var bigger_room=0
		for key in _in_game_rooms:
			if _in_game_rooms[key]["valid"] == false:
				var room=_in_game_rooms[key]
				invalid_rooms.append(room)
				if room["size"] > bigger_room:
					bigger_room=key

		if bigger_room > 0:
			add_passageway(bigger_room)
			for key in _in_game_rooms:
				traverse_room(key, [])
		else:
			break

func generate_additional_doors()->void:
	for key in _in_game_rooms:
		if _in_game_rooms[key]["size"] >= 16:
			var num_doors = _in_game_rooms[key]["doors"].size()
			if key == 23:
				print("")
			if num_doors < 2:
				var add_door_chance=randi_range(1,100)
				if _in_game_rooms[key]["size"] >= 20:
					if add_door_chance >= 50:
						generate_doors(key)
				else:
					if add_door_chance >= 80:
						generate_doors(key)

		print(key , " -> ", _in_game_rooms[key])
		print("Num doors: ", _in_game_rooms[key]["doors"].size())

func reset_all() -> void:
	print("gamemap reset")
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


func create_room(room_num:int) -> void:
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

	_in_game_rooms[room_num]=HQRooms[room_num]
	var room = _in_game_rooms[room_num]
	room["boundaries"] = {}
	room["boundaries"]["north"] = {}
	room["boundaries"]["east"] = {}
	room["boundaries"]["south"] = {}
	room["boundaries"]["west"] = {}	


func find_room_borders(room_num:int) -> void:
	var room = _in_game_rooms[room_num]

	for y in range(MAP_HEIGHT):
		for x in range(MAP_WIDTH):
			if _game_map[y][x] == room_num:
				resolve_north(x,y,room["boundaries"],room_num)
				resolve_east(x,y,room["boundaries"],room_num)
				resolve_south(x,y,room["boundaries"],room_num)
				resolve_west(x,y,room["boundaries"],room_num)

func resolve_north(x:int, y:int, room:Dictionary,room_num:int)->void:
	var cell=0
	if y>0:
		cell=_game_map[y-1][x]
	
	if cell == room_num:
		return

	var cell_room=room["north"]
	if(  cell_room.has(cell)) == false:
		cell_room[cell] = []
		
	cell_room[cell].append(Vector2i(x,y))

func resolve_east(x:int, y:int, room:Dictionary,room_num:int)->void:
	var cell=0
	if x<MAP_WIDTH:
		cell=_game_map[y][x+1]

	if cell == room_num:
		return

	var cell_room=room["east"]
	if(  cell_room.has(cell)) == false:
		cell_room[cell] = []
		
	cell_room[cell].append(Vector2i(x,y))


func resolve_south(x:int, y:int, room:Dictionary,room_num:int)->void:
	var cell=0
	if y<MAP_HEIGHT:
		cell=_game_map[y+1][x]

	if cell == room_num:
		return

	var cell_room=room["south"]
	if(  cell_room.has(cell)) == false:
		cell_room[cell] = []
		
	cell_room[cell].append(Vector2i(x,y))

func resolve_west(x:int, y:int, room:Dictionary,room_num:int)->void:
	var cell=0
	if x>0:
		cell=_game_map[y][x-1]

	if cell == room_num:
		return

	var cell_room=room["west"]
	if(  cell_room.has(cell)) == false:
		cell_room[cell] = []

	cell_room[cell].append(Vector2i(x,y))

func add_passageway(room_num: int)->bool:
	var room = _in_game_rooms[room_num]["boundaries"]
	for boundary in room:
		for wall in room[boundary]:
			if wall == 1:
				generate_doors(room_num, boundary)
				return true
	
	return true

# Una porta per stanza
func generate_doors(room_num: int, hint_direction="")->void:
	var room = _in_game_rooms[room_num]["boundaries"]
	var direction=""
	var room_walls:Dictionary
	var door_position:Vector2i
	var id=_doorId
	while true:
		if hint_direction != "":
			direction=hint_direction
		else:
			direction=DIRECTIONS.pick_random()
		room_walls=room[direction]
		var adjacent_room=room_walls.keys().pick_random()
		if adjacent_room != MAP_EMPTY:
			if room.has("doors") && room["doors"].has(direction):
				break

			door_position=room_walls[adjacent_room].pick_random()

			if create_door(direction, door_position, room_num, id) == false:
				continue

			# Se metto una porta che connette due stanze devo aggiungerla
			# anche alla stanza connessa
			if adjacent_room != MAP_PASSAGEWAY:
				var opposite_direction=get_opposite_wall_str(direction)
				var opposite_door=door_position+OPPOSITE_VALUE[direction]
				create_door(opposite_direction, opposite_door, adjacent_room, id)

			add_door_to_map(direction,door_position)
			break

	_doorId+=1
	#print("Room: %d direction: %s -> %s" % [room_num, direction, door_position] ) 

func create_door(direction:String, position:Vector2i, room_num:int, id:int)->bool:
	var room = _in_game_rooms[room_num]

	var doors=room["doors"]
	if doors.has(direction) == false:
		doors[direction]={}
	else:
		print("Check door validity")
		# TODO: due porte che danno sul corridoio nella stessa stanza non connessa
		# ad altre stanze
		var door_list=doors[direction]["rooms"]
		var adj_room=get_adjacent_room(direction,position)
		var is_valid_door=true
		for door in door_list:
			if door==adj_room:
				is_valid_door=false
				break
		
		if is_valid_door == false:
			return false

	var dir=doors[direction]
	if dir.is_empty() == true:
		dir["position"] = [position]
		dir["rooms"] = [get_adjacent_room(direction,position)]
		dir["id"] = [id]
	else:
		dir["position"].append(position)
		dir["rooms"].append(get_adjacent_room(direction,position))
		dir["id"].append(id)

	_layer_map[position.y][position.x]=DIRECTIONS.find(direction)+1

	return true

func add_door_to_map(direction:String, door:Vector2i)->void:
	if direction=="north":
		_layer_map[door.y-1][door.x]=3
	elif direction=="east":
		_layer_map[door.y][door.x+1]=4
	elif direction=="south":
		_layer_map[door.y+1][door.x]=1
	else:
		_layer_map[door.y][door.x-1]=2

func get_adjacent_room(direction:String, position:Vector2i)->int:
	if direction=="north":
		return _game_map[position.y-1][position.x]
	if direction=="east":
		return _game_map[position.y][position.x+1]
	if direction=="south":
		return _game_map[position.y+1][position.x]

	return _game_map[position.y][position.x-1]

func traverse_room(room_num: int, prev_rooms:Array)->bool:
	if _in_game_rooms[room_num]["valid"]==true:
		return true

	var doors = _in_game_rooms[room_num]["doors"]
	
	var _loop:bool = false
	var sz=prev_rooms.size()
	var spaces:String=""
	for i in range(0,sz):
		spaces+=" "
	print("%sStart traverse %d" % [spaces, room_num])
	print("%s doors %d" % [spaces, str(doors)])
	for dir in doors:
		print("%sstart dir %s" % [spaces, dir])
		var rooms=doors[dir]["rooms"]
		var ids=doors[dir]["id"]
		var idx:int=0
		for room in rooms:
			print("%sdoor_id %d" % [spaces, ids[idx]])
			print("%sprev_rooms %s" % [spaces, str(prev_rooms)])
			
			if prev_rooms.find(ids[idx]) != -1:
				idx+=1
				continue
			prev_rooms.append(ids[idx])
			print("%sroom: %d door:%d" % [spaces, room,ids[idx]])
			if room == MAP_PASSAGEWAY:
				print("%s Room %d OK" % [spaces,room_num])
				_in_game_rooms[room_num]["valid"] = true
				return true

			if traverse_room(room,prev_rooms) == true:
				_in_game_rooms[room_num]["valid"] = true
				print("%sRoom %d OK" % [spaces,room_num])
				return true

	#prev_rooms.append(room_num)
	print("%sRoom %d KO" % [spaces, room_num])
	_in_game_rooms[room_num]["valid"] = false
	return false

func check_room_validity(room_num: int)->void:
	var room = _in_game_rooms[room_num]
	var founded:bool = false
	var doors = room["doors"]
	for walls in doors:
		for door in doors[walls]:
			if walls=="north":
				if _game_map[door.y-1][door.x] == 1:
					founded=true
					break
			elif walls=="east":
				if _game_map[door.y][door.x+1] == 1:
					founded=true
					break
			elif walls=="south":
				if _game_map[door.y+1][door.x] == 1:
					founded=true
					break
			else:
				if _game_map[door.y][door.x-1] == 1:
					founded=true
					break
		if founded == true:
			break
			
	if founded == true:
		print("Room %d OK" % [room_num])
	else:
		print("Room %d KO" % [room_num])

func get_room_borders(room)->int:
	var num_border=0
	if has_borders(room,"north"):
		num_border+=1
		
	if has_borders(room,"east"):
		num_border+=1

	if has_borders(room,"south"):
		num_border+=1

	if has_borders(room,"west"):
		num_border+=1
	
	return num_border

func has_borders(room, border)->bool:
	for key in room[border]:
		if key > 0:
			return true

	return false


func get_opposite_wall_str(wall:String)->String:
	if wall == "north":
		return "south"
	elif wall == "east":
		return "west"
	elif wall == "south":
		return "north"
		
	return "east"

func print_game_map() -> void:
	for y in range(MAP_HEIGHT):
		var map_str=""
		for x in range(MAP_WIDTH):
			map_str += "%02d " % [_game_map[y][x]]
			
		print(map_str)

func print_keys()->void:
	for key in _in_game_rooms:
		print(key , " -> ", _in_game_rooms[key])

func print_validity()->void:
	for key in _in_game_rooms:
		print(key , " -> ", _in_game_rooms[key]["valid"])

func get_game_map() -> Array:
	return _game_map

func get_layer_map() -> Array:
	return _layer_map
	
func is_cell_visible(cell:Vector2i) -> bool:
	return (_fog_map[cell.y][cell.x] > 0)

