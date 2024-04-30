extends CharacterBody2D

var random = RandomNumberGenerator.new()
enum MovementState { UP, DOWN, LEFT, RIGHT }
var move_timer = 0
var current_state = get_direction()
var chase_speed = 10
var speed = 15
var player_chase = false
var currentHealth: int = 20
var max_speed = 20
var death_location = null

#Debug Step back in case it has crashes it can be turned off here by making it false
var allow_step_back = false

@onready var tween = get_tree().create_tween()

var motion = Vector2.ZERO
var player = null
var monster_type = "Slime"
var monster_drops = [0,0,0,0]
var Body_Color
var Eye_Color
var Detail_Color

signal healthChanged

func _ready(): 
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("movement")
		$"Slime Body/ColorChange".play("Color_Change")
		
func _physics_process(delta):	
	if player_chase and is_instance_valid(player):
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

func enemy_clear(): queue_free()


func step_back():
  # Check if player exists and is valid
	if player != null and is_instance_valid(player):
	# Calculate direction to slide away from player
		var slide_direction = (self.position - player.position).normalized()
	# Reduce slide distance to avoid getting stuck on edges
		var slide_amount = slide_direction * 30  
	# Slime's speed and direction for the slide
		self.velocity = slide_amount
		
		# Make Slime Slide
		move_and_slide()
		
	# Pause Chasing for a bit
		player_chase = false
		var resume_chase_timer = Timer.new()
		add_child(resume_chase_timer)
		
	# Wait before Resuming Chase
		resume_chase_timer.wait_time = 0.5 
		resume_chase_timer.one_shot = true
		resume_chase_timer.connect("timeout", Callable(self, "resume_chase"))
		resume_chase_timer.start()

func resume_chase(): player_chase = true 

func _on_hurtbox_area_entered(area):
	if area.name == "weapon" or area.name == "Shuriken":
		currentHealth -= 1
		print("King Slime HP: ", currentHealth)
		$AnimationPlayer.play("hit")
		#slimehitsound.play()
		if currentHealth > 0:
			$Hurt.start()
			await $Hurt.timeout
			$AnimationPlayer.play("movement")
		if currentHealth <= 0:
			$Death.start()
			$AnimationPlayer.play("death")
			await $Death.timeout
			#slimedeathsound.play()
			death_location = get_position()
	# start at 20
	# when health reduced to 15, split, start timer
	# rejoin health = slimes left * 5AAA

func _on_hitbox_area_entered(area):
	#If the player gets hurt and if allow_step_back is true
	if area.name == "hurtbox" and allow_step_back:
		step_back()

func _on_detectionarea_1_body_entered(body):
	player = body
# Wait for 0.2 seconds before chasing
	await get_tree().create_timer(0.2).timeout
	player_chase = true 

func _on_detectionarea_1_body_exited(body):
	player = null
	player_chase = false
	velocity.x = 0
	velocity.y = 0
#	print("Player lost.")
