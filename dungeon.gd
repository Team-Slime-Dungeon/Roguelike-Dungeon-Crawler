extends Node2D

var debug = true

var healthSetupCompleted = false
var armorSetup = false
var random = RandomNumberGenerator.new()
var node_pos = [] # keeps track of the root for each room
var room_size = [] # Sister array for node_pos, keeps room sizes for spawning
var hall_pos = [] # for building pathways
var floor_pos = [] # List of floor tiles

var hall_count = 0 # quantity of paths created
var hall_length = 0 # max length for hallways
var room_min = 0 # absolute minimum size for a room
var room_max = 0 # absolute maximum size for a room
var min_path_width = 3 # 2 Walls + Path, rec 3
var max_path_width = 7 # rec 5
var staircase_pos = 0 # selected element in node_pos
var current_floor = 0 # starting floor
var kink_probability = 0.5
var descend = false # check if player stepped on a staircase

var colorDict = {
	1: [.334, .7, .2], # Forest 1
	2: [.537, .722, .282], # Forest 2
	3: [.459, .506, .173], # Forest 3
	4: [.478, .384, .165], # Forest 4
	5: [.502, .267, .161], # Forest Boss
	6: [.365, .353, .447], # Cave 1
	7: [.369, .345, .435], # Cave 2
	8: [.376, .341, .427], # Cave 3
	9: [.38, .333, .42], #Cave 4
	10: [.388, .329, .412], # Cave Boss
	11: [.357, .286, .263], # Prison 1
	12: [.376, .286, .259], # Prison 2
	13: [.396, .286, .259], # Prison 3
	14: [.416, .286, .255], # Prison 4
	15: [.435, .29, .255], # Prison Boss
	16: [.263, .322, .357], # Dungeon 1
	17: [.259, .31, .376], # Dungeon 2
	18: [.259, .298, .396], # Dungeon 3
	19: [.255, .286, .416], # Dungeon 4
	20: [.255, .278, .435], # Dungeon Boss
	21: [.475, .467, .435], # Ancient 1
	22: [.451, .439, .4], # Ancient 2
	23: [.431, .416, .365], # Ancient 3
	24: [.412, .392, .329], # Ancient 4
	25: [.392, .369, .298], # Ancient Boss
}

var dungeon_floor_tiles = [0,2] # IDs for the dungeon floors
var dungeon_wall_tiles = [1,3] # IDs for the dungeon walls
var dungeon_terrains = [0,1] # Terrains for the tiles (seperate or they will connect together

var dungeon_floor = dungeon_floor_tiles[0]
var dungeon_walls = dungeon_wall_tiles[0]
var dungeon_terrain = dungeon_terrains[0]

var monster_spawn_ID = 0
var monster_spawns = []

var item_spawns = []
var item_spawn_ID = 0

var decorative_spawns = []
var deco_spawn_ID = 0

var chest_spawns = []
var chest_spawn_ID = 0

var monster_list = [
	preload("res://monsters/Slime.tscn"),
	preload("res://monsters/Bushmo.tscn"),

	]
var  item_scenes = { 
		0: preload("res://equipment/coin.tscn"), 
		51: preload("res://equipment/treasure_spawns.tscn"),
		71: preload("res://equipment/Blue Mushroom.tscn"),
	}

func _ready():
	current_floor += 1 # when entering the dungeon scene, you have descended once
	
	# Selects the tileset for the current floor
	if current_floor <= 5:
		dungeon_floor = dungeon_floor_tiles[0]
		dungeon_walls = dungeon_wall_tiles[0]
		dungeon_terrain = dungeon_terrains[0]
	else:
		dungeon_floor = dungeon_floor_tiles[1]
		dungeon_walls = dungeon_wall_tiles[1]
		dungeon_terrain = dungeon_terrains[1]

	# Inventory Creation
	#Items.Player_Inventory._add_item(3, 1) # Test helmets
	Items.Player_Inventory._print_inventory()

	clear_room() # clean up for new floor
	
	# Color tiles for all 25 floors
	if current_floor > 0 and current_floor <= 25:
		$TileMap.modulate = Color(
			colorDict[current_floor][0],
			colorDict[current_floor][1],
			colorDict[current_floor][2],
		)
		$FloorTiles.modulate = Color(
			colorDict[current_floor][2],
			colorDict[current_floor][1],
			colorDict[current_floor][0],
		)
		$Staircase/Sprite2D.modulate = Color(
			colorDict[current_floor][0],
			colorDict[current_floor][1],
			colorDict[current_floor][2],
		)
		
	else: $TileMap.modulate = Color(0, 0, 0)
	
	floor_structure() # fill in int
	generate_hallways()
	generate_rooms()
	
	generate_entity() # generate staircase, items
	generate_monsters()
	spawn_chests()
	
	$Cassandra.global_position = Vector2(0,0) # returns player to root room
	$GUI/Current_Floor.set_text("Floor: " + str(current_floor))
	
	# debug info
	$Debug_Hud.visible = debug
	$Debug_Hud/Seed.set_text("Debug " 
		+ "\nnode_pos: " + str(node_pos)
		+ "\nStaircase Position: " + str(node_pos[staircase_pos])
		+ "\nfloor_structure: " + str([hall_count, hall_length, room_min, room_max])) 
	
	# move to function as dev continues
	if not healthSetupCompleted: # Set up health
		$Debug_Hud/HeartsContainer.setMaxHearts($Cassandra.maxHealth)
		$Debug_Hud/HeartsContainer.updateHearts($Cassandra.currentHealth)
		$Cassandra.healthChanged.connect($Debug_Hud/HeartsContainer.updateHearts)
		healthSetupCompleted = true   

	if not armorSetup:
		$GUI/Armor_Durability.setArmor($Cassandra.maxArmor)
		$GUI/Armor_Durability.updateArmor($Cassandra.currentArmor)
		$Cassandra.armorChanged.connect($GUI/Armor_Durability.updateArmor)
		armorSetup = true
	

func _process(delta):
	for monster in monster_spawns:
		if is_instance_valid(monster) and monster.death_location != null:
			generate_loot(monster)
			monster.enemy_clear()
			
	for item in item_spawns:
		if is_instance_valid(item) and item.picked_up != false:
			Items.Player_Inventory._add_item(item.ID, item.amount)
			Items.Player_Inventory._print_inventory()
			item.clear_item()

	for chest in chest_spawns:
		if is_instance_valid(chest) and chest.death_location != null:
			#generate_treasure(chest)
			generate_loot(chest)
			chest.clear_chest()
			
	# Grabs current coin total
	$GUI/Coin_Counter.set_text("Coin: " + str(Items.Player_Inventory._get_coins()))

func _on_staircase_hitbox_area_entered(area): if area == $Cassandra/hurtbox: _ready() 
func _on_new_seed_pressed(): _ready() #debug

func floor_structure():
		hall_count = (current_floor + 3) # num of hallway segments, rec 10
		hall_length = (20) # length of hallway segments, rec 10
		room_min = (5) # min size for rooms, rec 2
		room_max = (10) # max size for rooms, rec 4
		if room_min <= max_path_width : max_path_width = room_min - 1

func generate_entity():
	# finds a random position in the last quarter of node_pos
	staircase_pos = randi() % (node_pos.size() - int(node_pos.size() * 0.75)) + int(node_pos.size() * 0.75)
	
	# converts the tilemap coords to global coords for staircase placement	
	$Staircase.global_position = $TileMap.map_to_local(node_pos[staircase_pos]) / 2
	
func generate_loot(monster):
	# Generates a random item from the loot table depending on your floor. 
	# If no loot table is loaded it defaults to no items spawned!
	
	# Loot table, fill each level with the types of item IDs you want
	var loot_table = [
			[-1],
			[-1,0], 			# Floors 1-5
			[-1,-1,0,0]			# Floors 6-10
		]
	
	# The item scenes sorted by Item_ID. 
	# !! Must have a valid ID (Use the main item table in Inventory.gd !!
	
	# table moved to global
	
	# This gets the current level sets and sets the loot table to the correct table
	var current_level = 1
	if current_floor <= 5: current_level = 1
	elif current_floor > 5 and current_floor <= 10: current_level = 2
	else: current_level = 0 # This will not give any loot!
	
	# Set the current loot table
	var enemy_loot = []
	
	# Adds monster specific drops to the loot table
	if "monster_drops" in monster:
		enemy_loot = monster.monster_drops
	
	# Dropped item text flair
	var monster_type = "Enemy"
	if "monster_type" in monster:
		monster_type = monster.monster_type
		
	var current_level_loot = loot_table[current_level] + enemy_loot

	# Draw an item from the loot table at random
	current_level_loot.shuffle()
	var loot_ID = current_level_loot[0]
	
	if loot_ID == -1: print(monster_type, " has been slain.") # No Drops
	
	# Check to ensure the drawn item ID exists in the item list
	elif Items.Player_Inventory.get_item_name(loot_ID) != "None":
		
		# Display text that changes depending on the rarity of your drop
		if loot_ID > 9: print( monster_type, " dropped a Rare ", Items.Player_Inventory.get_item_name(loot_ID),"!!") # Rare Drop Text
		else: print(monster_type, " dropped a ", Items.Player_Inventory.get_item_name(loot_ID),".") # Common Item Text
	
		# After getting our item, we must generate it in the world
		var new_item_map_location = $TileMap.local_to_map(monster.death_location)
		
		if new_item_map_location in floor_pos or new_item_map_location in hall_pos:
			# get item scene information and create it from slain monster location
			var new_item = item_scenes[loot_ID]
			var new_item_spawn = new_item.instantiate()
			var new_item_location = Vector2i(monster.death_location) / 2
			
			# Manages all the item spawns to remove them when the floor is cleared.
			item_spawns.append(new_item_spawn)
			add_child(new_item_spawn)
				
			item_spawns[item_spawn_ID].global_position = new_item_location

			item_spawn_ID += 1
	else: print("Error Generating Item: Invalid ID in loot table?")

func generate_monsters():	

	# Valid Spawn locations for mobs in rooms
	var spawn_pads_small = [ Vector2i(0,-1), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(0,0),
							 Vector2i(0,-2), Vector2i(1,-2), Vector2i(1,0), Vector2i(-1,-2), Vector2i(-1,0)
							] 
	
	var spawn_pads_medium = [   
							Vector2i(2,-3), Vector2i(2,-2), Vector2i(2,-1),Vector2i(2,0), Vector2i(2,1),
							Vector2i(1,-3), Vector2i(1,-2), Vector2i(1,-1), Vector2i(1,0),  Vector2i(1,1),
							Vector2i(0,-3), Vector2i(0,-2), Vector2i(0,-1), Vector2i(0,0), Vector2i(0,1), 
							Vector2i(-1,-3), Vector2i(-1,-2), Vector2i(-1,-1), Vector2i(-1,0), Vector2i(-1,1),
							Vector2i(-2,-3), Vector2i(-2,-2), Vector2i(-2,-1), Vector2i(-2,0), Vector2i(-2,1)
							]
	
	var spawn_pads = spawn_pads_small.duplicate()
	
	var selected_spawns = [] # Select monsters based on current floor
	
	if current_floor >= 1 or current_floor <= 5: 
		selected_spawns.append(0) # Slime
	# elif current_floor >= 6 or current_floor <= 10:
	#	selected_spawn.append()
	else: selected_spawns.append(0) # Sliiime
	
	if debug == true: print("selected_spawns: ", selected_spawns)

	var spawn_quantity = [0] # Get quantity of monsters per room
	var spawn_type = "None"
	
	for i in range(1, len(node_pos)):
		# Sets the room size and spawn limits
		if room_size[i][1] <= 7:
			spawn_pads = spawn_pads_small.duplicate()
			spawn_quantity.append(random.randi_range(1, 4)) # Spawn between 1 to 4 monsters
			spawn_type = "small"
		else:
			spawn_pads = spawn_pads_medium.duplicate() #medium
			spawn_quantity.append(random.randi_range(1, 6)) # Spawn between 1 to 4 monsters
			spawn_type = "med"

		for j in spawn_quantity[i]: # Load monster per quantity
			# Select a valid spawning location
			spawn_pads.shuffle()
			# Adjust location based on current room's node
			var enemy_pos = Vector2i(spawn_pads[0]) + (node_pos[i] /2)
			#print("---Need ", spawn_quantity[i], " currently on: ",j, " type:", spawn_type)
			
			# Remove the spawn pad so it cannot be reused in the current room
			spawn_pads.erase(spawn_pads[0])
			
			# Make enemy if the location is a floor tile
			if ($TileMap.local_to_map(enemy_pos) in floor_pos):
				var enemy = monster_list[randi() % monster_list.size()]

				var enemy_spawn = enemy.instantiate()
			
				# Manages all the spawns to remove them when the floor is cleared.
				monster_spawns.append(enemy_spawn)

				add_child(enemy_spawn)
				monster_spawns[monster_spawn_ID].global_position = $TileMap.map_to_local(enemy_pos)

				#print("Spawned slime ", monster_spawn_ID, " at location: ", enemy_pos)
				monster_spawn_ID += 1
			else:
				print("Invalid Spawning location")

func generate_hallways():
	var direction = Vector2i(1, 0) #tracks which way the hall segment will travel
	var tile_pos = Vector2i(0, 0) #tracks current tile position
	node_pos.append(tile_pos) #initial room at 0,0

	for j in range(0, hall_count): # this loop makes hallway segments
		
		var row_width = random.randi_range(min_path_width, max_path_width)
		var perpendicular = get_perpendicular_vector(direction)

		#predict where room will be placed, add to node_pos collection
		var room_pos = tile_pos + ((hall_length) * direction)
		if !room_pos in node_pos: node_pos.append(room_pos) # since can overlap, avoid duplicates in list

		for i in range(0, hall_length): # this loop creates 1 segment
			tile_pos += direction
			# create a row of path width
			var row_position = tile_pos - floor(row_width / 2) * perpendicular
			
			# Create the outside wall of path if possible
			if row_position - perpendicular not in hall_pos:
				$TileMap.set_cell(0, row_position - perpendicular, dungeon_walls, Vector2i(0, 0))
			# Create a row of hallway and save it in a list
			for k in range(0, row_width):
				$TileMap.set_cell(0, row_position, dungeon_floor, Vector2i(0, 3))
				hall_pos.append(row_position)
				row_position += perpendicular
	
			#kink probability midway path
			#additional check for paths too small to get through
			if i == floor(hall_length / 2) and random.randf() > kink_probability and row_width > 2:
				$TileMap.set_cell(0, row_position, dungeon_floor, Vector2i(0, 3))
				$TileMap.set_cell(0, row_position + perpendicular - direction, dungeon_walls, Vector2i(0, 0)) #add wall
				$TileMap.set_cell(0, (tile_pos - floor(row_width / 2) * perpendicular) - perpendicular + direction, dungeon_walls, Vector2i(0, 0)) #add wall
				hall_pos.append(row_position)
				row_position += perpendicular
				tile_pos += perpendicular
				
			# Create second hallway wall if possible			
			if Vector2i(row_position) not in hall_pos:
				$TileMap.set_cell(0, row_position, dungeon_walls, Vector2i(0, 0))
				
		tile_pos = room_pos #fixes kink mis-alignment
		direction = get_new_direction(direction) # get a new direction for the next segment

# this function determines the direction of the new hallway segment 
# restriction: new direction should never be the reverse of the previous direction
func get_new_direction(old_direction):
	var directions = [Vector2i(0,1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
	var reverse = -1 * old_direction
	# Remove the reverse of the old direction 
	directions.erase(reverse)
	var new_directions = directions[random.randi_range(0, directions.size() - 1)]
	return new_directions

# this function returns a vector that is perpendicular
# to the passed in vector2i
func get_perpendicular_vector(original):
	var perpen
	if original == Vector2i(1,0) or original == Vector2i(0,-1):
		perpen = Vector2i(-original.y, original.x)
	else: perpen = Vector2i(original.y,-original.x)
	return perpen

func generate_rooms():	
	for i in node_pos:
		var size = random.randi_range(room_min, room_max)
		room_size.append([-size+1,size-1]) # Keep room sizes
		for j in range(-size, size):
			for k in range(-size, size):
				# Walls furthest from camera
				if ((j == -size)) or ((k == size-1)):
					if !(Vector2i(i.x+j,i.y+k)) in hall_pos: 
						$TileMap.set_cell(0, Vector2i(i.x+j, i.y+k), dungeon_walls, Vector2i(0, 0))
				# Walls close to camera
				elif ((j == size-1) or (k == -size)):
					if !(Vector2i(i.x+j,i.y+k)) in hall_pos:
						$TileMap.set_cell(0, Vector2i(i.x+j, i.y+k), dungeon_walls, Vector2i(0, 0))
				# Stores tile location to be connected and draws a tile at the floor location
				else:
					$FloorTiles.set_cell(0, Vector2i(i.x+j, i.y+k), 0, Vector2i(2, 4))
					floor_pos.append(Vector2i(i.x+j,i.y+k))
					
	# Draws all of the saved tiles and connects them together using terrains
	$TileMap.set_cells_terrain_connect(0, floor_pos, 0, dungeon_terrain)

	# Go through each room and decorate them 
	for node_num in range(len(node_pos)):
		# Node #,  Layout Mode, Spawn Chance, Bloom chance
		generate_decorations(node_num, 0, 3) # Mode 0: Whole floor spread
		generate_decorations(node_num, 1, 5,7) # Mode 1: Bloomed spread

func spawn_chests():
	#var chest_scene = [preload("res://treasurechest.tscn")]
	var chests_spawned = 0
	var attempts = 0
	var max_attempts = node_pos.size() * 2 # Prevent infinite loops
	
	while chests_spawned < 2 and attempts < max_attempts:
		var room_index = random.randi_range(0, node_pos.size() - 1)
		var room = node_pos[room_index]
		var size = room_size[room_index]
		var chest_pos = room + Vector2i(random.randi_range(1, size[1] - 2), random.randi_range(1, size[1] - 2))
		print(chest_pos)
		if place_chest_at_location(chest_pos): chests_spawned += 1
		attempts += 1
		
	if chests_spawned < 2: print("Warning: Could only spawn", chests_spawned, "chests.")
	print("Chests Spawned: ", chests_spawned)


func place_chest_at_location(location):
	var chestscene = preload("res://container.tscn")
	
	if location in floor_pos:
		var spawnedChest = chestscene.instantiate()
		
		# Will randomly pick from container types and set
		var container_list = ["Crate","Chest","Vase"]
		var container_type = container_list[randi() % container_list.size()]
		spawnedChest.set_container(container_type)
		
		chest_spawns.append(spawnedChest)
		add_child(spawnedChest)
		
		chest_spawns[chest_spawn_ID].global_position = $TileMap.map_to_local(location) / 2

		chest_spawn_ID += 1
		return true
	return false

func generate_treasure(chest):
	# Insert treasure based on current floor and rarity.
	# For now, gives coin.
	Items.Player_Inventory._add_item(0, 10)

func generate_decorations(node_num,pad_mode=0,spawn_chance=1,bloom_chance=0):
	var node = node_pos[node_num]
	var size = room_size[node_num]
	var size_type = ""
	# Scenes for different sized decorations
	var small_decorations = [preload("res://environment/Cave_One_Small_Decorations.tscn")]
	var medium_decorations = [preload("res://environment/Cave_One_Medium_Decorations.tscn"), preload("res://environment/Merchant_Shop.tscn")]
	var large_decorations = []
	
	var medium_attempts = 1

	if size[1] < 7:
		print("Small room",node,size)
		size_type = "Small"

	elif size[1] >= 7 and size[1] <= 8:
		print("Medium room",node,size)
		size_type = "Medium"
		medium_attempts = 2
	else:
		print("Large room",node,size)
		size_type = "Large"
		medium_attempts = 3
	
	# Small decorations, each tile is a spawn zone
	if pad_mode == 0: 
		var single_spawn_pads = []
		
		# Select the floor tiles in the room
		for i in range(size[0],size[1]):
			for j in range(size[0],size[1]):
				var location = node + Vector2i(i,j)
				single_spawn_pads.append(location)

		# Randomly select tiles and decorations and spawn them in
		for i in single_spawn_pads:
			decoration_check(spawn_chance, i, small_decorations[0])

	# Medium decorations, 4 spawn zones
	elif pad_mode == 1:
		var medium_spawn_pads = [[],[],[],[]]
		var med_pad_size = size[1] - 1

		# Create all four spawning zones
		for i in range(1,med_pad_size):
			for j in range(1,med_pad_size):
				var location = node + Vector2i(i,j)
				medium_spawn_pads[0].append(location)
				
				location = node + Vector2i(-i-1,j)
				medium_spawn_pads[1].append(location)

				location = node + Vector2i(i,-j-1)
				medium_spawn_pads[2].append(location)

				location = node + Vector2i(-i-1,-j-1)
				medium_spawn_pads[3].append(location)
		
		# Attempt to select (medium_attempts) spots and spawn medium sized decorations
		for pads in medium_spawn_pads:
			pads.shuffle()
			
			for attempts in range(medium_attempts):
				var chosen = pads[0]
				if chosen in pads:
####### TODO: Change so instead it adds area around chosen pad for bloom instead of removing
					medium_decorations.shuffle()
					if decoration_check(spawn_chance, chosen, medium_decorations[0]):
						pads.erase(chosen)
					
						if size_type != "Small":
							chosen = chosen + Vector2i(0,1)
							if chosen in pads: pads.erase(chosen)
							chosen = chosen + Vector2i(-1,0)
							if chosen in pads: pads.erase(chosen)	
							chosen = chosen + Vector2i(0,-1)
							if chosen in pads: pads.erase(chosen)
					
						# If bloom is enabled it will fill out the remaining selected spots with small decorations
						if bloom_chance != 0:
							for location in pads:
								decoration_check(bloom_chance, location, small_decorations[0])

	# Large decorations, 2 zones L-R
	elif pad_mode == 2:
		var large_spawn_pads = [[],[]]
		print("large deco mode LR")
	
	# Large decorations, 2 zones U-D
	elif pad_mode == 3:
		var large_spawn_pads = [[],[]]
		print("large deco mode UD")
	
	# Single giant spawn
	elif pad_mode == 4:
		var large_spawn_pads = []
		print("Giant spawn")

# function that spawns a decoration after passing a check
func decoration_check(chance, location, decoration_scene):
	var deco_chance = random.randf_range(0,101)
	

	if deco_chance <= chance:
		var decoration = decoration_scene.instantiate()
	
		# Manages all the spawns to remove them when the floor is cleared.
		decorative_spawns.append(decoration)

		add_child(decoration)
		decorative_spawns[deco_spawn_ID].global_position = $TileMap.map_to_local(location) / 2
		
		deco_spawn_ID += 1
		
		return true
	return false

func clear_room(): 
	node_pos = []
	hall_pos = []
	floor_pos = []
	room_size = []

	# Clear all of the created monster children (noooo!!!!) DIE >:)
	if monster_spawns != []:
		#if debug == true: print("monster_spawns: ", monster_spawns)
		for i in len(monster_spawns):
			if is_instance_valid(monster_spawns[i]): monster_spawns[i].queue_free()

	if item_spawns != []:
		for i in len(item_spawns):
			if is_instance_valid(item_spawns[i]): item_spawns[i].queue_free()
	
	if decorative_spawns != []:
		for i in len(decorative_spawns):
			if is_instance_valid(decorative_spawns[i]): 
				if "spawns_objects" in decorative_spawns[i]:
					decorative_spawns[i].clear_spawns()
				decorative_spawns[i].queue_free()

	if chest_spawns != []:
	#	for i in chest_spawns.size() - 1:
	#		if is_instance_valid(chest_spawns[i]):
	#			chest_spawns[i].queue_free()
		for i in len(chest_spawns):
			if is_instance_valid(chest_spawns[i]): chest_spawns[i].queue_free()
			
	# Reset the monster spawn system
	monster_spawns = []
	monster_spawn_ID = 0

	item_spawns = []
	item_spawn_ID = 0
	
	decorative_spawns = []
	deco_spawn_ID = 0
	
	chest_spawns = [] # Reset the array tracking chest spawns
	chest_spawn_ID = 0 # Reset the ID if you're using it
	$TileMap.clear()
	$FloorTiles.clear()
	
	#for i in range(-100, 100): # higher wall generation
	#	for j in range(-100, 100):
	#		$TileMap.set_cell(0, Vector2i(i,j), 1, Vector2i(3, 0))
	
	#if current_floor == 6:
		#get_tree().change_scene_to_file("res://environment/Boss Fight 1.tscn")
		
