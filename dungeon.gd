extends Node2D

var debug = true

var healthSetupCompleted = false

var random = RandomNumberGenerator.new()
var node_pos = [] # keeps track of the root for each room
var hall_pos = [] # for building pathways
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
	var Player_Inventory = inventory.new()
	Player_Inventory._ready()
	Player_Inventory._print_inventory()
	Player_Inventory._add_item(1,1)
	var myprint = Player_Inventory._save_inventory()
	print(myprint)

	clear_room() # clean up for new floor
	floor_structure() # fill in int
	generate_hallways()
	generate_rooms()
	generate_entity()
	
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
		

func _process(delta): pass

func _on_staircase_hitbox_area_entered(area): _ready()
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

	# generate items
	# generate enemies
	# generate NPCs

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
	var cells = []
	
	for i in node_pos:
		var size = random.randi_range(room_min, room_max)

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
				else: cells.append(Vector2i(i.x+j,i.y+k))

	# Draws all of the saved tiles and connects them together using terrains
	$TileMap.set_cells_terrain_connect(0, cells, 0, dungeon_terrain)

func clear_room(): 
	node_pos = []
	hall_pos = []
	$TileMap.clear()
