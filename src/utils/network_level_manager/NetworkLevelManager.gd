extends Node

signal finish_tick_timer_sync

onready var network_tick_timer: Node = $NetworkTick

onready var debug_layer: Node = $CanvasLayer
onready var dbg_sync_label: Node = $CanvasLayer/MarginContainer/VBoxContainer/SyncLabel

var debug_on: bool = false

var in_match: bool
var tick: int = 0

func _ready():
	debug_layer.visible = debug_on
	connect("finish_tick_timer_sync", self, "_finish_tick_timer_sync")

func _process(delta):
	if (Input.is_action_just_pressed("nlm_debug")):
		debug_on = !debug_on
		debug_layer.visible = debug_on

func start_sync():
	if (get_tree().is_network_server()):
		var current_unix_time: int = OS.get_unix_time()
		rpc("sync_tick_timer", current_unix_time + 5)
	
	dbg_sync_label.text = ""

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
	if sync_tick_timer_thread != null:
		sync_tick_timer_thread.wait_to_finish()

func _on_NetworkTick():
	tick += 1
	tick = tick % 20
	if (debug_on):
		print(tick)
		if (tick == 0):
			dbg_sync_label.set("custom_colors/font_color", Color(128, 255, 0, 255) / 255)
		else:
			dbg_sync_label.set("custom_colors/font_color", Color(255, 42, 0, 255) / 255)
	var nodes_in_not = get_tree().get_nodes_in_group("network_object_test")
	for node in nodes_in_not:
		print()

func _finish_tick_timer_sync():
	network_tick_timer.start()
	dbg_sync_label.text = "Synced!"
