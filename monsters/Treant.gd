extends CharacterBody2D

var random = RandomNumberGenerator.new()
enum MovementState { LEFT, RIGHT }

var player_chase = false
var currentHealth: int = 3
var death_location = null

#@onready var slimedeathsound = $slimedeathsound
#@onready var slimehitsound  = $slimehitsound

var player = null
var monster_type = "Tree?"

var Body_Color
var Eye_Color
var Detail_Color

var tree_index
var direction
var tree_type
var tree_can_turn = false#true # Change to false so that the tree sits still

func _ready():
	direction = randi_range(0,1) # Left or Right
	tree_type = randi_range(0,3) # Decorations 0,1,2, Attack 3
	
	# Set the tree's base image based on what type of tree it is and the direction it is facing
	match tree_type:
		0:	
			if direction == 0:
				tree_index = 0
			else: 
				tree_index = 1
		1:
			if direction == 0:
				tree_index = 2
			else:
				tree_index = 3
		2:
			if direction == 0:
				tree_index = 4
			else:
				tree_index = 5
		3: # Attacking Tree
			if direction == 0:
				tree_index = 6
			else:
				tree_index = 9
			$hitBox.set_collision_layer_value(1,true) # Turns on hitbox
	$Body.frame = tree_index

	# Attacking tree is generated and turned Idle	
	if tree_type == 3:
		if direction == 0:
			$TreantAnim.play("Idle_Left")
		else:
			$TreantAnim.play("Idle_Right")

	#var Body_Color_Vals = [randf_range(.25,1),randf_range(.25,1),randf_range(.25,1)]
	#var Detail_Color_Vals = [Body_Color_Vals[0]/randi_range(1,3),Body_Color_Vals[1]/randi_range(1,3),Body_Color_Vals[2]/randi_range(1,3)]
		
	#Body_Color = Color(Body_Color_Vals[0],Body_Color_Vals[1],Body_Color_Vals[2])
	#Detail_Color  = Color(Detail_Color_Vals[0],Detail_Color_Vals[1],Detail_Color_Vals[2])

	# Eye Color Coloring, if needed uncomment later
	#var color_sum = 0
	#for i in Body_Color_Vals:
	#	color_sum += i

	# Lighter Color Eyes when the slime body is below minimum value
	#if color_sum < 1.0:
	#	$Eyes.modulate = Detail_Color
	# Darker Color Eyes
	#else:
	#$Eyes.modulate = Color(0,0,0)

	#set_color(Body_Color,Detail_Color)
	
#func set_color(body_color=null,detail_color=null):
#	if body_color != null:
#		$Body.modulate = body_color

#	if detail_color != null:
#		$Details.modulate = detail_color

func _physics_process(delta):		
	if player_chase:	
		if tree_type == 3:
			if direction == 0:
				$TreantAnim.play("Attack_Left")
			else:
				$TreantAnim.play("Attack_Right")
	else:
		if tree_can_turn == true and tree_type == 3:
			var change_dir_chance = randi_range(0,20)
			if change_dir_chance == 7:
				if direction == 0: 
					direction = 1			
					$TreantAnim.play("Idle_Right")
				else: 
					direction = 0
					$TreantAnim.play("Idle_Left")
func clear_item():
	queue_free()

func _on_detectionarea_body_entered(body):
	if body.name == "Cassandra":
		player = body
		player_chase = true

func _on_detectionarea_body_exited(body):
	if body.name == "Cassandra":
		player = null
		player_chase = false
		print("Player lost.")
		
		if tree_type == 3:
			if direction == 0:
				$TreantAnim.play("Idle_Left")
			else:
				$TreantAnim.play("Idle_Right")
