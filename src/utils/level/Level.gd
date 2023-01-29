extends Node2D
class_name LevelScene

func _ready():
	var server_np = get_node("ServerNP")
	var client_np = get_node("ClientNP")
	server_np.set_network_master(1)
	if (get_tree().is_network_server()):
		for peer in get_tree().get_network_connected_peers():
		# in theory, this array should only have one element inside,
		# the peer id of the connected peer, but just to be on the safe
		# side
			if (peer != 1):
				client_np.set_network_master(peer)
	else:
		client_np.set_network_master(get_tree().get_network_unique_id())
