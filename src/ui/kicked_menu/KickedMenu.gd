extends Control

var main_menu_scene = load("res://src/ui/main_menu/MainMenu.tscn")

onready var reason_label = $BG/CenterContainer/VBoxContainer/ReasonLabel

func _ready():
	Gamestate.connect("kicked_reason_signal", self, "_kicked_reason_signal")

func _kicked_reason_signal(reason: String):
	reason_label.text = reason

func _on_MainMenuBTN_pressed():
	get_tree().change_scene_to(main_menu_scene)
