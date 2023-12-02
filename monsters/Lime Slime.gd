extends CharacterBody2D

var random = RandomNumberGenerator.new()
enum MovementState { UP, DOWN, LEFT, RIGHT }
var move_timer = 0
var current_state = get_direction()
var chase_speed = 10
var speed = 15
var player_chase = false
var currentHealth: int = 3
var max_speed = 20
var death_location = null

@onready var HurtTimer1 = $HurtTimer1
@onready var deathTimer = $deathTimer
@onready var slimedeathsound = $slimedeathsound
@onready var slimehitsound  = $slimehitsound

var motion = Vector2.ZERO
var player = null
var monster_type = "Lime Slime"
var monster_drops = []

func _ready(): 
	if not $LimeAnim.is_playing():
		$LimeAnim.play("movement")

func _physics_process(delta):		
	if player_chase:
		velocity = (player.position + Vector2(16,16) - self.position) + velocity / chase_speed			
	else: 
		move_timer += delta
	
		if move_timer >= 1.0:  # Adjust this value to control the time for each type of movement
			move_timer = 0
			current_state = get_direction()
	
		match current_state:
			MovementState.UP: velocity.y -= speed * delta
			MovementState.LEFT: velocity.x -= speed * delta
			MovementState.DOWN: velocity.y += speed * delta
			MovementState.RIGHT: velocity.x += speed * delta
	
		if velocity.x >= max_speed:
			velocity.x = max_speed
			
		if velocity.y >= max_speed:
			velocity.y = max_speed

		#position = delta * motion
		#motion = Vector2.ZERO 
	
	move_and_slide() # Need for collision
	
func get_direction():
	var current_direction = random.randi_range(1, 5)  # Select direction
	match current_direction:
		1: return MovementState.LEFT
		2: return MovementState.DOWN
		3: return MovementState.RIGHT
		4: return MovementState.UP
		5: return null

func _on_hurt_box_area_entered(area):
	if area.name == "weapon":
		#print_debug(currentHealth)
		currentHealth -= 1
		$LimeAnim.play("hit")
		slimehitsound.play()
		if currentHealth > 0:
			HurtTimer1.start()
			await HurtTimer1.timeout
			$LimeAnim.play("movement")
		elif currentHealth <= 0:
			deathTimer.start()
			$LimeAnim.play("death")
			await deathTimer.timeout
			slimedeathsound.play()

			death_location = get_position()

func enemy_clear():
	queue_free()
	#print("Slime cleared")

func _on_detectionarea_1_body_entered(body):
	player = body
	player_chase = true

func _on_detectionarea_1_body_exited(body):
	player = null
	player_chase = false
	velocity.x = 0
	velocity.y = 0
#	print("Player lost.")
