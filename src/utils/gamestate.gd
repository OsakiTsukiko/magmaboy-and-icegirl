extends Node

var game_port: int
var game_ip: String

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_network_peer_disconnected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

# connect to / make server

func init_server(username: String, character: int, game_port: int) -> void:
	self.game_ip = "localhost"
	self.game_port = game_port
	var peer := NetworkedMultiplayerENet.new()
	peer.create_server(game_port, 1)
	get_tree().network_peer = peer

func init_client(username: String, game_ip: String, game_port: int) -> void:
	self.game_ip = game_ip
	self.game_port = game_port
	var peer := NetworkedMultiplayerENet.new()
	peer.create_client(game_ip, game_port)
	get_tree().network_peer = peer

# Network Signals

func _network_peer_connected(id: int):
	print(id, " connected")

func _network_peer_disconnected(id: int):
	print(id, " disconnected")

func _server_disconnected():
	pass
