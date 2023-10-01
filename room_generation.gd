extends Node2D

var random = RandomNumberGenerator.new()
var floorstruct = 0 #dictionary, room size and child info

func _ready():
	floorstruct = {0: [0, 0]} #empty main room
	clear_room() #removes tiles based on largest room size (400 tile radius)
	create_rooms() #generate main room and children rooms
	$debug_seed_info.set_text("Debug\n " + str(floorstruct)) #debug info visual
	
func create_rooms():
	floorstruct[0][0] = getsize() #get size of root room
	floorstruct[0][1] = getchild() #get child room number
	
	for i in floorstruct[0][1]: #get size of room for all rooms generated
		floorstruct[i+11] = [getsize(), 0]
	
	for key in floorstruct: #build rooms on canvas
		build_room(key, (floorstruct[key][0]))
	return floorstruct

func getsize(): return random.randi_range(3, 5)
func getchild(): return random.randi_range(4, 4)
func _on_new_seed_pressed(): return _ready() #click button for new build
func build_room(key, size):
	for i in range(-size, size):
		for j in range(-size, size):
			if key == 0:$TileMap.set_cell(0, Vector2i(i, j), 0, Vector2i(0, 0))
			elif key == 11:$TileMap.set_cell(0, Vector2i(i+(size*3), j+(size)), 0, Vector2i(0, 0))
			elif key == 12:$TileMap.set_cell(0, Vector2i(i+(size), j-(size*3)), 0, Vector2i(0, 0))
			elif key == 13:$TileMap.set_cell(0, Vector2i(i-(size*3), j-(size)), 0, Vector2i(0, 0))
			elif key == 14:$TileMap.set_cell(0, Vector2i(i-(size), j+(size*3)), 0, Vector2i(0, 0))

func clear_room():
	for i in range(-200, 200):
		for j in range(-200, 200):
			$TileMap.erase_cell(0, Vector2i(i , j))
