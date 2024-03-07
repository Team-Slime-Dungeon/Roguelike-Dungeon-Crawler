extends Node
@onready var Player_Inventory = inventory.new()

func _ready(): 
	Player_Inventory._ready()
	

# Universal Item Handler
# This will handle spawning enemies and objects and will also handle deleting them.
var item_spawns = []
var item_spawn_id = 0

# Add new item to all of the spawns
# Mod is modifiers, such as alt. ID's for scenes with multiple items
# Shop Item will lock the item as a shop item if possible
func add_item(item_id=-1, location=Vector2i(0,0), mod=0, shop_item=false):
	var new_item_spawn = Player_Inventory.Item_Scenes[item_id].instantiate()
	
	if shop_item == true: new_item_spawn._set_shop(true)
	
	item_spawns.append(new_item_spawn)
	add_child(new_item_spawn)
	item_spawns[item_spawn_id].global_position = location
	item_spawn_id += 1

func add_scene(scene_preload=null, location=Vector2i(0,0), mod = 0, meta=[]):
	if scene_preload != null:
		var new_entity_spawn = scene_preload.instantiate()
		item_spawns.append(new_entity_spawn)
		add_child(new_entity_spawn)
		item_spawns[item_spawn_id].global_position = location
		item_spawn_id += 1

func remove_item(item_id):
	pass
	
func remove_all_spawns():
	if item_spawns != []:
		for i in len(item_spawns):
			if is_instance_valid(item_spawns[i]):
				# Clears the objects spawned children first
				if "spawns_objects" in item_spawns[i]:
					item_spawns[i].clear_spawns()
				item_spawns[i].queue_free()

	item_spawns = []
	item_spawn_id = 0
	
func _process(delta): 
	for item in item_spawns:
		# Item is an item that can be picked up, add to inventory
		if "picked_up" in item:
			if is_instance_valid(item) and item.picked_up != false:
				Player_Inventory._add_item(item.ID, item.amount)
				Player_Inventory._print_inventory()
				item.clear_item()
