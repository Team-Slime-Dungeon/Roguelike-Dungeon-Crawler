class_name monster extends Node2D

var random = RandomNumberGenerator.new()
var Monsters_Spawned = 0 # Calculate how many monsters will generate on map
var Monster = {} # Randomly choose which will spawn on map

var monster_name = "" # ID
var monster_hp = 0 # Hits til death
var monster_atk = 0 # Hits on player
var monster_effect = "" # Special effects such as poisoning
var monster_pos = [] # Put em in

var monster_list = {
	# ID, Name, HP, Attack, Effect, Pos
	0 : ["Slime", 10, 10, null, [0,0]],
	1 : ["Spider", 15, 15, null, [0,0]],
	2 : ["Marshmallow", 20, 20, null, [0,0]]
}

func _ready(spawned_monsters={}):
	if spawned_monsters != {}: # Check if loaded save already had monsters
		print("Monsters returned.")
		Monster = spawned_monsters
	else: Monster = {}

func _save_spawns():
	return Monster
	
func _load_spawns(spawned_monsters):
	Monster = spawned_monsters
	
func _debug_monster_list():
	for i in Monster:
		print(monster_list[i])
		
func _spawn(node_pos):
	var spawn_quantity = [0]
	# Determine how many monsters will spawn in each room
	# Root room will be empty
	for i in len(node_pos)-1: 
		spawn_quantity.append(random.randi_range(1, 4)) # Spawn up to 4 Monsters
	#print("spawn_quantity: ", spawn_quantity) # Debug
	
	return spawn_quantity
	
func _process(delta):
	pass
