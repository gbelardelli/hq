class_name Utils extends Node

const FILE_EXTENSION:String = ".json"


func load_furnitures(game:String)->Dictionary:
	var path = _build_data_path(game, KeyManager.KEY_FURNITURE)
	var data = _load_json(path)

	if _check_game(data,game) == true:
		return data

	return {}

func load_cards(game:String)->Dictionary:
	var path = _build_data_path(game, KeyManager.KEY_CARDS)
	var data = _load_json(path)

	if _check_game(data,game) == true:
		return data

	return {}

func load_monsters(game:String)->Dictionary:
	var path = _build_data_path(game, KeyManager.KEY_MONSTERS)
	var data = _load_json(path)

	if _check_game(data,game) == true:
		return data

	return {}

func load_game_options(game:String)->Dictionary:
	var path = _build_data_path(game, KeyManager.KEY_OPTIONS)
	var data = _load_json(path)

	if _check_game(data,game) == true:
		return data

	return {}

func _build_data_path(game:String, type:String)->String:
	return "games/" + game + "/data/" + type + FILE_EXTENSION

func _build_quests_path(game:String)->String:
	return "games/" + game + "/quests/"

func get_game_path(game:String)->String:
	return "games/" + game

func get_game_data_path(game:String)->String:
	return get_game_path(game) + "/data/"

func _load_json(path:String)->Dictionary:
	if not FileAccess.file_exists(path):
		print("Huston we have a problem! File '%s' not exists\n" % [path])
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	return data

func _check_game(data:Dictionary, game:String)->bool:
	if data.has(KeyManager.KEY_GAME_TOKEN) == false:
		print("Key 'game' not found in: ", data)
		return false
		
	if data[KeyManager.KEY_GAME_TOKEN] == game:
		return true
	
	print("File has different token: requested '%s' founded '%s'" % [game, data[KeyManager.KEY_GAME_TOKEN] ])
	return false

func load_quest(file:String, game:String)->Dictionary:
	var path=_build_quests_path(game)+file
	return _load_json(path)

func get_quests_list(game:String)->Array:
	var result:Array = []
	var dir_path=_build_quests_path(game)
	var dir=DirAccess.open(_build_quests_path(game))
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() == false:
				var path=dir_path+file_name
				print("Found file: " + path)
				var quest=_load_json(path)
				if _check_game(quest,game) == true:
					var dict:Dictionary = {
						"title":quest["quest"]["title"],
						"quest_token":quest["quest"]["quest_token"],
						"file":file_name
					}
					result.append(dict)

			file_name = dir.get_next()
	else:
		print("Huston we have a problem! An error occurred when trying to access the path '%s'" %[dir_path])
	
	return result

func roll_d100_chance(percent:int)->bool:
	if randi_range(1,100) < percent:
		return true
	
	return false

func roll_dice(sides:int)->int:
	var sum=0
	for i in range(0,4):
		sum+=randi_range(1,sides)
	
	return int(sum/4)

