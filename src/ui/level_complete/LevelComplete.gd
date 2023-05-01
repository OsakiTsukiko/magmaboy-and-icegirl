extends Control

onready var btn_cont = $Panel/CenterContainer/VBoxContainer/BTNCont
onready var lava_diamond_label = $Panel/CenterContainer/VBoxContainer/HBoxContainer/LavaDiamondLabel
onready var water_diamond_label = $Panel/CenterContainer/VBoxContainer/HBoxContainer/WaterDiamondLabel

func _ready():
	if get_tree().is_network_server():
		btn_cont.visible = true
	lava_diamond_label.text = ": " + String(Gamestate.lava_diamonds)
	water_diamond_label.text = String(Gamestate.water_diamonds) + " :"

func _on_RestartBTN_pressed():
	Gamestate.restart_level()

func _on_LevelSelectorBTN_pressed():
	Gamestate.go_to_level_selector()
