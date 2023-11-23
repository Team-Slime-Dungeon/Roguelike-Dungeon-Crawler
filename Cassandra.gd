extends Skeleton2D
var collision_count = 0
@onready var weapon = $hip_bone/chest_bone/arm_left_bone/arm_left_upper/weapon
@onready var animation_tree = $AnimationTree
var move_direction = Vector2(0, 0)

func _ready():
	animation_tree.active = true

func _process(delta):
	update_animation_parameter()
		
func _physics_process(_delta):
	#for proper movement and animations, you must press the "wasd" keys instead of the arrow keys
	
	move_direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	if Input.is_action_pressed("right"):
		move_direction.x += 1
	if Input.is_action_pressed("left"):
		move_direction.x -= 1
	if Input.is_action_pressed("up"):
		move_direction.y -= 1
	if Input.is_action_pressed("down"):
		move_direction.y += 1
		
	#print(direction.length())
	
	
func update_animation_parameter():
	if(move_direction.length() == 0):
		animation_tree["parameters/conditions/idle"] = true	
		animation_tree["parameters/conditions/is_moving"] = false
		#print("not moving")
		
	else:
		#print("is moving")
		animation_tree["parameters/conditions/idle"] = false	
		animation_tree["parameters/conditions/is_moving"] = true
		
	if(Input.is_action_pressed("attack")):
		animation_tree["parameters/conditions/attack"] = true
		weapon.visible = true
	else:
		animation_tree["parameters/conditions/attack"] = false
		weapon.visible = false
	
	if(move_direction != Vector2(0,0)):
		animation_tree["parameters/attack/blend_position"] = move_direction
		animation_tree["parameters/idle/blend_position"] = move_direction
		animation_tree["parameters/walk/blend_position"] = move_direction
