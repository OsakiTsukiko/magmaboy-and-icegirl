extends Area2D

func is_lava() -> bool:
	return true


func _on_Lava_body_entered(body):
	if (body.has_method("is_player")):
		body.entered_lava()
