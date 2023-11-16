extends CharacterBody2D
var collision_count = 0
const SPEED = 250.0
signal healthChanged
@export var maxHealth = 3
@onready var currentHealth: int = maxHealth
@export var knockbackPower: int = 500
@onready var effects = $Effects
@onready var HurtTimer = $HurtTimer
@onready var hurtsound1 = $hurtsound1
func get_input():
	var input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input_dir * SPEED
	
func _physics_process(delta):
	handleCollision()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	#move_and_collide(velocity * delta)
	move_and_slide()
	
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)


func _on_hurtbox_area_entered(area):
	if area.name == "hitBox" or area.name =="hitBox2":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = maxHealth
		healthChanged.emit(currentHealth)
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


func _on_staircase_hitbox_area_entered(area):
	print("hi")


func _on_staircase_hitbox_area_exited(area):
	print("bye")
