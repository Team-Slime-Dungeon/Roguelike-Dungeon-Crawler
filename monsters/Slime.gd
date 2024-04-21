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

#Debug Step back in case it has crashes it can be turned off here by making it false
var allow_step_back = true

@onready var HurtTimer1 = $HurtTimer1
@onready var deathTimer = $deathTimer
@onready var slimedeathsound = $slimedeathsound
@onready var slimehitsound  = $slimehitsound

@onready var tween = get_tree().create_tween()

var motion = Vector2.ZERO
var player = null
var monster_type = "Slime"
var monster_drops = [0,0,0,0]
var Body_Color
var Eye_Color
var Detail_Color

func _ready(): 
	if not $SlimeAnim.is_playing():
		$SlimeAnim.play("movement")
	
	var Body_Color_Vals = [randf_range(.25,1),randf_range(.25,1),randf_range(.25,1)]
	var Detail_Color_Vals = [Body_Color_Vals[0]/randi_range(1,3),Body_Color_Vals[1]/randi_range(1,3),Body_Color_Vals[2]/randi_range(1,3)]
		
	Body_Color = Color(Body_Color_Vals[0],Body_Color_Vals[1],Body_Color_Vals[2])
	Detail_Color  = Color(Detail_Color_Vals[0],Detail_Color_Vals[1],Detail_Color_Vals[2])

	# Eye Color Coloring, if needed uncomment later
	#var color_sum = 0
	#for i in Body_Color_Vals:
	#	color_sum += i

	# Lighter Color Eyes when the slime body is below minimum value
	#if color_sum < 1.0:
	#	$Eyes.modulate = Detail_Color
	# Darker Color Eyes
	#else:
	$Eyes.modulate = Color(0,0,0)

	set_color(Body_Color,Detail_Color)
	
	# Slime Drop Typing
	if (Body_Color_Vals[0] > Body_Color_Vals[1] + Body_Color_Vals[2]):
		#print("Strongly Red")
		monster_type = "Red Slime"
#		monster_drops = []
	elif (Body_Color_Vals[1] > Body_Color_Vals[0] + Body_Color_Vals[2]):
		#print("Strongly Green")
		monster_type = "Green Slime"
#		monster_drops = []
	elif (Body_Color_Vals[2] > Body_Color_Vals[0] + Body_Color_Vals[1]):
		#print("Strongly Blue")
		monster_type = "Blue Slime"
		monster_drops = [0,0,71,71]

func set_color(body_color=null,detail_color=null):
	if body_color != null:
		$Body.modulate = body_color

	if detail_color != null:
		$Details.modulate = detail_color

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

func _on_hurt_box_area_entered(area):
	if area.name == "weapon" or area.name == "Shuriken":
		#print_debug(currentHealth)
		currentHealth -= 1
		$SlimeAnim.play("hit")
		slimehitsound.play()
		if currentHealth > 0:
			HurtTimer1.start()
			await HurtTimer1.timeout
			$SlimeAnim.play("movement")
			set_color(Body_Color,Detail_Color)
		elif currentHealth <= 0:
			deathTimer.start()
			$SlimeAnim.play("death")
			await deathTimer.timeout
			slimedeathsound.play()

			death_location = get_position()

func enemy_clear():
	queue_free()
	#print("Slime cleared")

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


func _on_hit_box_area_entered(area):
	#If the player gets hurt and if allow_step_back is true
	if area.name == "hurtbox" and allow_step_back:
		step_back()

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

func resume_chase():
	#Resume Chasing
	player_chase = true 

func is_enemy():
	return true
