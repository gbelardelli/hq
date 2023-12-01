extends Control

@onready var item_list = $ItemList

var _quests_list:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.init_game("heroquest")
	var game = GameManager.get_current_game()
	_quests_list=GlobalUtils.get_quests_list(game)
	item_list.clear()
	
	for quest in _quests_list:
		item_list.add_item(quest["title"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	var items = item_list.get_selected_items()
	var quest = _quests_list[items[0]]
	print(quest)
	GameManager.load_quest(quest)
