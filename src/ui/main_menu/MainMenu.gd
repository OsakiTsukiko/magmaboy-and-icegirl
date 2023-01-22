extends Control

var host_menu_scene = load("res://src/ui/host_menu/HostMenu.tscn")
var connect_menu_scene = load("res://src/ui/connect_menu/ConnectMenu.tscn")

func _on_GithubBTN_pressed() -> void:
	if (ProjectSettings.has_setting("info/github_url")):
		OS.shell_open(ProjectSettings.get("info/github_url"))

func _on_HostBTN_pressed() -> void:
	get_tree().change_scene_to(host_menu_scene)

func _on_ConnectBTN_pressed() -> void:
	get_tree().change_scene_to(connect_menu_scene)

