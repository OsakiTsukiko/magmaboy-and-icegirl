extends Control

onready var btn_cont = $Panel/CenterContainer/VBoxContainer/BTNCont

func _ready():
	if get_tree().is_network_server():
		btn_cont.visible = true

func _on_RestartBTN_pressed():
	Gamestate.restart_level()

func _on_LevelSelectorBTN_pressed():
	Gamestate.go_to_level_selector()
