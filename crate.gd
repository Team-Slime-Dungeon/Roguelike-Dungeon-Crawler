extends CharacterBody2D
var monster_type = "Chest"
var monster_drops = [0,10,0,10,0,10]

var death_location = null
var chest_opened = false
var player_in_area = false

func _ready():
	pass
	
func _process(delta):		 
	if Input.is_action_just_pressed("interact") and !chest_opened and player_in_area:
		chest_opened = true
		$CrateAnim.play("treasure_open")

func _on_crate_anim_animation_finished(animation):
	if animation == "treasure_open":
		$CrateAnim.play("treasure_break")
	elif animation == "treasure_break":
		death_location = get_position()

func _on_area_2d_body_entered(body):
	if body.name == "Cassandra": 
		print("inside")
		player_in_area = true
		
func _on_area_2d_body_exited(body):
	if body.name == "Cassandra": player_in_area = false
		
func clear_chest():
	queue_free()



