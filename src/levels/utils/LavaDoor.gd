extends Node2D

onready var area2d = $Area2D

func _on_Area2D_body_entered(body):
	if (body.has_method("is_player")):
		body.entered_lava_door()

func _on_Area2D_body_exited(body):
	if (body.has_method("is_player")):
		body.exited_lava_door()
