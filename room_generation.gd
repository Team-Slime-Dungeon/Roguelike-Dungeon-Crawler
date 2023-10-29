extends Node2D
@onready var heartsContainer = $debug_hud/HeartsContainer
@onready var player = $Cassandra
var random = RandomNumberGenerator.new()
var node_pos = []
var hallway_pos = []
var num_paths = 55 #the number of hallway segments
var segment_length = 10 #length of hallway segments
var room_min = 3 #smallest size for rooms
var room_max = 4 #largest size for rooms
var zoom_int = 1 #debug zoom
var min_path_width = 2 # Minimum path size
var max_path_width = 3 # Max path size

func _ready():
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
	clear_room()
	generate_hallways() #first, generate the hallways
	generate_room() #second, create rooms on top of selected nodes
	$debug_hud/debug_seed_info.set_text("Debug\n " + str(node_pos)) #debug info visual
	
func _on_new_seed_pressed(): return _ready() #click button for new build

func generate_hallways():
	var direction = Vector2i(1, 0) #tracks which way the hall segment will travel
	var position = Vector2i(0, 0) #tracks current tile position
	node_pos.append(position) #initial room at 0,0
	
	# this loop makes hallway segments
	for j in range(0, num_paths):
		var row_width = random.randi_range(min_path_width, max_path_width)
		var perpendicular = get_perpendicular_vector(direction)

		for i in range(0, segment_length): # this loop creates 1 segment

			position += direction
			# create a row of path width
			var row_position = position - floor(row_width / 2) * perpendicular
			
			# Create the outside wall of path if possible
			if Vector2i(row_position) not in hallway_pos:
				$TileMap.set_cell(0, Vector2i(row_position.x-1, row_position.y-1), 1, Vector2i(3, 1))
			else:
				print("Wall/ Hallway Conflict Wall 1: ", row_position)
			
			# Create a row of hallway and save it in a list
			for k in range(0, row_width):
				$TileMap.set_cell(0, row_position, 0, Vector2i(0, 3))
				hallway_pos.append(Vector2i(row_position.x, row_position.y))
				row_position += perpendicular
	
			# Create second hallway wall if possible			
			if Vector2i(row_position) not in hallway_pos:
				$TileMap.set_cell(0, Vector2i(row_position.x, row_position.y), 1, Vector2i(3, 1))
			else:
				print("Wall/ Hallway Conflict Wall 2: ", row_position)	

		if !position in node_pos: node_pos.append(position) # since can overlap, avoid duplicates in list
		direction = get_new_direction(direction) # get a new direction for the next segment

# this function determines the direction of the new hallway segment 
# restriction: new direction should never be the reverse of the previous direction
func get_new_direction(old_direction):
	var directions = [Vector2i(0,1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
	#print("=======")
	var reverse
	
	# Remove the reverse of the old direction
	if old_direction == Vector2i(1,0):
		reverse = Vector2i(-1,0)
		#print("Moved Up!")
	elif old_direction == Vector2i(-1,0):
		reverse = Vector2i(1,0)
		#print("Moved Down")
	elif old_direction == Vector2i(0,1):
		reverse = Vector2i(0,-1)
		#print("Moved Right")
	elif old_direction == Vector2i(0,-1):
		reverse = Vector2i(0,1)
		#print("Moved Left")
	
	directions.erase(reverse)
	var new_directions = directions[random.randi_range(0, directions.size() - 1)]
	#print("Old Directions: ", old_direction, " New directions: ", new_directions)
	return new_directions

# this function returns a vector that is perpendicular
# to the passed in vector2i
func get_perpendicular_vector(original):
	var perpen
	if original == Vector2i(1,0) or original == Vector2i(0,-1):
		perpen = Vector2i(-original.y, original.x)
	else:
		perpen = Vector2i(original.y,-original.x)
	return perpen

func generate_room():
	var cells = []
	
	for i in node_pos:
		var size = random.randi_range(room_min, room_max)

		for j in range(-size, size):
			for k in range(-size, size):
				# Walls furthest from camera
				if ((j == -size)) or ((k == size-1)):
					if !(Vector2i(i.x+j,i.y+k)) in hallway_pos: 
						$TileMap.set_cell(0, Vector2i(i.x+j, i.y+k), 1, Vector2i(0, 0))
				# Walls close to camera	
				elif ((j == size-1) or (k == -size)):
					if !(Vector2i(i.x+j,i.y+k)) in hallway_pos:
						$TileMap.set_cell(0, Vector2i(i.x+j, i.y+k), 1, Vector2i(0, 0))
				# Stores tile location to be connected
				else:
					cells.append(Vector2i(i.x+j,i.y+k))

	# Draws all of the saved tiles and connects them together using terrains
	$TileMap.set_cells_terrain_connect(0, cells, 0, 0)

func clear_room():
	node_pos = []
	hallway_pos = []
	for i in range(-100, 100):
		for j in range(-100, 100):
			$TileMap.erase_cell(0, Vector2i(i , j))
			$TileMap.set_cell(0, Vector2i(i,j), 1, Vector2i(2, 0))
