class_name floor_gen extends Node2D

var random = RandomNumberGenerator.new()
var node_pos = []
var hall_pos = []
var hall_count = 0
var hall_length = 0
var room_min = 0
var room_max = 0
var min_path_width = 3 # 2 Walls + Path, rec 3
var max_path_width = 5 # rec 5
var tilemap = null

func _ready():
	clear_room() # clean up for new floor
	generate_hallways()
	generate_rooms()

func _init(hall_count_param, hall_length_param, room_min_param, room_max_param, tile_param):
	self.hall_count = hall_count_param
	self.hall_length = hall_length_param
	self.room_min = room_min_param
	self.room_max = room_max_param
	self.tilemap = tile_param
	if room_min < max_path_width: max_path_width = room_min

func get_seed(): return node_pos

func generate_hallways():
	var direction = Vector2i(1, 0) #tracks which way the hall segment will travel
	var tile_pos = Vector2i(0, 0) #tracks current tile position
	node_pos.append(tile_pos) #initial room at 0,0
	
	# this loop makes hallway segments
	for j in range(0, hall_count):
		var row_width = random.randi_range(min_path_width, max_path_width)
		var perpendicular = get_perpendicular_vector(direction)

		for i in range(0, hall_length): # this loop creates 1 segment
			tile_pos += direction
			# create a row of path width
			var row_position = tile_pos - floor(row_width / 2) * perpendicular
			
			# Create the outside wall of path if possible
			if Vector2i(row_position) not in hall_pos:
				tilemap.set_cell(0, Vector2i(row_position.x-1, row_position.y-1), 1, Vector2i(0, 0))

			# Create a row of hallway and save it in a list
			for k in range(0, row_width):
				tilemap.set_cell(0, row_position, 0, Vector2i(0, 3))
				hall_pos.append(Vector2i(row_position.x, row_position.y))
				row_position += perpendicular
	
			# Create second hallway wall if possible			
			if Vector2i(row_position) not in hall_pos:
				tilemap.set_cell(0, Vector2i(row_position.x, row_position.y), 1, Vector2i(0, 0))

		if !tile_pos in node_pos: node_pos.append(tile_pos) # since can overlap, avoid duplicates in list
		direction = get_new_direction(direction) # get a new direction for the next segment

# this function determines the direction of the new hallway segment 
# restriction: new direction should never be the reverse of the previous direction
func get_new_direction(old_direction):
	var directions = [Vector2i(0,1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
	var reverse
	# Remove the reverse of the old direction
	if old_direction == Vector2i(1,0): reverse = Vector2i(-1,0)
	elif old_direction == Vector2i(-1,0): reverse = Vector2i(1,0)
	elif old_direction == Vector2i(0,1): reverse = Vector2i(0,-1)
	elif old_direction == Vector2i(0,-1): reverse = Vector2i(0,1)

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
						tilemap.set_cell(0, Vector2i(i.x+j, i.y+k), 1, Vector2i(0, 0))
				# Walls close to camera
				elif ((j == size-1) or (k == -size)):
					if !(Vector2i(i.x+j,i.y+k)) in hall_pos:
						tilemap.set_cell(0, Vector2i(i.x+j, i.y+k), 1, Vector2i(0, 0))
				# Stores tile location to be connected
				else:
					cells.append(Vector2i(i.x+j,i.y+k))

	# Draws all of the saved tiles and connects them together using terrains
	tilemap.set_cells_terrain_connect(0, cells, 0, 0)
	
func clear_room(): 
	#node_pos = []
	#hall_pos = []
	tilemap.clear()
	
	#for i in range(-100, 100): # higher wall generation
	#	for j in range(-100, 100):
	#		tilemap.set_cell(0, Vector2i(i,j), 1, Vector2i(2, 0))
