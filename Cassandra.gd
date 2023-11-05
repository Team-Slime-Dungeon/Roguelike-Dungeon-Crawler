extends Skeleton2D
var collision_count = 0
var move_speed = 100  # Adjust the movement speed as needed
@onready var anim = get_node("AnimationPlayer")
@onready var weapon = $hip_bone/chest_bone/arm_left_bone/arm_left_upper/weapon #fetches weapoon sprite

# Add a variable to track the player's last movement direction
var last_direction = Vector2(1, 0)  # Initialize it to face right
var isAttacking: bool = false #variable that tracks if player is attacking
var isWalking: bool = false #variable that tracks if player is walking

func _process(delta):
	var move_direction = Vector2(0, 0)

	# Check for user input (arrow keys)
	if Input.is_action_pressed("ui_left"):
		move_direction.x -= 1
		isWalking = true #player is walking, player state changes to true
		last_direction = Vector2(-1, 0)  # Update the last_direction when moving left
		
		# Check for double input and display appropriate animation
		if Input.is_action_pressed('ui_up') and isAttacking == false: #player is not attacking
			anim.play("walking_left_up")
		elif Input.is_action_pressed('ui_up') and isAttacking == true:
			anim.play("attack_walking_left_up")
			weapon.visible = true
			await anim.animation_finished 
			weapon.visible = false 
			isAttacking = false #sets the attack state to false after attack animation is finished
			print(isAttacking)
		elif isAttacking == true and isWalking == true: #player is attacking while walking
			print(isAttacking)
			anim.play("attack_walking_left")
			weapon.visible = true #weapon is visible when attacking
			await anim.animation_finished #waits until animation is finished,then...
			weapon.visible = false #weapon is not visible if player is not attacking
			isAttacking = false # attack player state swithes back to false once animation is over
			
	
		else:
			anim.play("walking_left")
		
	if Input.is_action_pressed("ui_right"):
		move_direction.x += 1
		isWalking = true
		last_direction = Vector2(1, 0)  # Update the last_direction when moving right
		
		# Check for double input and display appropriate animation
		if Input.is_action_pressed('ui_up') and isAttacking == false: #player is not attacking
			anim.play("walking_right_up")
		elif Input.is_action_pressed('ui_up') and isAttacking == true:
			anim.play("attack_walking_right_up")
			weapon.visible = true
			await anim.animation_finished 
			weapon.visible = false 
			isAttacking = false #sets the attack state to false after attack animation is finished
			print(isAttacking)	
		elif isAttacking == true and isWalking == true: #player is attacking while walking
			print(isAttacking)
			anim.play("attack_walking_right")
			weapon.visible = true
			await anim.animation_finished
			weapon.visible = false
			isAttacking = false
		else:
			anim.play("walking_right")
		


	if Input.is_action_pressed("ui_up"):
		move_direction.y -= 1
		isWalking = true
		
		
		# Check for double input and display appropriate animation
		if last_direction.x < 0 and isAttacking == false:
			anim.play("walking_left_up") 
		
		elif last_direction.x > 0 and isAttacking == false:
			anim.play("walking_right_up")
		elif isAttacking == true and last_direction.x < 0 and isWalking == true and move_direction.y == -1:
			anim.play("attack_walking_left_up")
			weapon.visible = true
			await anim.animation_finished 
			weapon.visible = false 
			isAttacking = false #sets the attack state to false after attack animation is finished
			print(isAttacking)
		elif isAttacking == true and last_direction.x > 0 and isWalking == true and move_direction.y == -1:
			anim.play("attack_walking_right_up")
			weapon.visible = true 
			await anim.animation_finished 
			weapon.visible = false 
			isAttacking = false #sets the attack state to false after attack animation is finished
			print(isAttacking)
		
		else:
			anim.play("walking_left")
			
	if Input.is_action_pressed("ui_down"):
		move_direction.y += 1
		
		isWalking = true
		
		# Check for double input and display appropriate animation
		if last_direction.x < 0 and isAttacking == false:
			anim.play("walking_left")
			print(isAttacking)
		elif last_direction.x > 0 and isAttacking ==false:
			anim.play("walking_right")
			print(isAttacking)
		elif isAttacking == true and last_direction.x < 0 and isWalking == true and move_direction.y == 1:
			anim.play("attack_walking_left")
			weapon.visible = true
			await anim.animation_finished 
			weapon.visible = false 
			isAttacking = false #sets the attack state to false after attack animation is finished
			print(isAttacking)
		elif isAttacking == true and last_direction.x > 0 and isWalking == true and move_direction.y == 1:
			anim.play("attack_walking_right")
			weapon.visible = true 
			await anim.animation_finished 
			weapon.visible = false 
			isAttacking = false #sets the attack state to false after attack animation is finished
			print(isAttacking)
	
	#condition for attacking	
	if Input.is_action_pressed("attack"):
		weapon.visible = true 
		isAttacking = true #sets the attack state to true
		
		if last_direction.x < 0 and isWalking == false:
			anim.play("attacking_left") #plays attacking_left if facing left
			print(isAttacking)
		elif last_direction.x > 0 and isWalking == false:
			anim.play("attacking_right") #plays attack_right if facing right
			print(isAttacking)
		
		await anim.animation_finished 
		weapon.visible = false 
		isAttacking = false #sets the attack state to false after attack animation is finished
	
	# Animation stops if there is no input
	if move_direction.length() == 0:
		isWalking = false
		if isAttacking:
			return #exits condition if player is attacking
		elif last_direction.x < 0:
			anim.play("idle_left")
		elif last_direction.x > 0:
			anim.play("idle_right")

	# Normalize the movement direction (optional)
	if move_direction.length() > 0:
		move_direction = move_direction.normalized()

	# Update the position of the skeleton
	#var new_position = position + move_direction * move_speed * delta
