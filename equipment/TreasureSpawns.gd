extends CharacterBody2D
var random = RandomNumberGenerator.new()

var current_loot = -1
var ID = -1

var total_items = 13
var loot_probability = [6,7,9,10,11,10,9,8,7,7,6,5,5]

var picked_up = false
var amount = 1

func _ready():
	# If no loot is set at creation this will randomize according the the probability table and return a random item
	if current_loot == -1:
		current_loot = get_random_index()
		ID = set_loot(current_loot)

func get_random_index():
	var random_number = randi_range(1,100)
	
	for index in range(len(loot_probability)):
		if random_number > 0:
			random_number -= loot_probability[index]
		else:
			return index -1

func set_loot(index = 0):
	var loot_id = 0
	var current_loot = index
	
	$Treasure.set_frame(index)
	
	loot_id = Items.Player_Inventory.treasure_start_index + 1 + index
	#print("Item is a ", Items.Player_Inventory.get_item_name(loot_id))
	return loot_id

func clear_item():
	queue_free()  # Remove the coin
	
#Detects If Cassandra Enters the Area2D (Coin)
func _on_player_detection_body_entered(body):
	if body.name == "Cassandra": 
		picked_up = true
