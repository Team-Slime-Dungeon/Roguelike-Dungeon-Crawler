extends CharacterBody2D

enum MovementState { UP, DOWN, LEFT, RIGHT }

var speed = 100
var move_range = 50
var move_timer = 0
var current_state = MovementState.UP

func _process(delta):
	#if not $AnimationPlayer.is_playing():
	#	$AnimationPlayer.play("movement")

	move_timer += delta

	if move_timer >= 2.0:  # Adjust this value to control the time for each type of movement
		move_timer = 0

		match current_state:
			MovementState.UP:
				current_state = MovementState.LEFT
			MovementState.LEFT:
				current_state = MovementState.DOWN
			MovementState.DOWN:
				current_state = MovementState.RIGHT
			MovementState.RIGHT:
				current_state = MovementState.UP

	match current_state:
		MovementState.UP:
			position.y -= speed * delta
		MovementState.LEFT:
			position.x -= speed * delta
		MovementState.DOWN:
			position.y += speed * delta
		MovementState.RIGHT:
			position.x += speed * delta

	position.x = clamp(position.x, -move_range, move_range)
	position.y = clamp(position.y, -move_range, move_range)
	move_and_slide()
