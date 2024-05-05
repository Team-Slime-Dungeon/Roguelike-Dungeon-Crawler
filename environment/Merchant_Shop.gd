extends CharacterBody2D
var random = RandomNumberGenerator.new()

# Shop Information
var shop_type = "None"
var possible_shop_items = [90]
var hat_index = 0

var spawns_objects = true #flag for scene management

# Possible Shop varieties and their possible inventories. Chosen at random
var shop_names = ["General Store", "Weapon Shop", "Potion Shop"]
var shop_inventory = {"General Store":[30, 49, 50], "Potion Shop":[30,49], "Weapon Shop":[49]}
# Stores what items the shop keeper has in their inventory
var shop_items = []

# Manages the spawned item scenes once the shop keeper is cleared
var shop_spawns = []
var shop_spawn_id = 0

func _ready():
	# Set shop type based on available shop varieties
	shop_type = shop_names[randi() % shop_names.size()]
	possible_shop_items = shop_inventory[shop_type]
	
	# Cats Hats (or lack of) will spawn on the shopkeeper's head depending on their job
	if shop_type == "Weapon Shop": hat_index = 4
	elif shop_type == "Potion Shop": hat_index = 5
	else: hat_index = randi_range(0, 2)

	$Shop/Cat_Hat.frame = hat_index
		
	if not $ShopAnimation.is_playing():
		$ShopAnimation.play("Idle")
		
	# Generate four random items (or blank spaces). At least one always spawns
	for i in range(0,4):
		var random_item_chance = randi_range(0,1)
		if random_item_chance == 1 or i == 0:
			# Select items from possible item pool
			var item_id_chosen = possible_shop_items[randi() % possible_shop_items.size()]
			shop_items.append(item_id_chosen)
		else:
			shop_items.append(-1)

	# Spawn items on top of the shop
	for i in range(4):
		if shop_items[i] != -1:
			var shop_pos = (Vector2((i*30) +21, 61)) /2
			#var shop_pos = Vector2((i*10), 10)

			var new_item_spawn = Items.Player_Inventory.Item_Scenes[shop_items[i]].instantiate()
			new_item_spawn._set_shop(true)
	
			shop_spawns.append(new_item_spawn)
			add_child(new_item_spawn)
			shop_spawns[shop_spawn_id].global_position = shop_pos
			shop_spawn_id += 1

func clear_spawns():
	if shop_spawns != []:
		for i in len(shop_spawns):
			if is_instance_valid(shop_spawns[i]): 
				shop_spawns[i].queue_free()

	shop_spawns = []
	shop_spawn_id = 0

func shop_success():
	print("Purchase is a success!")
	$ShopAnimation.play("Shop_Purchase")
	
func shop_fail():
	print("Purchase failed!")
	$ShopAnimation.play("Shop_Purchase_Fail")

#func _process(delta):
#	if Input.is_action_just_pressed("interact"):
#		$ShopAnimation.play("Shop_Purchase")

func _on_shop_animation_animation_finished(animation):
	if animation == "Shop_Purchase" or "Shop_Purchase_Fail":
		$ShopAnimation.play("Idle")


func _on_player_detection_body_entered(body):	
	if body.name == "Cassandra": 
		Items.inside_shop = true
		print("Inside shop, sell is ", Items.inside_shop)
		
func _on_player_detection_body_exited(body): 	
	if body.name == "Cassandra": 
		Items.inside_shop = false
		print("Left shop, sell is ", Items.inside_shop)
