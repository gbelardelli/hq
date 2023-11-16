extends Node

var _forniture_dict:Dictionary = {}
var _card_dict:Dictionary = {}
var _monsters_dict:Dictionary = {}
var _game_dict:Dictionary = {}

var _quest_start_scene: PackedScene = preload("res://quest_start/quest_start.tscn")

var _game:String = ""
var _active_quest:Dictionary = {}

var _map_manager:MapManager = MapManager.new()

func init_game(game:String):
	_game=game
	_game_dict = GlobalUtils.load_game_options(game)

	if _game_dict.has(KeyManager.KEY_GAME_TYPE) == true:
		var game_type = _game_dict[KeyManager.KEY_GAME_TYPE]
		if game_type == "fixed_board":
			var width:int=0
			var height:int=0

			if _game_dict.has(KeyManager.KEY_GAME_BOARD) == true:
				var game_board=_game_dict[KeyManager.KEY_GAME_BOARD]
				width=game_board["width"]
				height=game_board["height"]
			else:
				print("Huston we have a problem! Found a game of type fixed_board without the '%s' key." % [KeyManager.KEY_GAME_BOARD])

			var game_file=GlobalUtils.get_game_data_path(game)+"game_board.dat"
			_map_manager.init_game_map(_load_dict(game_file), width, height, 0)

	if _game_dict.has(KeyManager.KEY_FURNITURE) == true:
		_forniture_dict = GlobalUtils.load_furnitures(game)

	if _game_dict.has(KeyManager.KEY_CARDS) == true:
		_card_dict = GlobalUtils.load_cards(game)

	if _game_dict.has(KeyManager.KEY_MONSTERS) == true:
		_monsters_dict = GlobalUtils.load_monsters(game)

func load_quest(quest:Dictionary)->void:
	_active_quest = GlobalUtils.load_quest(quest["file"], _game)
	get_tree().change_scene_to_packed(_quest_start_scene)
	print("Quest '%s' loaded\n" % [quest["title"]])

func get_current_game()->String:
	return _game

func get_active_quest()->Dictionary:
	return _active_quest

func get_map_manager()->MapManager:
	return _map_manager

func _load_dict(game_file:String)->Dictionary:
	var ret_val:Dictionary
	var file = FileAccess.open(game_file, FileAccess.READ)
	ret_val = file.get_var()
	file.close()
	return ret_val
