extends CharacterBody2D
enum MovementState { UP, DOWN, LEFT, RIGHT }
var move_range = 50
var move_timer = 0
var current_state = MovementState.UP
@onready var SlimeDeath = $SlimeDeath
var chase_speed = 5
var speed = 100
var player_chase = false
var currentHealth: int = 5
@onready var Hurt = $Hurt
@onready var HurtTimer1 = $HurtTimer1
@onready var deathTimer = $deathTimer
@onready var slimedeathsound = $slimedeathsound
@onready var slimehitsound  = $slimehitsound
var motion = Vector2.ZERO
var player = null
func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/chase_speed
		
	else:
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


func _on_hurt_box_area_entered(area):
	if area.name == "weapon":
		print_debug(currentHealth)
		currentHealth -= 1
		Hurt.play("hurt")
		slimehitsound.play()
		HurtTimer1.start()
		await HurtTimer1.timeout
		Hurt.play("RESET")
		if currentHealth < 0:
			SlimeDeath.play("death")
			slimedeathsound.play()
			deathTimer.start()
			await deathTimer.timeout
			queue_free()


func _on_detectionarea_1_body_entered(body):
	player = body
	player_chase = true


func _on_detectionarea_1_body_exited(body):
	player = null
	player_chase = false
