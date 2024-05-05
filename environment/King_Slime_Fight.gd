extends Node2D
var Boss_Colors = [.537, .722, .282]

var healthSetupCompleted = false
var fight_state = 0
var king_slime = null
var death_location = null
var midfight = false
var end_fight = false

var enemy_spawn_pads = []
var support_spawn_pads = []

var monster_spawns = []
var total_spawns = 0

var support_spawns = []
var support_totals = 0

#var score = preload("res://score.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	# Color the tiles used for the Boss Fight
	$BossDeco.modulate = Color(
		Boss_Colors[0],
		Boss_Colors[1],
		Boss_Colors[2],
	)

	$BossFloor.modulate = Color(
		Boss_Colors[2],
		Boss_Colors[1],
		Boss_Colors[0],
	)
	## Fill spawn locations for the slimes
	if fight_state == 0 and end_fight == false:
		# Inside skull
		for i in range(12,15):
			for j in range(20,23):
				enemy_spawn_pads.append(Vector2i(i,j))
		# Top left side
		for i in range(13,20):
			enemy_spawn_pads.append(Vector2(i,0))
		# Top right side
		for i in range(13,21):
			enemy_spawn_pads.append(Vector2(i,8))
			
		for i in range(-8,8):
			for j in range(8,18):
				enemy_spawn_pads.append(Vector2i(i,j))

		# Spawn locations for the support items		
		for i in range(-3,10):
			support_spawn_pads.append(Vector2i(i,-4))
			
		for i in range(14,19):
			support_spawn_pads.append(Vector2i(i,-2))
		
		for i in range(12,16):
			support_spawn_pads.append(Vector2i(9,i))
		
		for i in range(4,8):
			support_spawn_pads.append(Vector2i(-10,i))
		
		for i in range(17,21):
			support_spawn_pads.append(Vector2i(-10,i))
		
		place_supports(3, [0, 30])
		place_supports(3, [0, 0, 30, 51])
		
		# Begin fight
		fight_state = 1
		
			
	if fight_state == 99 and end_fight == false:
		$Boss_Scene/AnimationPlayer.play("death")
		await $Boss_Scene/AnimationPlayer.animation_finished
		#print("animation finished")
		fight_state = 100
		#print("running score")
		end_fight = true

	if fight_state == 100 and end_fight == true:
		#print("starting credits.")
		fight_state = 101
		get_tree().change_scene_to_file("res://score.tscn")
	#$"../Cassandra".update_camera_scale(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	for spawneditem in support_spawns:
		if is_instance_valid(spawneditem) and spawneditem.picked_up != false:
			Items.Player_Inventory._add_item(spawneditem.ID, spawneditem.amount)
			Items.Player_Inventory._print_inventory()
			spawneditem.clear_item()		
	
	# Spawns baby slimes
	#if $Boss_Scene.currentHealth <= 10 and midfight == false:
	if $Boss_Scene.currentHealth <= 12 and midfight == false:  
		midfight = true
		print("Spawning in minion wave 1")
		spawn_slimes(3)
		place_supports(3, [0, 30])
		place_supports(3, [0, 0, 30, 51])
		fight_state = 2

	if $Boss_Scene.currentHealth <= 8 and fight_state == 2:
		print("Spawning in minion wave 2")
		spawn_slimes(3)
		place_supports(4, [0, 30])
		place_supports(4, [0, 0, 30, 51])
		fight_state = 3
	
	if $Boss_Scene.currentHealth <= 4 and fight_state == 3:
		print("Spawning in minion wave 3")
		spawn_slimes(4)
		place_supports(6, [0, 30])
		place_supports(6, [0, 0, 30, 51])
		fight_state = 4
	
	# Removes all slimes and monsters
	for monster in monster_spawns:
		if is_instance_valid(monster) and monster.death_location != null:
			monster.enemy_clear()
	
	if $Boss_Scene.currentHealth <= 0 and fight_state < 99:
		print("Changing State")
		fight_state = 99
		_ready()

func spawn_slimes(spawn_num):
	for i in range(spawn_num):
		var scene = preload("res://monsters/Slime.tscn")
		var slime = scene.instantiate()
		slime.set_detection_radius(4)
		
		#enemy_spawn_pads.shuffle()
		#var spawn_spot = enemy_spawn_pads[0] / 2
		var spawn_spot = enemy_spawn_pads[randi() % enemy_spawn_pads.size()]
		enemy_spawn_pads.erase(spawn_spot)
			
		monster_spawns.append(slime)
		add_child(slime)

		monster_spawns[total_spawns].global_position = $BossDeco.map_to_local(spawn_spot) / 2
		total_spawns += 1

func place_supports(vase_num, loot_table = [0,30]):
	for i in range(vase_num):
		loot_table.shuffle()
		var loot_ID = loot_table[0]
		
		var support_scene = Items.Player_Inventory.Item_Scenes[loot_ID]
		
		var spawnedItem = support_scene.instantiate()
		
		var spawn_spot = support_spawn_pads[randi() % support_spawn_pads.size()]
		support_spawn_pads.erase(spawn_spot)

		support_spawns.append(spawnedItem)
		add_child(spawnedItem)
			
		support_spawns[support_totals].global_position = $BossFloor.map_to_local(spawn_spot) / 2
		print("Spawned item at actual:", support_spawns[support_totals].global_position)
		support_totals += 1
