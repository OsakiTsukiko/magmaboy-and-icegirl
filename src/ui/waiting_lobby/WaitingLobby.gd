extends Control

onready var title = $BG/CenterContainer/Title

func _ready():
	load_title("Waiting")
	Gamestate.connect("waiting_lobby_message_signal", self, "_waiting_lobby_message_signal")

func load_title(msg: String):
	title.bbcode_text = "\n[center][wave amp=15 freq=2]" + msg + "[/wave][/center]\n"

func _waiting_lobby_message_signal(msg: String):
	load_title(msg)
