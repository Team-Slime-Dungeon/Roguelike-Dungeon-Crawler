extends Skeleton2D
var collision_count = 0
var move_speed = 100  # Adjust the movement speed as needed
@onready var anim = get_node("AnimationPlayer")
@onready var weapon = $hip_bone/chest_bone/arm_left_bone/arm_left_upper/weapon #fetches weapoon sprite

# Add a variable to track the player's last movement direction
var last_direction = Vector2(1, 0)  # Initialize it to face right
var isAttacking: bool = false #variable that tracks player state
func _process(delta):
	var move_direction = Vector2(0, 0)

	# Check for user input (arrow keys)
	if Input.is_action_pressed("ui_left"):
		move_direction.x -= 1
		last_direction = Vector2(-1, 0)  # Update the last_direction when moving left
		# Check for double input and display appropriate animation
		if Input.is_action_pressed('ui_up'):
			anim.play("walking_left_up")
		elif Input.is_action_pressed("attack"):
			anim.play("attacking_left")
			weapon.visible = true
			isAttacking = true
			await anim.animation_finished
			weapon.visible = false
			isAttacking = false
		else:
			anim.play("walking_left")
		
	elif Input.is_action_pressed("ui_right"):
		move_direction.x += 1
		last_direction = Vector2(1, 0)  # Update the last_direction when moving right
		# Check for double input and display appropriate animation
		if Input.is_action_pressed('ui_up'):
			anim.play("walking_right_up")
		elif Input.is_action_pressed("attack"):
			anim.play("attacking_right")
			weapon.visible = true
			isAttacking = true
			await anim.animation_finished
			weapon.visible = false
			isAttacking = false
		else:
			anim.play("walking_right")
		
	else:
		# No horizontal movement input, play the appropriate idle animation
		if last_direction.x < 0 and isAttacking == false:
			anim.play("idle_left")
		elif last_direction.x > 0 and isAttacking == false:
			anim.play("idle_right")

	if Input.is_action_pressed("ui_up"):
		move_direction.y -= 1
		# Check for double input and display appropriate animation
		if last_direction.x < 0:
			anim.play("walking_left_up")
		elif last_direction.x > 0:
			anim.play("walking_right_up")
		else:
			anim.play("walking_left")
			
	elif Input.is_action_pressed("ui_down"):
		move_direction.y += 1
		# Check for double input and display appropriate animation
		if last_direction.x < 0:
			anim.play("walking_left")
		elif last_direction.x > 0:
			anim.play("walking_right")
	#function for attack		
	elif Input.is_action_pressed("attack"):
		if last_direction.x < 0:
			anim.play("attacking_left") #plays attacking_left if facing left
		elif last_direction.x > 0:
			anim.play("attacking_right") #plays attack_righ if facing right
		weapon.visible = true 
		isAttacking = true #sets the attack state to true
		await anim.animation_finished 
		weapon.visible = false 
		isAttacking = false #sets the attack state to false after attack animation is finished
	
	# Animation stops if there is no input
	if move_direction.length() == 0:
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
