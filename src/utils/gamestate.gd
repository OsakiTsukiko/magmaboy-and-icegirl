extends Node

var main_menu_scene = load("res://src/ui/main_menu/MainMenu.tscn")
var host_menu_scene = load("res://src/ui/host_menu/HostMenu.tscn")
var lobby_scene = load("res://src/ui/lobby/Lobby.tscn")
var waiting_lobby = load("res://src/ui/waiting_lobby/WaitingLobby.tscn")
var kicked_menu = load("res://src/ui/kicked_menu/KickedMenu.tscn")

var levels: Array = [
	Utils.Level.new("Temp", preload("res://src/levels/level_00/Level00.tscn"), preload("res://assets/levels/banners/level_00.png"))
]

var game_port: int
var game_ip: String

var character = null
var username: String

# Signals
signal player_join_request_signal
signal kicked_reason_signal
signal waiting_lobby_message_signal

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("connected_to_server", self, "_connected_to_server")

# connect to / make server

func init_server(username: String, character: int, game_port: int) -> void:
	self.game_ip = "localhost"
	self.game_port = game_port
	self.username = username
	self.character = character
	var peer := NetworkedMultiplayerENet.new()
	peer.create_server(game_port, 1)
	get_tree().network_peer = peer
	get_tree().change_scene_to(lobby_scene)

func init_client(username: String, game_ip: String, game_port: int) -> void:
	self.game_ip = game_ip
	self.game_port = game_port
	self.username = username
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(game_ip, game_port)
	get_tree().network_peer = peer

func reject_player_connect_req(id: int) -> void:
	rpc_unreliable_id(id, "kick", "Request Rejected!")
	# the following code is very shady... but its the only
	# method i could think of.. i tried many..
	# not even call_deferred could do the work
	# it would seem like a timer is the only way
	var kick_timer = Timer.new()
	kick_timer.one_shot = true
	kick_timer.wait_time = 0.1
	kick_timer.autostart = true
	kick_timer.connect("timeout", self, "_kick_timeout", [kick_timer, id])
	self.add_child(kick_timer)

# Network Signals

func _kick_timeout(node: Timer, id: int) -> void:
	node.queue_free()
	for peer in get_tree().get_network_connected_peers():
		if peer == id:
			get_tree().network_peer.disconnect_peer(id)

func _network_peer_connected(id: int) -> void:
	print(id, " connected")
	if (is_network_master()):
		rpc_id(id, "request_username")

func _network_peer_disconnected(id: int) -> void:
	print(id, " disconnected")

func _server_disconnected() -> void:
	_network_peer_disconnected(1)
	# might remove this in the future

func _connection_failed() -> void:
	print("connection failed")

func _connected_to_server() -> void:
	get_tree().change_scene_to(waiting_lobby)
	call_deferred("emit_signal", "waiting_lobby_message_signal", "Waiting for Approval...")

# Networking

puppetsync func kick(reason: String) -> void:
	get_tree().network_peer = null
	get_tree().change_scene_to(kicked_menu)
	call_deferred("emit_signal", "kicked_reason_signal", reason)

puppetsync func request_username() -> void:
	rpc_id(1, "respond_username_request", username)

mastersync func respond_username_request(username: String) -> void:
	call_deferred("emit_signal", "player_join_request_signal", username, get_tree().get_rpc_sender_id())
