extends Control

func _on_ResumeBTN_pressed():
	Gamestate.request_resume_game()

func _on_QuitBTN_pressed():
	get_tree().quit()
