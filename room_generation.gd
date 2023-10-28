extends Node2D
@onready var heartsContainer = $debug_hud/HeartsContainer
@onready var player = $Cassandra
var random = RandomNumberGenerator.new()
var node_pos = []
var hallway_pos = []
var num_paths = 10 #the number of hallway segments
var segment_length = 10 #length of hallway segments
var room_min = 2 #smallest size for rooms
var room_max = 4 #largest size for rooms
var zoom_int = 1 #debug zoom
var min_path_width = 4 # 2 Walls + Path
var max_path_width = 5

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
		for i in range(0, segment_length): # this loop creates 1 segment
			position += direction
			# create a row of path width
			var perpendicular = get_perpendicular_vector(direction)
			var row_position = position - floor(row_width / 2) * perpendicular
			# Loop for making individual tiles in the bridge
			for k in range(0, row_width):
				# Draw the walls of the walkway
				if (k == 0) or k == (row_width-1):
					$TileMap.set_cell(0, row_position, 1, Vector2i(0, 0))
				else:
				# The actual walkway, saved for use later to prevent walls overwriting them.
					hallway_pos.append(Vector2i(row_position)) # Used in wall generation
					$TileMap.set_cell(0, row_position, 0, Vector2i(0, 3))
				row_position += perpendicular
		if !position in node_pos: node_pos.append(position) # since can overlap, avoid duplicates in list
		direction = get_new_direction(direction) # get a new direction for the next segment

# this function determines the direction of the new hallway segment 
# restriction: new direction should never be the reverse of the previous direction
func get_new_direction(old_direction):
	var directions = [Vector2i(0,1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
	directions.erase(old_direction)
	return directions[random.randi_range(0, directions.size() - 1)]

# this function returns a vector that is perpendicular
# to the passed in vector2i
func get_perpendicular_vector(original):
	return Vector2i(-original.y, original.x)

func generate_room():
	var cells = []
	
	for i in node_pos:
		var size = random.randi_range(room_min, room_max)
		for j in range(-size-1, size+1):
			for k in range(-size-1, size+1):
				# Walls furthest from camera
				if ((j == -size-1)) or ((k == size)) or ((j == size) or (k == -size-1)):
					if !(Vector2i(i.x+j,i.y+k)) in hallway_pos: 
						$TileMap.set_cell(0, Vector2i(i.x+j, i.y+k), 1, Vector2i(0, 0))
				# Walls close to camera	
				elif ((j == size) or (k == -size-1)):
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
	for i in range(-1000, 1000):
		for j in range(-1000, 1000):
			$TileMap.erase_cell(0, Vector2i(i , j))
