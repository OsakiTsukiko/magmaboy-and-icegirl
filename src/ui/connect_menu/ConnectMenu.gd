extends Control

var main_menu_scene = load("res://src/ui/main_menu/MainMenu.tscn")

onready var back_btn: Node = $BG/BackBTN
onready var connect_btn: Node = $BG/CenterContainer/VBoxContainer/ConnectBTN
onready var error_label: Node = $BG/CenterContainer/VBoxContainer/ErrorLabel
onready var username_input: Node = $BG/CenterContainer/VBoxContainer/GridContainer/Username
onready var ip_input: Node = $BG/CenterContainer/VBoxContainer/GridContainer/IP
onready var port_input: Node = $BG/CenterContainer/VBoxContainer/GridContainer/Port

func _ready():
	Gamestate.connect("connect_error_scene_signal", self, "show_error")

func show_error(msg: String) -> void:
	error_label.text = "Error: " + msg

func _on_ConnectBTN_pressed():
	var username: String = username_input.text
	var ip: String = ip_input.text
	var port: int = int(port_input.text)
	
	connect_btn.disabled = true
	back_btn.disabled = true
	
	if (username.replace(" ", "") == ""):
		show_error("Invalid username!")
		connect_btn.disabled = false
		back_btn.disabled = false
		return
	
	if (ip.replace(" ", "") == ""):
		show_error("Invalid IP!")
		connect_btn.disabled = false
		back_btn.disabled = false
		return
	
	Gamestate.init_client(
		username,
		ip,
		port
	)

func _on_BackBTN_pressed() -> void:
	get_tree().change_scene_to(main_menu_scene)
