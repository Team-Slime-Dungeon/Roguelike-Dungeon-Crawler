extends CharacterBody2D

const SPEED = 250.0

func get_input():
	var input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input_dir * SPEED
	
func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	#move_and_collide(velocity * delta)
	move_and_slide()
