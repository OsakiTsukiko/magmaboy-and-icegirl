extends Control

func _on_GithubBTN_pressed():
	if (ProjectSettings.has_setting("info/github_url")):
		OS.shell_open(ProjectSettings.get("info/github_url"))
