extends Node2D

var debug = true

var CurrentFloor = 1 # starting floor
var FloorDic = {1: [45, 12, 3, 6],
				2: [10, 6, 3, 5],
				3: [15, 7, 4, 6],
				4: [20, 8, 5, 7],
				5: [25, 9, 6, 8]} # these are kind of random 
# 0 hall_count: num of hallway segments, rec 10
# 1 hall_length: length of hallway segments, rec 10
# 2 room_min: min size for rooms, rec 2
# 3 room_max: max size for rooms, rec 4

# wip health, player
var healthSetupCompleted = false
@onready var heartsContainer = $Debug_Hud/HeartsContainer
@onready var player = $Cassandra

func _ready():
	#cutscene function check here probably
	#floor dictionary override bool here, then:
	var tilemap = $TileMap
	var FloorGen = floor_gen.new( #floor generation class
		FloorDic[CurrentFloor][0], #hall_count
		FloorDic[CurrentFloor][1], #hall_length
		FloorDic[CurrentFloor][2], #room_min
		FloorDic[CurrentFloor][3], #room_max
		tilemap)
	FloorGen._ready()
	#insert player
	#insert entities 
	$Debug_Hud.visible = debug
	$Debug_Hud/Seed.set_text("Debug\n " + str(FloorGen.get_seed())) 
	
	# move to function as dev continues
	if not healthSetupCompleted: # Set up health
		heartsContainer.setMaxHearts(player.maxHealth)
		heartsContainer.updateHearts(player.currentHealth)
		player.healthChanged.connect(heartsContainer.updateHearts)
		healthSetupCompleted = true   

func _on_new_seed_pressed(): _ready()

func _process(delta):
	
	pass
