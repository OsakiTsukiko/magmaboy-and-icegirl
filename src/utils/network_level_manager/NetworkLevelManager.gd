extends Node

onready var network_tick_timer = $NetworkTick

var in_match: bool
var tick: int = 0

func start_sync():
	if (get_tree().is_network_server()):
		var current_unix_time: int = OS.get_unix_time()
		rpc("sync_tick_timer", current_unix_time + 5)
		
remotesync func sync_tick_timer(unix_time: int):
	if (get_tree().get_rpc_sender_id() == 1):
		while (OS.get_unix_time() != unix_time):
			pass
		network_tick_timer.start()

func _on_NetworkTick():
	print(tick)
	tick += 1
	tick = tick % 20
	var nodes_in_not = get_tree().get_nodes_in_group("network_object_test")
	for node in nodes_in_not:
		print()
