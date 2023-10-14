extends Node

var _forniture_dict:Dictionary = {}
var _card_dict:Dictionary = {}
var _monsters_dict:Dictionary = {}
var _game_dict:Dictionary = {}

var _quest_start_scene: PackedScene = preload("res://quest_start/quest_start.tscn")

var _game:String = "heroquest"
var _active_quest:Dictionary = {}

func init_game(game:String):
	_game=game
	_game_dict = GlobalUtils.load_game_options(game)

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
