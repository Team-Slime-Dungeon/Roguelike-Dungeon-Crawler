class_name inventory extends Node2D
var Held_Item = 0
var Inventory = {}

# Item list Slots for convenience
var item_name = 0
var item_maxstack = 1
var item_attack = 2
var item_defense = 3
var item_effect1 = 4
var item_effect2 = 5

# Indexes for item categories for outside use
var weapon_start_index = 1
var weapon_end_index = 50

var treasure_start_index = 51
var treasure_end_index = 100

var Item_List = {
# Item ID [Item Name // Item_Max_Stack // Item Attack // Item Defense // Item Effect1 // Item Effect2]
	0 : ["Coin",			99,		0,				0,				null, null ],
	
	# Weapons and Equipment IDs 1 - 50
	1 : ["Basic Sword",		1,		2,				0,				null, null ],
	2 : ["Steel Sword", 	1,		3,				0,				null, null ],
	3 : ["Bronze Helmet",	1,		0,				5,				null, null ],
	
	# Treasures IDs 51 - 100. 51 will spawn a random item, 52 on can be found inside 51
	51: ["Random Treasure",	0,		0,				0, 				null, null ],
	
	52: ["Ruby Necklace",	99,		0,				0, 				null, null ],
	53: ["Emerald Crown",	99,		0,				0, 				null, null ],
	54: ["Ancient Tome",	99,		0,				0, 				null, null ],
	55: ["Ruby",			99,		0,				0, 				null, null ],
	56: ["Old Earring",		99,		0,				0, 				null, null ],
	57: ["Ancient Coins",		99,		0,				0, 				null, null ],
	58: ["Pearl Necklace",	99,		0,				0, 				null, null ],
	59: ["Sapphire",		99,		0,				0, 				null, null ],
	60: ["Emerald",			99,		0,				0, 				null, null ],
	61: ["Topaz",			99,		0,				0, 				null, null ],
	62: ["Sacred Technology",99999,	0,				0, 				null, null ], # I actually have that many
	63: ["Diamond",			99,		0,				0, 				null, null ],
	64: ["Petrified Egg",	99,		0,				0, 				null, null ],

	71: ["Blue Mushroom",	99,		0,				0, 				null, null ],
}

# Called when the node enters the scene tree for the first time.
func _ready(loaded_inventory={}):	
	if loaded_inventory != {}:
		print("Inventory Loaded!")
		Inventory = loaded_inventory
	else:
		Inventory = {0:0}

func _save_inventory(print=false):
	# Takes the current inventory and returns it as a dictionary of { Item ID: Amount }
	if print: print(Inventory)
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
	return Inventory[0]
	
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
	# Item is not in inventory
	else: 
		print("Error: Item ID [",item_id,"] not in inventory, cannot remove.")
		
func _delete_item(item_id):
	# Check if the inventory has the item
	if Inventory.has(item_id):
		# Delete the item from the inventory dictionary
		Inventory.erase(item_id)
		print("Item ", Item_List[item_id][item_name]," was deleted from inventory.")
	else:
		# If item ID is not found in inventory, print error to terminal
		print("Error: Item ID [",item_id,"] is not in inventory, cannot be deleted.")
		
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
