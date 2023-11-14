extends CharacterBody2D

enum MovementState { UP, DOWN, LEFT, RIGHT }
var currentHealth: int = 5
var speed = 100
var move_range = 50
var move_timer = 0
var current_state = MovementState.UP
@onready var deathTimer3 = $deathTimer3
func _process(delta):
	#if not $Spider/AnimationPlayer.is_playing():
	#	$Spider/AnimationPlayer.play("walking_left")

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


func _on_hurt_area_area_entered(area):
	if area.name == "weapon":
		print_debug(currentHealth)
		currentHealth -= 1
		if currentHealth < 0:
			deathTimer3.start()
			await deathTimer3.timeout
			queue_free()
