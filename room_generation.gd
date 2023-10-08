extends Node2D

var random = RandomNumberGenerator.new()
var node_pos = [] 
var num_paths = 10 #the number of hallway segments
var segment_length = 10 #length of hallway segments
var room_min = 2 #smallest size for rooms
var room_max = 4 #largest size for rooms
var zoom_int = 1 #debug zoom

func _ready():
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
		for i in range(0, segment_length): # this loop creates 1 segment
			position += direction
			$TileMap.set_cell(0, position, 0, Vector2i(0, 3))
		if !position in node_pos: node_pos.append(position) # since can overlap, avoid duplicates in list
		direction = get_new_direction(direction) # get a new direction for the next segment

# this function determines the direction of the new hallway segment 
# restriction: new direction should never be the reverse of the previous direction
func get_new_direction(old_direction):
	var directions = [Vector2i(0,1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0)]
	var result = -old_direction
	while result == -old_direction:
		result = directions[random.randi_range(0, 3)]
	return result

func generate_room():
	var cells = []
	
	for i in node_pos:
		var size = random.randi_range(room_min, room_max)
		for j in range(-size, size+1):
			for k in range(-size, size+1):
				#$TileMap.set_cell(0, Vector2i(i.x+j, i.y+k), 0, Vector2i(1,1))
				# Stores tile location to be used later
				cells.append(Vector2i(i.x+j,i.y+k))

	# Draws all of the tiles and connects them together using terrains
	$TileMap.set_cells_terrain_connect(0, cells, 0, 0)

func clear_room():
	node_pos = [] 
	for i in range(-1000, 1000):
		for j in range(-1000, 1000):
			$TileMap.erase_cell(0, Vector2i(i , j))
