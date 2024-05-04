extends Node2D
var Boss_Colors = [.537, .722, .282]

var healthSetupCompleted = false
var fight_state = 0
var king_slime = null
var death_location = null
var midfight = false
var end_fight = false
var monster_spawns = []

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
	
	# Spawns baby slimes
	if $Boss_Scene.currentHealth <= 10 and midfight == false: 
		midfight = true
		for i in range(10):
			var scene = preload("res://monsters/Slime.tscn")
			var slime = scene.instantiate()
			monster_spawns.append(slime)
			add_child(slime)
			monster_spawns[i] = $BossFloor.map_to_local(Vector2i(5+i, 20+i))
	
	# Removes all slimes and monsters
	for monster in monster_spawns:
		if is_instance_valid(monster) and monster.death_location != null:
			monster.enemy_clear()
	
	if $Boss_Scene.currentHealth <= 0 and fight_state < 99:
		print("Changing State")
		fight_state = 99
		_ready()
