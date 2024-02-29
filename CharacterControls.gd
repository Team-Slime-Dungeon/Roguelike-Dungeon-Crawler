extends CharacterBody2D
var collision_count = 0

signal healthChanged
@export var maxHealth = 2
@onready var currentHealth: int = maxHealth

# This is for testing, will probably need to move with inventory system
signal armorChanged
@export var maxArmor = 6.0
@onready var currentArmor: float = maxArmor

@export var knockbackPower: int = 500

@onready var animation_tree = $AnimationTree
@onready var effects = $Effects
@onready var weapon = $CassandraSprite/weapon

@onready var HurtTimer = $HurtTimer
#@onready var gameovertimer = $GameOverTimer
@onready var ghost_timer = $GhostTimer
@onready var deathTimer4 = $deathTimer4

@onready var dead_sound = $dead_sound
@onready var hurtsound1 = $hurtsound1

@export var ghost_node : PackedScene

var cutscene_speed = walking_speed
var cutscene_location
var cutscene_action = false
var input_blocked = false
var SPEED
const walking_speed = 100
const running_speed = 250
var input_dir
var last_input = Vector2(0,0)
var is_attacking: bool = false
var potion_is_in_range: bool = false
var is_talking: bool = false
var is_dashing = false
var projectile_spawns = []
var projectile_ID = 0
var camera_scale = 2

@onready var weapon_sprite = $CassandraSprite/weapon
#gets the weapon texture from the equipped slots
var new_texuture

func _ready():
	#activate animation tree
	animation_tree.active = true
	input_dir = Vector2(1,0)
	
	#updates the weapon sprite with the equipped weapon sprite
	new_texuture =EquipSlot._get_weapon_texture()
	weapon_sprite.texture = new_texuture
	

#func _process(delta):
	if cutscene_action:
		move_character(cutscene_location)
#	update_animation_parameter()

func block_inputs(state = false): input_blocked = state

func update_camera_scale(new_scale):
	camera_scale = new_scale
	print(camera_scale)

func move_character(location, speed=walking_speed):
	if input_blocked:
		print("At: ",position,"moving to: ", location)
		
		if int(round(position.x)) == int(round(location.x)) and int(round(position.y)) == int(round(location.y)):
			print("At place!")
			velocity = Vector2.ZERO
			cutscene_action = false
			input_dir = Vector2.ZERO
			position = location
			
		else:
			cutscene_action = true
			#print(int(round(position)),"//",int(round(location.x)))
			
			if int(round(position.x)) != int(round(location.x)):
				if position.x > location.x:
					velocity.x = -speed#Vector2(-speed,0)
					print("Moving Left")
					input_dir = Vector2(-speed,0)
				if position.x < location.x:
					velocity.x = speed#Vector2(speed,0)
					print("Moving Right")
					input_dir = Vector2(speed,0)
			else: velocity.x = 0
			
			if int(round(position.y)) != int(round(location.y)):
				if position.y < location.y:
					velocity.y = speed# Vector2(0,-speed)
					print("moving down")
					input_dir = Vector2(0,speed)
				if position.y > location.y:
					velocity.y = -speed#Vector2(0,speed)
					input_dir = Vector2(0,-speed)
					print("moving up")
			else: velocity.y = 0
			cutscene_location = location
			cutscene_speed = speed

func get_input():
	if input_blocked != true:
		if (is_attacking == true or is_talking == true):
			input_dir = Vector2(0,0)
		else: input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
		SPEED = walking_speed
	
		if(Input.is_action_pressed("running")):
			#update SPEED when shift is pressed
			SPEED = running_speed
		else:
			#SPEED remains walking speed if shift is not pressed
			SPEED = walking_speed
		
		velocity = input_dir * SPEED
		
	# Update old direction
	if input_dir != Vector2(0,0):
		last_input = input_dir
		
func update_animation_parameter():
	#idle animation plays if velocity equals zero, otherwise walking animation plays
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true	
		animation_tree["parameters/conditions/is_moving"] = false	
	else:
		animation_tree["parameters/conditions/idle"] = false	
		animation_tree["parameters/conditions/is_moving"] = true
	
	#attack animation plays if LMB is pressed
	#weapon is set to visible
	#otherwise attack animation is set to false	
	if(Input.is_action_pressed("attack")):
		animation_tree["parameters/conditions/attack"] = true
		weapon.visible = true
		is_attacking = true
	elif(Input.is_action_just_released("ranged_attack")):
		animation_tree["parameters/conditions/attack"] = true
		is_attacking = true
		
		var tossed_item = preload("res://equipment/Shuriken.tscn")
		var new_projectile_spawn = tossed_item.instantiate()
		var new_projectile_location = position / camera_scale#2#Vector2i(position)# / 2
		
		# Manages all the item spawns to remove them when the floor is cleared.
		projectile_spawns.append(new_projectile_spawn)
		add_child(new_projectile_spawn)
		projectile_spawns[projectile_ID].global_position = new_projectile_location
		projectile_spawns[projectile_ID]._set_dir(last_input)

		projectile_ID += 1
	else:
		animation_tree["parameters/conditions/attack"] = false
		weapon.visible = false
		is_attacking = false
	
	#sets the player in the correct direction
	if(input_dir != Vector2.ZERO):
		animation_tree["parameters/attack/blend_position"] = input_dir
		animation_tree["parameters/idle/blend_position"] = input_dir
		animation_tree["parameters/walk/blend_position"] = input_dir


					
func _physics_process(delta):
	handleCollision()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	#move_and_collide(velocity * delta)
	update_animation_parameter()
	move_and_slide()	
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

func _on_hurtbox_area_entered(area):
	if area.name == "hitBox" or area.name =="hitBox2":
		if $"../Debug_Hud/CheckButton".is_pressed(): currentHealth = maxHealth
		elif currentArmor > 0.0: 
			currentArmor -= 1.0
			armorChanged.emit(currentArmor) # Damage armor icon
			
			# Shake Intensity
			var armor_ratio = currentArmor / maxArmor
			var base_intensity = 1.0  # Base for Full Armor
			var max_intensity = 5.0  # Base For Aromr Almost Gone
			var shake_intensity = base_intensity + (1.0 - armor_ratio) * (max_intensity - base_intensity)
			
			# Shake Duration
			var base_duration = 0.1 # Base for Full Armor
			var max_duration = 0.5 # Base For Aromr Almost Gone
			var shake_duration = base_duration + (1.0 - armor_ratio) * (max_duration - base_duration)
			
			print("Armor intensity: ", shake_intensity, " and duration: ", shake_duration) #Debug
			
			$Camera2D.start_shake(shake_duration, shake_intensity)
			
		else: 
			currentHealth -= 1
			if currentHealth >= 0:
				# Fixed Shake for health damage with no Armor
				var health_shake_intensity = 6.5
				var health_shake_duration = 0.5
				print("Health intensity: ", health_shake_intensity, " and duration: ", health_shake_duration) #Debug
				$Camera2D.start_shake(health_shake_duration, health_shake_intensity)

		if currentHealth <= 0:
			# Clear inventory upon death
			#Items.Player_Inventory._minus_item(0, Items.Player_Inventory._get_coins())
			Items.Player_Inventory._load_inventory({0:0})
			MusicController.play_music()
			effects.play("death")
			deathTimer4.start()
			await deathTimer4.timeout
			get_tree().change_scene_to_file("res://game_over_screen.tscn")
			dead_sound.play()
		healthChanged.emit(currentHealth)
		
		#$Camera2D.start_shake(0.5, 10.0)
		
		# Ensure the enemy is valid and still spawned
		if is_instance_valid(area):
			if area.get_parent().currentHealth > 0:
				knockback(area.get_parent().velocity)

		effects.play("hurtBlink")
		hurtsound1.play()
		HurtTimer.start()
		await HurtTimer.timeout
		effects.play("RESET")

		# Hit and recover 
		$RegenTimer.start()
		await $RegenTimer.timeout
		currentHealth = maxHealth
		healthChanged.emit(currentHealth)

func knockback(enemyVelocity: Vector2):
	var totalKnockback = Vector2(0, 0)
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	totalKnockback += knockbackDirection
	var secondEnemyVelocity = Vector2(0, 0)  # Replace with the actual velocity of the second enemy.
	var secondKnockbackDirection = (secondEnemyVelocity - velocity).normalized() * knockbackPower
	totalKnockback += secondKnockbackDirection
	velocity = totalKnockback
	move_and_slide()
	# Initialize a variable to accumulate the total knockback.
	# Calculate the knockback direction and add it to the totalKnockback.
	# Calculate the knockback from the second enemy and add it to totalKnockback.
	# Apply the total knockback to the player's velocity.
	# Perform the movement and sliding.
	
func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, $CassandraSprite.scale)
	get_tree().current_scene.add_child(ghost)
	
func dash():
	ghost_timer.start()
	var tween = get_tree().create_tween()
	await tween.finished
	ghost_timer.stop()
	
func _process(delta):
	if cutscene_action:
		move_character(cutscene_location,cutscene_speed)
	if is_dashing: 
		dash()

func _input(event):
	if event.is_action_pressed("dash"):
		is_dashing = false
		dash_pressed()
		#dash()
	elif event.is_action_released("dash"):
		is_dashing = true
		ondash_released()

func dash_pressed(): dash()
func ondash_released(): return

func _on_detection_area_body_entered(body):
	if body.has_method("entity"):
		potion_is_in_range = true

func _on_detection_area_body_exited(body):
	if body.has_method("entity"):
		potion_is_in_range = false

func _on_ghost_timer_timeout():
	add_ghost()


