class_name Entity2D
extends KinematicBody2D

const SPEED = Vector2(150.0, 350.0)
const GRAVITY_VEC = Vector2(0.0, 98.0)
const FLOOR_NORMAL = Vector2.UP

var linear_vel = Vector2.ZERO

func _physics_process(delta):
	linear_vel += GRAVITY_VEC * delta

