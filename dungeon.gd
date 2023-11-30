extends Node2D

var debug = true

var healthSetupCompleted = false

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

var dungeon_floor_tiles = [0,2] # IDs for the dungeon floors
var dungeon_wall_tiles = [1,3] # IDs for the dungeon walls
var dungeon_terrains = [0,1] # Terrains for the tiles (seperate or they will connect together

var dungeon_floor= dungeon_floor_tiles[0]
var dungeon_walls = dungeon_wall_tiles[0]
var dungeon_terrain = dungeon_terrains[0]

var monster_spawn_ID = 0
var monster_spawns = []

var item_spawns = []
var item_spawn_ID = 0

var Player_Inventory = inventory.new()

var monster_list = [
	preload("res://monsters/Lime Slime.tscn"),
	preload("res://monsters/Blueberry Slime.tscn"), 
	preload("res://monsters/Lemon Slime.tscn"),
	preload("res://monsters/Mango Slime.tscn"),  
	preload("res://monsters/Grape Slime.tscn")
	]

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
	Player_Inventory._ready()
	Player_Inventory._print_inventory()
	
	clear_room() # clean up for new floor
	
	floor_structure() # fill in int
	generate_hallways()
	generate_rooms()
	
	generate_entity() # generate staircase, items
	generate_monsters()
	
	$Cassandra.global_position = Vector2(0,0) # returns player to root room
	#$TileMap/Staircase_Area.position = Vector2(node_pos[staircase_pos])
	$GUI/Current_Floor.set_text("Floor " + str(current_floor))
	
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
		

func _process(delta):
	for monster in monster_spawns:
		if is_instance_valid(monster) and monster.death_location != null:
			generate_loot(monster)
			monster.enemy_clear()

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
			[-1,0], 				# Floors 1-5
			[-1,-1,0,0]			# Floors 6-10
		]
	
	# The item scenes sorted by Item_ID. 
	# !! Must have a valid ID (Use the main item table in Inventory.gd !! 
	var  item_scenes = { 
		0: preload("res://equipment/coin.tscn"), 
		10: preload("res://equipment/decorative_flower.tscn") 
	}
	
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
	elif Player_Inventory.get_item_name(loot_ID) != "None":
		
		# Display text that changes depending on the rarity of your drop
		if loot_ID > 9: print( monster_type, " dropped a Rare ", Player_Inventory.get_item_name(loot_ID),"!!") # Rare Drop Text
		else: print(monster_type, " dropped a ", Player_Inventory.get_item_name(loot_ID),".") # Common Item Text
	
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
			
		if debug: print("roomsize: ",room_size[i][1], " // Room Type: ", spawn_type, " // Quantity: ", spawn_quantity)
		
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
				#monster_spawns[0].slime_print()
				
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
		room_size.append([-size,size]) # Keep room sizes
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
				# Stores tile location to be connected
				else: floor_pos.append(Vector2i(i.x+j,i.y+k))

	#print(room_size)
	# Draws all of the saved tiles and connects them together using terrains
	$TileMap.set_cells_terrain_connect(0, floor_pos, 0, dungeon_terrain)

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
	
	# Reset the monster spawn system
	monster_spawns = []
	monster_spawn_ID = 0

	item_spawns = []
	item_spawn_ID = 0
	
	$TileMap.clear()
	# Create function that removes all remaining entities
