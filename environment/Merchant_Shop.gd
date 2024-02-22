extends CharacterBody2D
var random = RandomNumberGenerator.new()

var possible_shop_items = [90]#,51,71]
var spawns_objects = true
var cat_hats = 4

var  item_scenes = { 
		51: preload("res://equipment/treasure_spawns.tscn"),
		71: preload("res://equipment/Blue Mushroom.tscn"),
		90: preload("res://equipment/EquipmentTest/Potion_Item.tscn"),
	}
# What items the shop keeper has in store
var shop_items = []

# Manages the spawns once the shop keeper is cleared
var shop_spawns = []
var shop_spawn_id = 0

func _ready():
	var hat_chance = randi_range(0,4)
	$Shop/Cat_Hat.frame = hat_chance
		
	if not $ShopAnimation.is_playing():
		$ShopAnimation.play("Idle")
		
	# Generate four random items (or blank spaces)
	for i in range(0,4):
		var random_item_chance = randi_range(0,1)
		if random_item_chance == 1 or i == 0:
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
	print("yay!")
	$ShopAnimation.play("Shop_Purchase")
	
func shop_fail():
	print("Boo!")
	$ShopAnimation.play("Shop_Purchase_Fail")

#func _process(delta):
#	if Input.is_action_just_pressed("interact"):
#		$ShopAnimation.play("Shop_Purchase")

func _on_shop_animation_animation_finished(animation):
	if animation == "Shop_Purchase" or "Shop_Purchase_Fail":
		$ShopAnimation.play("Idle")
