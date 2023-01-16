class_name Entity2D
extends KinematicBody2D

const SPEED := Vector2(150.0, 425.0)
const GRAVITY_VEC := Vector2(0.0, 980.0)
const FLOOR_NORMAL := Vector2.UP
const SLOPE_SLIDE_STOP := true
const FLOOR_DETECT_DISTANCE = 20.0

var linear_vel = Vector2.ZERO

func _physics_process(delta):
	linear_vel += GRAVITY_VEC * delta
#	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
