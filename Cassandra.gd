extends Skeleton2D

var move_speed = 100  # Adjust the movement speed as needed
@onready var anim = get_node("AnimationPlayer")
func _process(delta):
	# Initialize movement direction
	var move_direction = Vector2(0, 0)
	
	
	
	# Check for user input (arrow keys)
	
	if Input.is_action_pressed("ui_left"):
		move_direction.x -= 1
		
		#checks if there is double input and displays appropriate animation
		if Input.is_action_pressed('ui_up') and Input.is_action_pressed("ui_left"):
			anim.play("walking_left_up")
		
		else:
			anim.play("walking_left")
			
	if Input.is_action_pressed("ui_right"):
		move_direction.x += 1
		
		#checks if there is double input and displays appropriate animation
		if Input.is_action_pressed('ui_up') and Input.is_action_pressed("ui_right"):
			anim.play("walking_right_up")
		else:
			anim.play("walking_right")
			
	if Input.is_action_pressed("ui_up"):
		move_direction.y -= 1
		
		#checks if there is double input and checks which two inputs they are and displays appropriate animation
		if Input.is_action_pressed('ui_up') and Input.is_action_pressed("ui_left"):
			anim.play("walking_left_up")
		elif Input.is_action_pressed('ui_up') and Input.is_action_pressed("ui_right"):
			anim.play("walking_right_up")
		else:
			anim.play("walking_left")
			
	if Input.is_action_pressed("ui_down"):
		move_direction.y += 1
		
		#checks if there is double input and displays appropriate animation
		if Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_down"):
			anim.play("walking_left")
		else:
			anim.play("walking_right")
		
	
	#animation stops if there is no input	
	if move_direction.length() == 0:
		anim.play("idle")
		
	
	
	# Normalize the movement direction (optional)
	if move_direction.length() > 0:
		move_direction = move_direction.normalized()
		

	# Update the position of the skeleton
	var new_position = position + move_direction * move_speed * delta
	set_position(new_position)

	
