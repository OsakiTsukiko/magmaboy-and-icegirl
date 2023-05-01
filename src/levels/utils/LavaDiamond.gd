extends Node2D

onready var area2d = $Area2D

func is_lava_diamond() -> bool:
	return true

func _on_Area2D_body_entered(body):
	if (body.has_method("is_player")):
		body.entered_lava_diamond(self)
