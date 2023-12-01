extends CharacterBody2D
var collision_count = 0

signal healthChanged
@export var maxHealth = 3
@onready var currentHealth: int = maxHealth
@export var knockbackPower: int = 500
@onready var effects = $Effects
@onready var HurtTimer = $HurtTimer
@onready var hurtsound1 = $hurtsound1
@onready var animation_tree = $AnimationTree
@onready var weapon = $CassandraSprite/weapon
@onready var dead_sound = $dead_sound
@onready var gameovertimer = $GameOverTimer
@export var ghost_node : PackedScene
@onready var ghost_timer = $GhostTimer
@onready var deathTimer4 = $deathTimer4

var SPEED
const walking_speed = 100
const running_speed = 250
var input_dir
var is_attacking: bool = false
var potion_is_in_range: bool = false
var is_talking: bool = false

func _ready():
	#activate animation tree
	animation_tree.active = true
	input_dir = Vector2(1,0)
	
#func _process(delta):
#	update_animation_parameter()

func get_input():
	if (is_attacking == true or is_talking == true):
		input_dir = Vector2(0,0)
	else:
		input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	SPEED = walking_speed
	
	if(Input.is_action_pressed("running")):
		#update SPEED when shift is pressed
		SPEED = running_speed
	else:
		#SPEED remanins walking speed if shift is not pressed
		SPEED = walking_speed
		
	velocity = input_dir * SPEED
	
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
	else:
		animation_tree["parameters/conditions/attack"] = false
		weapon.visible = false
		is_attacking = false
	
	#sets the player in the correct direction
	if(input_dir != Vector2.ZERO):
		animation_tree["parameters/attack/blend_position"] = input_dir
		animation_tree["parameters/idle/blend_position"] = input_dir
		animation_tree["parameters/walk/blend_position"] = input_dir

func _unhandled_input(event):
	#if player is in range of potion and presses 'f', dialogue balloon will load
		is_talking = false
		if potion_is_in_range == true:
			if Input.is_action_pressed("interact"):
				DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/main.dialogue"), "start")
				is_talking = true
				return
					
func _physics_process(delta):
	handleCollision()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	#move_and_collide(velocity * delta)
	move_and_slide()	
	update_animation_parameter()
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

func _on_hurtbox_area_entered(area):
	if area.name == "hitBox" or area.name =="hitBox2":
		currentHealth -= 1
		if currentHealth < 0:
			MusicController.play_music()
			effects.play("death")
			deathTimer4.start()
			await deathTimer4.timeout
			get_tree().change_scene_to_file("res://game_over_screen.tscn")
			dead_sound.play()
		healthChanged.emit(currentHealth)

		# Ensure the enemy is valid and still spawned
		if is_instance_valid(area):
			if area.get_parent().currentHealth > 0:
				knockback(area.get_parent().velocity)
				
		effects.play("hurtBlink")
		hurtsound1.play()
		HurtTimer.start()
		await HurtTimer.timeout
		effects.play("RESET")
		
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
	
	tween.tween_property(self, "position", position + velocity*1.5, 0.35)

	await tween.finished
	ghost_timer.stop()
	
func _input(event):
	if event.is_action_pressed("dash"):
		dash()

func _on_detection_area_body_entered(body):
	if body.has_method("entity"):
		potion_is_in_range = true


func _on_detection_area_body_exited(body):
	if body.has_method("entity"):
		potion_is_in_range = false

func _on_ghost_timer_timeout():
	add_ghost()
