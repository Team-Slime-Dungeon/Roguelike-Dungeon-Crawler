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
#@onready var slimedeathsound = $slimedeathsound
#@onready var slimehitsound  = $slimehitsound

var motion = Vector2.ZERO
var player = null
var monster_type = "Bush Monster"
var monster_drops = [0,0,0,0]
var Body_Color
var Eye_Color
var Detail_Color

var ally_chase = false
var ally_count = 0
var trg = null

func _ready(): 
	if not $BushmoAnim.is_playing():
		$BushmoAnim.play("idle")
	
	var Body_Color_Vals = [randf_range(.5,1),randf_range(0,.5),randf_range(0,.5)]
	Body_Color = Color(0,Body_Color_Vals[0],0)
	set_color(Body_Color)

func set_color(body_color=null,detail_color=null):
	if body_color != null:
		$Texture.modulate = body_color

func _physics_process(delta):
	
	if Global.companion_following == true:
		ally_count = is_ally_nearby()
		
		if ally_count > 0 and ally_chase:
			trg = find_ally()
			velocity = (trg.position + Vector2(16,16) - self.position) + velocity / chase_speed
			$BushmoAnim.play("walking")
			
		elif player_chase and is_instance_valid(player):
			velocity = (player.position + Vector2(16,16) - self.position) + velocity / chase_speed
			$BushmoAnim.play("walking")
			
	if player_chase and is_instance_valid(player) and !Global.companion_following:
		velocity = (player.position + Vector2(16,16) - self.position) + velocity / chase_speed
		$BushmoAnim.play("walking")
	
	move_and_slide() # Need for collision
	
	
func is_ally_nearby():
	var curr_ally_count = 0
	var bodies = $detectionarea.get_overlapping_bodies()
	for body in bodies:
		
		if body != null and body != self and body.has_method("is_ally") and body.is_ally(): 
			curr_ally_count += 1
			ally_chase = true
			
	
	return curr_ally_count
	
func find_ally():
	var bodies = $detectionarea.get_overlapping_bodies()
	var target = null
	for body in bodies:
		if body != null and body != self and body.has_method("is_ally") and body.is_ally(): 
			target = body
			break
	return target
	
func get_direction():
	var current_direction = 5
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
		$BushmoAnim.play("hit")
		#slimehitsound.play()
		if currentHealth > 0:
			HurtTimer1.start()
			await HurtTimer1.timeout
			$BushmoAnim.play("idle")
			set_color(Body_Color)
		elif currentHealth <= 0:
			deathTimer.start()
			$BushmoAnim.play("death")
			await deathTimer.timeout
			#slimedeathsound.play()

			death_location = get_position()

func _on_hit_box_area_entered(area):
	#If the player gets hurt and if allow_step_back is true
	if area.name == "hurtbox" and allow_step_back:
		step_back()

func step_back():
  # Check if player exists and is valid
	if player != null and is_instance_valid(player):
	# Calculate direction to slide away from the player
		var slide_direction = (self.position - player.position).normalized()
	# Reduce slide distance slightly to avoid getting stuck on edges
		var slide_amount = slide_direction * 30 
	# Set the slime's speed and direction for the slide
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
		
	elif trg != null and is_instance_valid(trg) and Global.companion_following:
		# Calculate direction to slide away from player
		var slide_direction = (self.position - trg.position).normalized()
	# Reduce slide distance to avoid getting stuck on edges
		var slide_amount = slide_direction * 30  
	# Slime's speed and direction for the slide
		self.velocity = slide_amount
		
		# Make Slime Slide
		move_and_slide()
		
	# Pause Chasing for a bit
		ally_chase = false
		var resume_chase_timer = Timer.new()
		add_child(resume_chase_timer)
		
	# Wait before Resuming Chase
		resume_chase_timer.wait_time = 0.5 
		resume_chase_timer.one_shot = true
		resume_chase_timer.connect("timeout", Callable(self, "resume_ally_chase"))
		resume_chase_timer.start()
		
func resume_ally_chase():
	ally_chase = true

func _on_resume_chase():
	player_chase = true # Resume chasing

func enemy_clear():
	queue_free()

func item_clear():
	queue_free()
	
func _on_detectionarea_body_entered(body):
	if body.name == "Cassandra":
		player = body
		# Wait for 0.2 seconds before chasing
		#await get_tree().create_timer(0.2).timeout
		player_chase = true

func _on_detectionarea_body_exited(body):
	if body.name == "Cassandra":
		player = null
		player_chase = false
		$BushmoAnim.play("retreat")
		velocity.x = 0
		velocity.y = 0
	if body.name == "Rubio":
		ally_chase = false
		$BushmoAnim.play("retreat")
		velocity.x = 0
		velocity.y = 0
	#	print("Player lost.")
func is_enemy():
	return true
