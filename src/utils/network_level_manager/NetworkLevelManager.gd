extends Node

signal finish_tick_timer_sync

onready var network_tick_timer = $NetworkTick

onready var sync_label = $CanvasLayer/MarginContainer/VBoxContainer/SyncLabel

var in_match: bool
var tick: int = 0

func _ready():
	connect("finish_tick_timer_sync", self, "_finish_tick_timer_sync")

func _process(delta):
	if (Input.is_action_just_pressed("nlm_debug")):
		pass

func start_sync():
	if (get_tree().is_network_server()):
		var current_unix_time: int = OS.get_unix_time()
		rpc("sync_tick_timer", current_unix_time + 5)
	
	sync_label.text = ""

var sync_tick_timer_thread: Thread
remotesync func sync_tick_timer(unix_time: int):
	if (get_tree().get_rpc_sender_id() == 1):
		sync_tick_timer_thread = Thread.new()
		sync_tick_timer_thread.start(self, "_sync_tick_timer_thread", unix_time)

func _sync_tick_timer_thread(unix_time: int):
	while (OS.get_unix_time() != unix_time):
		pass
	call_deferred("emit_signal", "finish_tick_timer_sync")

func _exit_tree():
	sync_tick_timer_thread.wait_to_finish()

func _on_NetworkTick():
	print(tick)
	tick += 1
	tick = tick % 20
	var nodes_in_not = get_tree().get_nodes_in_group("network_object_test")
	for node in nodes_in_not:
		print()

func _finish_tick_timer_sync():
	network_tick_timer.start()
	sync_label.text = "Synced!"
