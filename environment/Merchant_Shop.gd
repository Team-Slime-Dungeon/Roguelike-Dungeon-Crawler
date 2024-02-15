extends CharacterBody2D
var random = RandomNumberGenerator.new()

var possible_shop_items = [51,71]

var  item_scenes = { 
		51: preload("res://equipment/treasure_spawns.tscn"),
		71: preload("res://equipment/Blue Mushroom.tscn"),
	}
	
var shop_items = []
var shop_spawns = []
var shop_items_id = 0

func _ready():
	# Generate four random items (or blank spaces)
	for i in range(0,4):
		var random_item_chance = -1#randi_range(0,1)
		if random_item_chance == 1 or i == 0:
			var item_id_chosen = possible_shop_items[randi() % possible_shop_items.size()]
			shop_items.append(item_id_chosen)
		else:
			shop_items.append(-1)

	print(shop_items)
	# Spawn items on top of the shop
	for i in range(4):
		if shop_items[i] != -1:
			print(">",Items.Player_Inventory.get_item_name(shop_items[i])," // Price: ",Items.Player_Inventory._get_item_price(shop_items[i]))
			var new_shop_item = item_scenes[shop_items[i]].instantiate()
			shop_spawns.append(new_shop_item)
			add_child(new_shop_item)
			shop_spawns[shop_items_id].global_position = Vector2((30*i)+100, 105)
			shop_items_id += 1
			

	
