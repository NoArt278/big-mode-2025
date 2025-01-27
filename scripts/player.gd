extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var currLever : Lever

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var x_dir := Input.get_axis("left", "right")
	var y_dir := Input.get_axis("up", "down")
	if x_dir:
		velocity.x = x_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if y_dir:
		velocity.y = y_dir * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if Input.is_action_just_pressed("interact") and currLever :
		currLever.interact()

	move_and_slide()
