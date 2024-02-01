# Fight Flow:
# 0: Initialize Everything ( Wait for Cutscene Start)
# 1: Fight Started (Cutscene End)

# 2: Slime Wave 1 (2 slimes)
# 3: Boss Slime Animation 1

# 4: Slime Wave 2 (4 slimes)
# 5: Boss Slime Animation 2

# 6: Final Slime Wave (6 slimes)
# 7: Fight ended, Final Cutscene and fade to black (Demo End)

extends Node2D
@onready var anim = get_node("AnimationPlayer")

# The little nooks where the slimes will spawn. They should each get a randomized nook to spawn in
var Slime_Pads = [
				Vector2i(1,-5), Vector2i(1,-6), 
				Vector2i(1,-2), Vector2i(1,-1), 
				Vector2i(1,2), Vector2i(1,3)
				]

var slime_spawns = 0
var minions = []
var current_pad = [] # Stores the working pads so the slimes can spawn in fresh spots
var healthSetupCompleted = false
var slime_kills = 0 
var wave_started = -1 # Flag to ensure state changes once
var fight_state = 0 # Current state of the fight
#var slime_kills = 12
#var wave_started = 3
#var fight_state = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	if not healthSetupCompleted: # Set up health
		$GUI/HeartsContainer.setMaxHearts($Cassandra.maxHealth)
		$GUI/HeartsContainer.updateHearts($Cassandra.currentHealth)
		$Cassandra.healthChanged.connect($GUI/HeartsContainer.updateHearts)
		healthSetupCompleted = true
	if fight_state == 0:
		print("===Setting up fight (Animation Prep)===")
		$Cassandra/Camera2D.offset = Vector2(100,-100)
		$Cassandra.update_camera_scale(1)
		$Cassandra.block_inputs(true)
		$Cassandra.move_character(Vector2(-430,130))
		fight_state = 1
			
	if fight_state == 1 and wave_started == -1:
		print("===Fight Started!===")
		$Big_Slime/MourningTimer.start()
		$Big_Slime/BigAnim.play("mourning")
		await $Big_Slime/MourningTimer.timeout
		print("Animation is done")
		$Big_Slime/BigAnim.play("movement")
		print("Unlocking inputs")
		$Cassandra.block_inputs(false)
		wave_started = 0
		fight_state = 2
			
	if fight_state == 2 and wave_started == 0:
		wave_started = 1
		print("===Slime Wave 1 Start===")
		var slime_pos = Slime_Pads.duplicate()
		
		for i in range(0,2):
			slime_pos.shuffle()
			var enemy_pos = slime_pos[0]
			slime_pos.erase(slime_pos[0])
			
			var enemy = preload("res://monsters/Minion Slime.tscn")
			var enemy_spawn = enemy.instantiate()
		
			minions.append(enemy_spawn)
			add_child(enemy_spawn)
			minions[slime_spawns].global_position = $TileMap.map_to_local(enemy_pos)

			slime_spawns += 1

		# Decrease bosses visible health here
	if fight_state == 3 and wave_started == 1:
		print("===Boss Animation 1===")
		$Big_Slime/MourningTimer.start()
		$Big_Slime/BigAnim.play("mourning")
		await $Big_Slime/MourningTimer.timeout
		print("Animation 1 is done")
		$Big_Slime/BigAnim.play("movement")

		fight_state = 4
		
	if fight_state == 4 and wave_started == 1:
		wave_started = 2
		print("===Slime Wave 2 Start===")
		var slime_pos = Slime_Pads.duplicate()
		
		for i in range(0,4):
			slime_pos.shuffle()
			var enemy_pos = slime_pos[0]
			slime_pos.erase(slime_pos[0])
			
			var enemy = preload("res://monsters/Minion Slime.tscn")
			var enemy_spawn = enemy.instantiate()
		
			minions.append(enemy_spawn)
			add_child(enemy_spawn)
			minions[slime_spawns].global_position = $TileMap.map_to_local(enemy_pos)

			slime_spawns += 1

	elif fight_state == 5:
		print("==Boss Animation 2==")
		$Big_Slime/MourningTimer.start()
		$Big_Slime/BigAnim.play("mourning")
		await $Big_Slime/MourningTimer.timeout
		print("Animation 2 is done")
		$Big_Slime/BigAnim.play("movement")
		fight_state = 6
		
	if fight_state == 6 and wave_started == 2:
		wave_started = 3
		print("==Slime Wave 3 Start==")
		var slime_pos = Slime_Pads.duplicate()
		
		for i in range(0,6):
			slime_pos.shuffle()
			var enemy_pos = slime_pos[0]
			slime_pos.erase(slime_pos[0])
			
			var enemy = preload("res://monsters/Minion Slime.tscn")
			var enemy_spawn = enemy.instantiate()
		
			# Manages all the spawns to remove them when the floor is cleared.
			minions.append(enemy_spawn)
			add_child(enemy_spawn)
			minions[slime_spawns].global_position = $TileMap.map_to_local(enemy_pos)

			slime_spawns += 1
	
	if fight_state == 7 and wave_started == 3:
		wave_started = 4
		print("=== Boss Death Animation ===")
		$WalkTimer.start()
		await $WalkTimer.timeout
		
		$Cassandra.move_character($Cassandra.get_position())
		$Big_Slime/DeathTimer.start()
		$Big_Slime/BigAnim.play("death")
		await $Big_Slime/DeathTimer.timeout
		print("Animation 2 is done, crashing floor.")
		
		var Hole_One = Vector2i(0,7)
		var Hole_Two = Vector2i(1,7)
		var Hole_Three = Vector2i(0,6)
		var Empty_Wall = Vector2i(3,1)
		var Hole_pos = []
		
		for i in range(9,17):
			$TileMap.set_cell(0, Vector2i(-i, -6), 0, Hole_One)		
			$TileMap.set_cell(0, Vector2i(-i, 4), 0, Hole_One)
			Hole_pos.append(Vector2i(-i,-6))
			Hole_pos.append(Vector2i(-i,4))

		$TileMap.set_cell(0, Vector2i(-16, -5), 0, Hole_One)
		Hole_pos.append(Vector2i(-16,-5))
		
		$TileMap.set_cell(0, Vector2i(-16, 3), 0, Hole_One)	
		Hole_pos.append(Vector2i(-16,3))
		
		$TileMap.set_cell(0, Vector2i(-17, -5), 0, Hole_One)
		Hole_pos.append(Vector2i(-17,-5))
		$TileMap.set_cell(0, Vector2i(-17, 3), 0, Hole_One)	
		Hole_pos.append(Vector2i(-17,3))
		
		$TileMap.set_cell(0, Vector2i(-17, -4), 0, Hole_One)
		Hole_pos.append(Vector2i(-17,-4))
		$TileMap.set_cell(0, Vector2i(-17, 2), 0, Hole_One)		
		Hole_pos.append(Vector2i(-17,2))
		
		$TileMap.set_cell(0, Vector2i(-18, -4), 0, Hole_One)
		Hole_pos.append(Vector2i(-18,-4))
		$TileMap.set_cell(0, Vector2i(-18, 2), 0, Hole_One)	
		Hole_pos.append(Vector2i(-18,2))
		$TileMap.set_cell(0, Vector2i(-18, -3), 0, Hole_One)
		Hole_pos.append(Vector2i(-18,-3))
		$TileMap.set_cell(0, Vector2i(-18, 1), 0, Hole_One)	
		Hole_pos.append(Vector2i(-18,1))
		
		for i in range(-3,2):
			$TileMap.set_cell(0, Vector2i(-19, i), 0, Hole_One)
			Hole_pos.append(Vector2i(-19,i))
		
		$Cassandra/Camera2D.offset = Vector2(75,-75)

		$StepTimer.start()
		await $StepTimer.timeout
		for i in range(9,16):
			$TileMap.set_cell(0, Vector2i(-i, -5), 0, Hole_One)
			$TileMap.set_cell(0, Vector2i(-i, 3), 0, Hole_One)
			Hole_pos.append(Vector2i(-i,-5))
			Hole_pos.append(Vector2i(-i, 3))
			
		for i in range(-2,2):
			$TileMap.set_cell(0, Vector2i(-18, i), 0, Hole_One)
			Hole_pos.append(Vector2i(-18,i))
			
		for i in range(-3,2):
			$TileMap.set_cell(0, Vector2i(-17, i), 0, Hole_One)
			Hole_pos.append(Vector2i(-17,i))
			
		for i in range(-4,3):
			$TileMap.set_cell(0, Vector2i(-16, i), 0, Hole_One)	
			Hole_pos.append(Vector2i(-16,i))
			
		for i in range(-4,3):
			$TileMap.set_cell(0, Vector2i(-15, i), 0, Hole_One)	
			Hole_pos.append(Vector2i(-15,i))
		
		$Cassandra/Camera2D.offset = Vector2(25,50)

		$StepTimer.start()
		await $StepTimer.timeout
		for i in range(9,15):
			for j in range(-4,3):	
				$TileMap.set_cell(0, Vector2i(-i,j), 0, Hole_One)
				Hole_pos.append(Vector2i(-i,j))			

		$Cassandra/Camera2D.offset = Vector2(45,-25)
		$StepTimer.start()
		await $StepTimer.timeout
		
		for i in Hole_pos:	
				$TileMap.set_cell(0, i, 0, Hole_Three)
		
		for i in range(-8,1):
			$TileMap.set_cell(0, Vector2i(i,-6), 0, Hole_Three)
			$TileMap.set_cell(0, Vector2i(i,-5), 0, Hole_Three)
			$TileMap.set_cell(0, Vector2i(i,-2), 0, Hole_Three)
			$TileMap.set_cell(0, Vector2i(i,-1), 0, Hole_Three)
			$TileMap.set_cell(0, Vector2i(i,3), 0, Hole_Three)
			$TileMap.set_cell(0, Vector2i(i,4), 0, Hole_Three)
		
		for i in range(-6,5):
			$TileMap.set_cell(0, Vector2i(-9,i), 0, Hole_Three)
		
		for i in range(-7,4):
			$TileMap.set_cell(1, Vector2i(-8,i), 1, Vector2i(-1,-1))
		$Cassandra/Camera2D.offset = Vector2(0,0)
		$Cassandra/AnimationPlayer.play("falling")
		#$Cassandra/Camera2D.offset = Vector2(0,0)

		anim.play("ending")
		await anim.animation_finished
		get_tree().change_scene_to_file("res://MainMenuStart.tscn")
		
func _process(delta):
	for curr_minion in minions:
		if is_instance_valid(curr_minion) and curr_minion.death_location != null:
			curr_minion.enemy_clear()
			slime_kills += 1
			
	if fight_state == 2 and slime_kills == 2:
		fight_state = 3
		print("Slimes Defeated: ", slime_kills)
		_ready()

	elif fight_state == 4 and slime_kills == 6:
		fight_state = 5
		print("Slime Defeated: ", slime_kills)
		_ready()
		# Decrease bosses visible health
		
	elif fight_state == 6 and slime_kills == 12:
		print("BOSS DEFEATED!!!!")
		$Cassandra.block_inputs(true)
		$Cassandra.move_character(Vector2(-425,130),50)
		$Cassandra.update_camera_scale(2)
		fight_state = 7
		_ready()
		# Boss death animation
