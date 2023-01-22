extends Control

var main_menu_scene = load("res://src/ui/main_menu/MainMenu.tscn")

func _on_BackBTN_pressed():
	get_tree().change_scene_to(main_menu_scene)
