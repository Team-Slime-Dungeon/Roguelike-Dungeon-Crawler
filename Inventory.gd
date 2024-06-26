class_name inventory extends Node2D
var Held_Item = 0
var Inventory = {}

# Item list Slots for convenience
var item_name = 0
var item_price = 1
var item_maxstack = 2
var item_attack = 3
var item_defense = 4
var item_effect1 = 5
var item_effect2 = 6
var item_can_equip = 7
# Indexes for item categories for outside use
var weapon_start_index = 1
var weapon_end_index = 3

var helmet_start_index = 14
var helmet_end_index = 16

var throwable_start_index = 30
var throwable_end_index = 31

var treasure_start_index = 51
var treasure_end_index = 64

var Item_List = {
# Item ID [Item Name // Price // Item_Max_Stack // Item Attack // Item Defense // Item Effect1 // Item Effect2//Equippable?]
	0 : ["Coin",			1,		99,				0,				0,			null,			 null, false ],
	
	# Weapons and Equipment IDs 1 - 50
	1 : ["Bronze Sword",	25,		1,		2,				0,				null, null,	true ],
	2 : ["Silver Sword",	50,		1,		3,				0,				null, null,	true ],
	3 : ["Gold Sword", 		75,		1,		5,				0,				null, null,	true ],
	
	14 : ["Bronze Helmet", 	25,		1,		0,				5,				null, null,	true ],
	15 : ["Silver Helmet", 	50,		1,		0,				6,				null, null,	true ],
	16 : ["Gold Helmet", 	75,		1,		0,				7,				null, null,	true ],

	30:  ["Random Throwable",	2,		0,		0,				0, 				null, null, false  ],
	31 : ["Shuriken", 		2,		99,		2,				0,					null, null,	false ],
	
	#Weapon IDs 1-2. 49 will spawn a random sword, 50 will spawn a random helmet
	49: ["Random Weapon",	50,		0,		0,				0,				null, null, false],
	50: ["Random Helmet",	50,		0,		0,				0,				null, null, false],
	
	# Treasures IDs 51 - 100. 51 will spawn a random item, 52 on can be found inside 51
	51: ["Random Treasure",	40,		0,		0,				0, 				null, null, false  ],
	
	52: ["Ruby Necklace",	10,		99,		0,				0, 				null, null, false  ],
	53: ["Emerald Crown",	10,		99,		0,				0, 				null, null, false  ],
	54: ["Ancient Tome",	15,		99,		0,				0, 				null, null, false  ],
	55: ["Ruby",			20,		99,		0,				0, 				null, null, false  ],
	56: ["Old Earring",		25,		99,		0,				0, 				null, null, false  ],
	57: ["Ancient Coins",	30,		99,		0,				0, 				null, null, false  ],
	58: ["Pearl Necklace",	35, 	99,		0,				0, 				null, null , false ],
	59: ["Sapphire",		40,		99,		0,				0, 				null, null , false ],
	60: ["Emerald",			45,		99,		0,				0, 				null, null , false ],
	61: ["Topaz",			50,		99,		0,				0, 				null, null , false ],
	62: ["Sacred Technology", 89,	999,	0,				0, 				null, null , false ], # I actually have that many
	63: ["Diamond",			90,		99,		0,				0, 				null, null , false ],
	64: ["Petrified Egg",	101,	99,		0,				0, 				null, null , false ],
	
	# Monster Drops
	71: ["Blue Mushroom",	3,		 99,		0,				0, 				null, null , false ],
	72: ["King Slime Crown",	100,		 1,		0,				0, 				null, null , false ],

	#Potions
	90: ["Red Potion",		3,		 9,		0,				0, 				"HP+5", null , false ],
	91: ["Purple Potion",	5,		 9,		0,				0, 				"Nothing", null , false ],
	92: ["Blue Potion",		3,		 9,		0,				0, 				"Something", null , false ],
	93: ["Green Potion",	5,		 9,		0,				0, 				"Who Knows", null , false ],
}

var Item_Scenes = {
	0: preload("res://equipment/coin.tscn"),
	71: preload("res://equipment/Blue Mushroom.tscn"),
	30: preload("res://equipment/Throwable_Item.tscn"),
	
	# Multi Use Scenes (Contain more than one item)
	49: preload("res://equipment/Weapon_Item.tscn"),
	50: preload("res://equipment/Helmet_Item.tscn"),
	51: preload("res://equipment/treasure_spawns.tscn"),
	90: preload("res://equipment/EquipmentTest/Potion_Item.tscn"),
}

#Dictionary for currently equipped weapon
var equip_weapon_stats = {}
#signal for changing the weapon sprite in the cassandra scene
signal texture_has_changed(icon_texture)
var weapon1_texture = load("res://InventoryTesting/Item Test/weapon_1.png")	
var weapon2_texture = load("res://InventoryTesting/Item Test/weapon_2.png")	
#dictionary with the weapon textures
var weapon_texture_list ={
	1:["weapon_1", weapon1_texture],
	2:["weapon_2", weapon2_texture]
	}


# Called when the node enters the scene tree for the first time.
func _ready(loaded_inventory={}):	
	if loaded_inventory != {}:
		print("Inventory Loaded!")
		Inventory = loaded_inventory
	else: Inventory = {0:0}

func _save_inventory():
	# Takes the current inventory and returns it as a dictionary of { Item ID: Amount }
	print(Inventory)
	return Inventory

func _load_inventory(loaded_inventory):
	# Takes an array and prints it to the terminal, then sets the inventory to that array.
	print("Inventory Loaded!")
	Inventory = loaded_inventory

func _print_inventory():
	# Prints a fancy inventory box to console
	print("\n|================================|\n| Item Name				| Amount |\n|================================|")
	for item_id in Inventory:
		print("| ", Item_List[item_id][item_name], "	x ", Inventory[item_id])
	print("|================================|\n")
	
func _get_coins():
	#print(Inventory[0])
	var total_coins = Inventory[0]
	return total_coins

func _get_item_price(item_id, amount=1):
	if Item_List.has(item_id):
		# return the item's attack as an int
		var temp_price = Item_List[item_id][item_price]
		return (temp_price * amount)
	else:
		print("Error: Item has no price or does not exist. ID Given: ",item_id)
		
func _sell_item(item_id, amount):
	var price = _get_item_price(item_id, amount)
	var price_total = price / 2

	print("real: ",price, " / adjusted:", price_total)
	if _minus_item(item_id, amount ,true) == true:
		_add_item(0, price_total)
		print("Added ", price_total," coins")
		return true
	else:
		print("Error: Couldn't sell")
		return false
	
func _pay_for_item(item_id, amount=1, overfill=false):
	var price_total = _get_item_price(item_id, amount)
	
	# Player has enough coins to pay for the item in their inventory
	if _get_coins() >= price_total:
		# Checks if the player can add the item to their inventory. If item types can hold one (swords) leave this off
		if _can_add_item(item_id,amount, overfill):
			_add_item(item_id,amount)
			_minus_item(0,price_total,true)
			return true
		else:
			print("You can't carry anymore of those!")
			return false

	else:
		print("Sorry, not enough coins!")
		return false
		
func _can_add_item(item_id, amount, overfill=false):
	var add_amount = amount
	# If item ID is in inventory
	if Inventory.has(item_id):
		# Adding a valid value
		if add_amount + Inventory[item_id] <= Item_List[item_id][item_maxstack]:
			return true
			
		# Add amount is too large, add to maximum amount
		else:
			# if overfill is allowed, by default it isn't so that you can't buy single stack items
			if overfill == false:
				return false
			# if overfill is allowed, meaning you CAN pick up the item but might not need to
			else:
				return true
		
	# Item is not in inventory, add new item to inventory (if it is valid)
	else: 
		# Item is a valid item
		if Item_List.has(item_id):
			#print("Checking Item quantity. Trying to add ", add_amount," ", Item_List[item_id][item_name] ," to inventory.")
			
			# Item is at a valid adding amount
			if add_amount <= Item_List[item_id][item_maxstack]:
				return true
			
			# Adding too many items, cut items down to max amount
			else:
				#print("Amount too high, adjusted amount.")
				if overfill == false:
					return false
				else:
					return true
			
		# Item is not a valid item
		else:
			print("Error: Item does not exist for _can_add_item.")
			return false
func _can_throw_item(item_id):
	var throwable_item_ids = [31]
	
	# Item exists
	if (Inventory.has(item_id)) and (item_id in throwable_item_ids):
	# Item can removed
		if _minus_item(item_id, 1 , true) == true:
			print("Item is throwable!")
			return true
		
	print("Couldn't throw.")
	return false
	
func _add_item(item_id, amount):
	var add_amount = amount
	# If item ID is in inventory
	if Inventory.has(item_id):
		# Adding a valid value
		if add_amount + Inventory[item_id] <= Item_List[item_id][item_maxstack]:
			Inventory[item_id] += add_amount
			
		# Add amount is too large, add to maximum amount
		else:
			#print("Item amount is too large, capping to max stack size.")
			Inventory[item_id] = Item_List[item_id][item_maxstack]
		
		print(Item_List[item_id][item_name], " in inventory updated to ", Inventory[item_id])
		
	# Item is not in inventory, add new item to inventory (if it is valid)
	else: 
		# Item is a valid item
		if Item_List.has(item_id):
			#print("Checking Item quantity. Trying to add ", add_amount," ", Item_List[item_id][item_name] ," to inventory.")
			
			# Item is at a valid adding amount
			if add_amount <= Item_List[item_id][item_maxstack]:
				Inventory[item_id] = add_amount 
			
			# Adding too many items, cut items down to max amount
			else:
				#print("Amount too high, adjusted amount.")
				add_amount = Item_List[item_id][item_maxstack]
				Inventory[item_id] = add_amount
				
			print("Added (",add_amount,") ", Item_List[item_id][item_name]," to inventory!")
			
		# Item is not a valid item
		else:
			print("Error: Item does not exist.")

func _minus_item(item_id, amount, delete=false):
	# Note: this removes, not deletes. Think coins, you will always have zero or more
	# if delete flag is used it will also call the delete method once the item hits zero or below
	var remove_amount = amount
	
	# Item ID is in inventory
	if Inventory.has(item_id):
		# Amount being removed would take item negative
		if Inventory[item_id] - remove_amount <= 0:
			# By default it will keep the item to at least zero
			if delete == false:
				Inventory[item_id] = 0
			else:
				_delete_item(item_id)
		else:
		# Amount is less than the amount held, just remove the amount
			Inventory[item_id] -= remove_amount
		# Print the updated value if not deleted
		if delete == false:
			print(Item_List[item_id][item_name], " in inventory updated to ", Inventory[item_id])
		return true
	# Item is not in inventory
	else: 
		print("Error: Item ID [",item_id,"] not in inventory, cannot remove.")
		return false
		
func _delete_item(item_id):
	# Check if the inventory has the item
	if Inventory.has(item_id):
		# Delete the item from the inventory dictionary
		Inventory.erase(item_id)
		print("Item ", Item_List[item_id][item_name]," was deleted from inventory.")
		return true
	else:
		# If item ID is not found in inventory, print error to terminal
		print("Error: Item ID [",item_id,"] is not in inventory, cannot be deleted.")
		return false
		
func get_item_name(item_id):
	# If the item exists
	if Item_List.has(item_id):
		# Return the item's name as a string
		return Item_List[item_id][item_name]
	else:
		print("Error: Item does not exist.")
	# Item didn't exist, return item name as "None"
	return "None" 

func get_item_amount(item_id):
	# If the item exists in the inventory
	if Inventory.has(item_id):
		# Return the item's amount
		return Inventory[item_id]
	else:
		print("Error: Item not in inventory.")
	# Item didn't exist, return item name as "None"
	return 0

func get_item_attack(item_id):
	# If the item exists in the inventory
	if Item_List.has(item_id):
		# return the item's attack as an int
		return Item_List[item_id][item_attack]
	else:
		#item doesn't exist, return 0
		print("Error: Item does not exist.")
	return 0
	
func get_item_defense(item_id):
	if Item_List.has(item_id):
		return Item_List[item_id][item_defense]
	else:
		print("Error: Item does not exist.")
	return 0
#searches item list by item name and returns corresponding item id
func get_Item_Id_By_Name(Item_Name):
	for i in Item_List:
		if Item_List[i][0]==Item_Name:
			return i

func is_equippable(item_id):
	# If the item exists
	if Item_List.has(item_id):
		# Return the item's name as a string
		return Item_List[item_id][item_can_equip]
	else:
		print("Error: Item does not exist.")
	# Item didn't exist, return item name as "None"
	return false

func equip_weapon(new_weapon_id):
	var current_weapon_id
	if equip_weapon_stats == {}:
		current_weapon_id = new_weapon_id
		set_equip_weapon_stats(current_weapon_id)
		#Inventory.erase(new_weapon_id)
		var weapon_name = get_item_name(current_weapon_id)
		emit_signal("texture_has_changed", weapon_name)
func _delete_equip(weapon_id):
	var weapon_name = null
	if equip_weapon_stats != {}:
		#equip_weapon_stats.erase(weapon_id)
		equip_weapon_stats = {}
		emit_signal("texture_has_changed", weapon_name)
func _print_inv_dic():
	print(Inventory)
	
func set_equip_weapon_stats(weapon_id):
	if is_equippable(weapon_id):
		equip_weapon_stats[0] = Item_List[weapon_id]
	#return equip_weapon_stats	
	
func get_equip_weapon_stats():
	return equip_weapon_stats
	
func get_current_weapon():
	if equip_weapon_stats == {}:
		return equip_weapon_stats
	else:
		return equip_weapon_stats[0][0]
		
func get_item_id_by_texture(item_texture):
	for i in weapon_texture_list:
		if weapon_texture_list[i][1]==item_texture:
			#print("printed statement: ",weapon_texture_list[i][1])
			return i
			
func search_texture(item_texture):
	for i in weapon_texture_list:
		if weapon_texture_list[i][1] == item_texture:
			#print("Search: ",weapon_texture_list[i][1])
			return true
		
func get_weapon_texture_list():
	return weapon_texture_list
	
func _process(delta): pass
