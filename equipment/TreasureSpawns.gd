extends CharacterBody2D
var random = RandomNumberGenerator.new()

var current_loot = -1
var ID = -1

var loot_probability = [6,7,9,10,11,10,9,8,7,7,6,5,5,5,7,10,5,7,10]

#var loot_probability = [0,0,0,0,0,0,0,0,0,0,0,0,0,24,24,24,24,24,24] # New Item Test (swords and helmets)
#var loot_probability = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] # Blank for custom probability setting
var picked_up = false
var shop_item = false
var amount = 1


func _ready():
	# If no loot is set at creation this will randomize according the the probability table and return a random item
	if current_loot == -1:
		current_loot = get_random_index()
		#print("Current Loot:", current_loot)
		ID = set_loot(current_loot)

func get_random_index():
	var loot_total = 0
	var total_items = 0
	
	# Counts number of items and sets the total
	for i in len(loot_probability):
		loot_total = loot_total + loot_probability[i]
		total_items += 1
	
	var random_number = randi_range(1,loot_total)
	var count = 0
	
	for index in range(len(loot_probability)):
		count += loot_probability[index]
		if random_number <= count:
			return index
	return len(loot_probability) -1

func set_loot(index = 0):
	var loot_id = 0
	var current_loot = index
	
	if index <= 12:
		$Treasure.set_frame(index)
		$Treasure.visible = true
		loot_id = Items.Player_Inventory.treasure_start_index + 1 + index
	elif index > 12 and index <= 15:
		$Swords.set_frame(index-12)
		$Swords.visible = true
		loot_id = Items.Player_Inventory.weapon_start_index - 1 + (index - 12)
		print("Using ID: ",loot_id, "name is:", Items.Player_Inventory.get_item_name(loot_id))
	else: 
		$Helmets.set_frame(index-16)
		$Helmets.visible = true
		loot_id = Items.Player_Inventory.helmet_start_index - 1 + (index - 15)
		print("Using ID: ",loot_id, "name is:", Items.Player_Inventory.get_item_name(loot_id))
	
	#print("Item is a ", Items.Player_Inventory.get_item_name(loot_id))
	return loot_id

func clear_item():
	queue_free()  # Remove the coin
	
#Detects If Cassandra Enters the Area2D (Coin)
func _on_player_detection_body_entered(body):
	if body.name == "Cassandra": 
		picked_up = true
