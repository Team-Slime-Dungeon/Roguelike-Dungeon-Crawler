extends CharacterBody2D

var monster_type = "CONTAINER"
var monster_drops = []

var shop_item = false
var death_location = null

var amount = 1

var chest_opened = false
var player_in_area = false
var container_open_count = {}  # Tracks how many times a container has been opened
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
		monster_drops = [51,51,51,51]
		
		open_anim = "treasure_open"
		animation_player = $chest_anim
		
		$chest.visible = true
		$crate.visible = false
		$vase.visible = false
	
	elif type == "Crate":
		monster_type = "Crate"
		monster_drops = [51,51,51,51]
		
		open_anim = "crate_open"
		animation_player = $crate_anim
		$chest.visible = false
		$crate.visible = true
		$vase.visible = false
		
	elif type == "Vase":
		monster_type = "Vase"
		monster_drops = [0,0,51,71]

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
		 
	if container_type == "Chest" and Input.is_action_just_pressed("interact") and !chest_opened and player_in_area:
		chest_opened = true
		animation_player.play(open_anim)
		
func handle_container_interaction(area_name, container_name):
	if container_name in ["Crate", "Vase"]:
		if container_open_count.get(container_name) == null:
			container_open_count[container_name] = 0
		# Check the interaction count to determine the animation
		if container_open_count[container_name] == 0:
			# Play the "open" animation for the first interaction
			animation_player.play(container_name.to_lower() + "_open")
			container_open_count[container_name] += 1  # Increment the interaction count
		elif container_open_count[container_name] == 1:
			# Play the "break" animation for the second interaction
			animation_player.play(container_name.to_lower() + "_break")
			container_open_count[container_name] += 1  # Increment the interaction count

func _on_chest_anim_animation_finished(animation):
	if animation == "treasure_open":
		animation_player.play("treasure_break")
	elif animation == "treasure_break":
		death_location = get_position()

func _on_crate_anim_animation_finished(animation):
	if animation == "crate_break":
		death_location = get_position()

func _on_vase_anim_animation_finished(animation):
	if animation == "vase_break":
		death_location = get_position()
		
func _on_area_2d_area_entered(area):
	var area_name = area.name
	if area_name == "weapon" or area_name == "Shuriken":
		handle_container_interaction(area_name, container_type)

func _on_area_2d_body_entered(body):
	if body.name == "Cassandra": player_in_area = true
		
func _on_area_2d_body_exited(body):
	if body.name == "Cassandra": player_in_area = false
		
func clear_chest():
	queue_free()





