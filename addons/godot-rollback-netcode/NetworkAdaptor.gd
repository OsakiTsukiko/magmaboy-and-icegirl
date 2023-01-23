extends Node

const Utils = preload("res://addons/godot-rollback-netcode/Utils.gd")

static func is_type(obj: Object):
	return Utils.has_interop_method(obj, "attach_network_adaptor") \
		and Utils.has_interop_method(obj, "detach_network_adaptor") \
		and Utils.has_interop_method(obj, "start_network_adaptor") \
		and Utils.has_interop_method(obj, "stop_network_adaptor") \
		and Utils.has_interop_method(obj, "send_ping") \
		and Utils.has_interop_method(obj, "send_ping_back") \
		and Utils.has_interop_method(obj, "send_remote_start") \
		and Utils.has_interop_method(obj, "send_remote_stop") \
		and Utils.has_interop_method(obj, "send_input_tick") \
		and Utils.has_interop_method(obj, "is_network_host") \
		and Utils.has_interop_method(obj, "is_network_master_for_node") \
		and Utils.has_interop_method(obj, "get_network_unique_id") \
		and Utils.has_interop_method(obj, "poll")

signal received_ping (peer_id, msg)
signal received_ping_back (peer_id, msg)
signal received_remote_start ()
signal received_remote_stop ()
signal received_input_tick (peer_id, msg)

func attach_network_adaptor(sync_manager) -> void:
	pass

func detach_network_adaptor(sync_manager) -> void:
	pass

func start_network_adaptor(sync_manager) -> void:
	pass

func stop_network_adaptor(sync_manager) -> void:
	pass

func send_ping(peer_id: int, msg: Dictionary) -> void:
	push_error("UNIMPLEMENTED ERROR: NetworkAdaptor.send_ping()")

func send_ping_back(peer_id: int, msg: Dictionary) -> void:
	push_error("UNIMPLEMENTED ERROR: NetworkAdaptor.send_ping_back()")

func send_remote_start(peer_id: int) -> void:
	push_error("UNIMPLEMENTED ERROR: NetworkAdaptor.send_remote_start()")

func send_remote_stop(peer_id: int) -> void:
	push_error("UNIMPLEMENTED ERROR: NetworkAdaptor.send_remote_stop()")

func send_input_tick(peer_id: int, msg: PoolByteArray) -> void:
	push_error("UNIMPLEMENTED ERROR: NetworkAdaptor.send_input_tick()")

func is_network_host() -> bool:
	push_error("UNIMPLEMENTED ERROR: NetworkAdaptor.is_network_host()")
	return true

func is_network_master_for_node(node: Node) -> bool:
	push_error("UNIMPLEMENTED ERROR: NetworkAdaptor.is_network_master_for_node()")
	return true

func get_network_unique_id() -> int:
	push_error("UNIMPLEMENTED ERROR: NetworkAdaptor.get_network_unique_id()")
	return 1

func poll() -> void:
	pass
