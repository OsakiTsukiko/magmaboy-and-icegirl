extends Control

onready var waiting_for_rtl = $BG/CenterContainer/WaitingForRTL
onready var accept_new_player_dialog = $BG/CenterContainer/AcceptNewPlayerDialog
onready var anp_request_label = $BG/CenterContainer/AcceptNewPlayerDialog/RequestLabel

var req_player: Dictionary = {
	"username": null,
	"id": null
}

func _ready() -> void:
	Gamestate.connect("player_join_request_signal", self, "_player_join_request_signal")
	waiting_for_rtl.visible = true
	accept_new_player_dialog.visible = false
	if (Gamestate.character == 0):
		waiting_for_rtl.bbcode_text = "[wave amp=25 freq=2][center]Waiting for [color=#97f7e4]IceGirl[/color][/center][/wave]\n"
	if (Gamestate.character == 1):
		waiting_for_rtl.bbcode_text = "[wave amp=25 freq=2][center]Waiting for [color=#e66247]MagmaBoy[/color][/center][/wave]\n"

func _player_join_request_signal(username: String, id: int) -> void:
	waiting_for_rtl.visible = false
	if (Gamestate.character == 0):
		anp_request_label.bbcode_text = "\n[center][color=#97f7e4][wave amp=20 freq=2]" + username + "[/wave][/color] is requesting to connect![/center]\n"
	if (Gamestate.character == 1):
		anp_request_label.bbcode_text = "\n[center][color=#e66247][wave amp=20 freq=2]" + username + "[/wave][/color] is requesting to connect![/center]\n"
	accept_new_player_dialog.visible = true
	req_player.username = username
	req_player.id = id

func _on_ANPRejectBTN_pressed() -> void:
	Gamestate.reject_player_connect_req(req_player.id)
	accept_new_player_dialog.visible = false
	waiting_for_rtl.visible = true

func _on_ANPAcceptBTN_pressed() -> void:
	Gamestate.accept_player_connect_req(req_player.id)
