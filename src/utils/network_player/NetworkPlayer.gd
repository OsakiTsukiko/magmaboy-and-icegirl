extends SGKinematicBody2D

const GRAVITY := 65536*1
const MOVEMENT_SPEED := 65536*1
var velocity = SGFixedVector2.new()

func _get_local_input() -> Dictionary:
	var input: Dictionary = {}
	
	var input_vector = Vector2.ZERO
	input_vector.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input_vector.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("jump"))
	
	if input_vector != Vector2.ZERO:
		input["input_vector"] = input_vector
	
	return input

func _network_process(input: Dictionary) -> void:
	var input_vector = input.get("input_vector", Vector2.ZERO)
#	fixed_position.x += int(input_vector.x)
	velocity.x += SGFixed.mul(SGFixed.from_float(input_vector.x), MOVEMENT_SPEED)
	
	velocity = move_and_slide(velocity)

func _save_state() -> Dictionary:
	return {
		fixed_position_x = fixed_position.x,
		fixed_position_y = fixed_position.y,
		velocity_x = velocity.x,
		velocity_y = velocity.y,
	}

func _load_state(state: Dictionary) -> void:
	velocity.x = state["velocity_x"]
	velocity.y = state["velocity_y"]
	fixed_position.x = state["fixed_position_x"]
	fixed_position.y = state["fixed_position_y"]
	
	sync_to_physics_engine()
