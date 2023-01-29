extends Node

var main_menu_scene = load("res://src/ui/main_menu/MainMenu.tscn")
var connect_menu_scene = load("res://src/ui/connect_menu/ConnectMenu.tscn")
var host_menu_scene = load("res://src/ui/host_menu/HostMenu.tscn")
var lobby_scene = load("res://src/ui/lobby/Lobby.tscn")
var waiting_lobby = load("res://src/ui/waiting_lobby/WaitingLobby.tscn")
var kicked_menu = load("res://src/ui/kicked_menu/KickedMenu.tscn")
var level_selector = load("res://src/ui/level_selector/LevelSelector.tscn")

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
signal connect_error_scene_signal

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	SyncManager.connect("sync_started", self, "_sync_started")
	SyncManager.connect("sync_stopped", self, "_sync_stopped")
	SyncManager.connect("sync_lost", self, "_sync_lost")
	SyncManager.connect("sync_regained", self, "_sync_regained")
	SyncManager.connect("sync_error", self, "_sync_error")

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
	get_tree().change_scene_to(waiting_lobby)
	call_deferred("emit_signal", "waiting_lobby_message_signal", "Connecting to Host...")
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

func accept_player_connect_req(id: int) -> void:
	var cid: int
	if (character == 1):
		cid = 0
	if (character == 0):
		cid = 1
	rpc("accept_request", username, cid)
	get_tree().change_scene_to(level_selector)

func start_level(level_id: int) -> void:
	print("Starting Level ", level_id)
	SyncManager.start()
	# continue in sync start signal

# Network Signals

func _kick_timeout(node: Timer, id: int) -> void:
	node.queue_free()
	for peer in get_tree().get_network_connected_peers():
		if peer == id:
			get_tree().network_peer.disconnect_peer(id)

func _network_peer_connected(id: int) -> void:
	print(id, " connected")
	SyncManager.add_peer(id)
	if (is_network_master()):
		rpc_id(id, "request_username")

func _network_peer_disconnected(id: int) -> void:
	print(id, " disconnected")
	SyncManager.remove_peer(id)

func _server_disconnected() -> void:
	_network_peer_disconnected(1)
	# might remove this in the future
	# also Stop SyncManager and stuff... idk

func _connection_failed() -> void:
	get_tree().change_scene_to(connect_menu_scene)
	call_deferred("emit_signal", "connect_error_scene_signal", "Connection Failed!")

func _connected_to_server() -> void:
	get_tree().change_scene_to(waiting_lobby)
	call_deferred("emit_signal", "waiting_lobby_message_signal", "Waiting for Approval...")

func _sync_started() -> void:
	print("Sync Started")

func _sync_stopped() -> void:
	print("Sync Stoped")
	
func _sync_lost() -> void:
	print("Sync Lost")

func _sync_regained() -> void:
	print("Sync Regained")

func _sync_error(msg: String) -> void:
	print("Sync Error: ", msg)
	# TODO: disconnect peer
	# clear sync peers
	# change scene

# Networking

puppetsync func accept_request(username: String, character: int):
	self.character = character
	var wlm_string = "Waiting for "
	if (character == 0):
		wlm_string += "[color=#97f7e4]" + username + "[/color] "
	if (character == 1):
		wlm_string += "[color=#e66247]" + username + "[/color] "
	wlm_string += "to select a level!"
	get_tree().change_scene_to(waiting_lobby)
	call_deferred("emit_signal", "waiting_lobby_message_signal", wlm_string)

puppetsync func kick(reason: String) -> void:
#	get_tree().network_peer = null
#	using this doesnt trigger server disconnected signal
	get_tree().change_scene_to(kicked_menu)
	call_deferred("emit_signal", "kicked_reason_signal", reason)

puppetsync func request_username() -> void:
	rpc_id(1, "respond_username_request", username)

mastersync func respond_username_request(username: String) -> void:
	call_deferred("emit_signal", "player_join_request_signal", username, get_tree().get_rpc_sender_id())
