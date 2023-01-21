extends Control

var main_menu_scene = load("res://src/ui/main_menu/MainMenu.tscn")

onready var CharacterSelectorINP = $BG/CenterContainer/VBoxContainer/CharacterSelector

func _ready():
	CharacterSelectorINP.add_item("Magma Boy")
	CharacterSelectorINP.add_item("Ice Girl")
	pass

func _on_BackBTN_pressed():
	get_tree().change_scene_to(main_menu_scene)
