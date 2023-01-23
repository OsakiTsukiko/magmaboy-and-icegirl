extends Entity2D

onready var sprite = $Sprite
onready var ray_cast = $RayCast2D

puppet var character: int = 0

puppet func select_character(character: int) -> void:
	pass

puppet func update_location(pos: Vector2, vel: Vector2) -> void:
	position = pos
	linear_vel = vel

func _physics_process(delta) -> void:
#	if (is_network_master()):
		# ^ weird method, should look more into it
	if (true):
		var direction = get_direction()
		var is_jump_interrupted = Input.is_action_just_released("jump") && linear_vel.y < 0.0
		linear_vel = calculate_move_velocity(linear_vel, direction, SPEED, is_jump_interrupted)
		
		var snap_vector = Vector2.ZERO
		if direction.y == 0.0:
			snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
		var is_on_platform = ray_cast.is_colliding()
#		linear_vel = move_and_slide_with_snap(
#			linear_vel,
#			snap_vector,
#			FLOOR_NORMAL,
#			!is_on_platform,
#			4,
#			0.9,
#			false
#		)
		linear_vel = move_and_slide(
			linear_vel,
			FLOOR_NORMAL
		)
		
		if direction.x != 0:
			if direction.x > 0:
				if ( sprite.scale.x < 0 ): sprite.scale.x *= -1
			else:
				if ( sprite.scale.x >= 0 ): sprite.scale.x *= -1
		
		# TODO: ANIMATIONS
		
#		rpc("set_pos_and_motion",position,linear_vel)

# UTILS

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump") else 0
	)

func calculate_move_velocity (
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	) -> Vector2:
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity
