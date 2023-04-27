extends Area2D

func is_water() -> bool:
	return true


func _on_Water_body_entered(body):
	if (body.has_method("is_player")):
		body.entered_water()
