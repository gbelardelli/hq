extends Control

@onready var title_label = $MC/VBoxContainer/TitleLabel
@onready var description_label = $MC/VBoxContainer/DescriptionLabel
@onready var goal_label = $MC/VBoxContainer/GoalLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	var quest = GameManager.get_active_quest()["quest"]
	title_label.text = quest["title"]
	description_label.text = quest["desc"]
	goal_label.text = quest["goal"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
