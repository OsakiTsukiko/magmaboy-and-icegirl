extends Node2D

onready var ig_spawner = $IGSpawner
onready var mb_spawner = $MBSpawner
onready var pause_menu = $CanvasLayer/PauseMenu

var player_scene: Resource = load("res://src/utils/player/Player.tscn")

var players: Array = []

var is_paused: bool = false

func _ready():
	Gamestate.connect("player_tick_signal", self, "_player_tick_signal")
	Gamestate.connect("pause_game_signal", self, "_pause_game_signal")
	Gamestate.connect("resume_game_signal", self, "_resume_game_signal")
	
	var cam := Camera2D.new()
	cam.current = true
	
	var other_player: Node2D = player_scene.instance()
	other_player.set_network_master(Gamestate.other_pid)
	other_player.preset_username(Gamestate.other_username)
	if (Gamestate.character == 0):
		other_player.character_id = 1
		other_player.global_position = ig_spawner.global_position
	else:
		other_player.character_id = 0
		other_player.global_position = mb_spawner.global_position
	
	add_child(other_player)
	players.push_back(other_player)

	var player: Node2D = player_scene.instance()
	player.set_network_master(Gamestate.my_pid)
	player.preset_username(Gamestate.username)
	player.character_id = Gamestate.character
	if (Gamestate.character == 0):
		player.global_position = mb_spawner.global_position
	else:
		player.global_position = ig_spawner.global_position
	
	add_child(player)
	player.add_child(cam)
	players.push_back(player)

func _player_tick_signal(info: Utils.NPI):
	if (is_paused):
		return
	players[0].global_position = info.pos
	players[0].direction = info.direction

func _physics_process(delta):
	if (Input.is_action_just_pressed("pause")):
		Gamestate.request_pause_game()

func _pause_game_signal() -> void:
	pause_menu.visible = true
	is_paused = true
	for p in players:
		p.is_paused = true

func _resume_game_signal() -> void:
	pause_menu.visible = false
	is_paused = false
	for p in players:
		p.is_paused = false
