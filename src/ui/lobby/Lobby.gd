extends Control

onready var waiting_for_rtl = $BG/CenterContainer/WaitingForRTL

func _ready():
	if (Gamestate.character != null):
		if (Gamestate.character == 0):
			waiting_for_rtl.bbcode_text = "[wave amp=25 freq=2][center]Waiting for [color=#97f7e4]IceGirl[/color][/center][/wave]\n"
		if (Gamestate.character == 1):
			waiting_for_rtl.bbcode_text = "[wave amp=25 freq=2][center]Waiting for [color=#e66247]MagmaBoy[/color][/center][/wave]\n"
