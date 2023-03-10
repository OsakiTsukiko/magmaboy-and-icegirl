extends Control

var level_btn_scene: Resource = load("res://src/ui/level_selector/LevelBTN.tscn")

onready var level_cont: Node = $BG/VBoxContainer/CenterContainer/Panel/MarginContainer/ScrollContainer/LevelCont

func _ready() -> void:
	for i in Gamestate.levels.size():
		var level: Utils.Level = Gamestate.levels[i]
		var level_btn: Node = level_btn_scene.instance()
		level_cont.add_child(level_btn)
		level_btn.init(
			level.name,
			level.banner,
			self,
			"_select_btn",
			i
		)

func _select_btn(level_id: int) -> void:
	Gamestate.start_level(level_id)
