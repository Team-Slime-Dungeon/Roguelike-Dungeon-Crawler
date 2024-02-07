extends CharacterBody2D
var monster_type = "CONTAINER"
var monster_drops = []

var death_location = null
var chest_opened = false
var player_in_area = false

var container_type = "None"

# Animation Placeholders
var open_anim = "treasure_open"
@onready var animation_player

func _ready():
	pass

func set_container(type="Chest"):
	# This function will set the graphics and animations for the spawned container. 
	# You can set loot here too. If no container type is set all default to chests for now.
	if type == "Chest":
		monster_type = "Chest"
		monster_drops = [0,0,0,0,0]
		
		open_anim = "treasure_open"
		animation_player = $chest_anim
		
		$chest.visible = true
		$crate.visible = false
		$vase.visible = false
	
	elif type == "Crate":
		monster_type = "Crate"
		monster_drops = [0,0,0,0,10,10]
		
		open_anim = "crate_open"
		animation_player = $crate_anim
		$chest.visible = false
		$crate.visible = true
		$vase.visible = false
		
	elif type == "Vase":
		monster_type = "Vase"
		monster_drops = [10,0,10,0,0]
		
		open_anim = "vase_open"
		animation_player = $vase_anim
		
		$chest.visible = false
		$crate.visible = false
		$vase.visible = true
		
	container_type = type
	
func _process(delta):
	# Sets the container if it has not been yet.
	if container_type == "None":
		set_container()
		 
	if Input.is_action_just_pressed("interact") and !chest_opened and player_in_area:
		chest_opened = true
		animation_player.play(open_anim)

func _on_chest_anim_animation_finished(animation):
	if animation == "treasure_open":
		animation_player.play("treasure_break")
	elif animation == "treasure_break":
		death_location = get_position()

func _on_crate_anim_animation_finished(animation):
	if animation == "crate_open":
		animation_player.play("crate_break")
	elif animation == "crate_break":
		death_location = get_position()

func _on_vase_anim_animation_finished(animation):
	if animation == "vase_open":
		animation_player.play("vase_break")
	elif animation == "vase_break":
		death_location = get_position()

func _on_area_2d_body_entered(body):
	if body.name == "Cassandra": player_in_area = true
		
func _on_area_2d_body_exited(body):
	if body.name == "Cassandra": player_in_area = false
		
func clear_chest():
	queue_free()









