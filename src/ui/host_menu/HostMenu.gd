extends Control

var main_menu_scene = load("res://src/ui/main_menu/MainMenu.tscn")

onready var host_btn = $BG/CenterContainer/VBoxContainer/HostBTN
onready var character_selector_input = $BG/CenterContainer/VBoxContainer/CharacterSelector
onready var error_label = $BG/CenterContainer/VBoxContainer/ErrorLabel
onready var username_input = $BG/CenterContainer/VBoxContainer/GridContainer/Username
onready var port_input = $BG/CenterContainer/VBoxContainer/GridContainer/Port

func _ready() -> void:
	character_selector_input.add_item("Magma Boy")
	character_selector_input.add_item("Ice Girl")

func show_error(msg: String) -> void:
	error_label.text = "Error: " + msg

func _on_HostBTN_pressed() -> void:
	var username: String = username_input.text
	var port: int = int(port_input.text)
	
	host_btn.disabled = true
	
	if (username.replace(" ", "") == ""):
		show_error("Invalid username!")
		host_btn.disabled = false
		return
	
	Gamestate.init_server(
		username, 
		character_selector_input.selected,
		port
	)

func _on_BackBTN_pressed() -> void:
	get_tree().change_scene_to(main_menu_scene)
