extends Control

var host_menu_scene = load("res://src/ui/host_menu/HostMenu.tscn")

func _on_GithubBTN_pressed():
	if (ProjectSettings.has_setting("info/github_url")):
		OS.shell_open(ProjectSettings.get("info/github_url"))

func _on_HostBTN_pressed():
	get_tree().change_scene_to(host_menu_scene)
