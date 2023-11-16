class_name inventory extends Node2D
var Equipped_Item = 0
var Inventory = {}

# Item list Slots for convenience
var item_name = 0
var item_maxstack = 1
var item_attack = 2
var item_defense = 3
var item_effect1 = 4
var item_effect2 = 5

var Item_List = {
# Item ID [Item Name // Item_Max_Stack // Item Attack // Item Defense // Item Effect1 // Item Effect2]
	0 : ["Fist",		1, 		1,				0,				null, null ],
	1 : ["Basic Sword",	1,		2,				0,				null, null ],
	2 : ["Steel Sword", 1,		3,				0,				null, null ]
}
# Called when the node enters the scene tree for the first time.
func _ready(loaded_inventory={}):	
	if loaded_inventory != {}:
		print("Inventory Loaded!")
		Inventory = loaded_inventory
	else:
		Inventory = {}
		
func _save_inventory():
	print(Inventory)
	return Inventory

func _load_inventory(loaded_inventory):
	print("Inventory Loaded!")
	Inventory = loaded_inventory

func _print_inventory():
	print("\n|================================|\n| Item Name				| Amount |\n|================================|")
	for item_id in Inventory:
		print("| ", Item_List[item_id][item_name], "	x ", Inventory[item_id])
	print("|================================|\n")

func _add_item(item_id, amount):
	var add_amount = amount
	# If item is in inventory
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
	var remove_amount = amount
	
	# Item is in inventory
	if Inventory.has(item_id):
		# Amount being removed would take item negative
		if Inventory[item_id] - remove_amount <= 0:
			if delete == false:
				Inventory[item_id] = 0
			else:
				_delete_item(item_id)
		else:
			Inventory[item_id] -= remove_amount
			
		if delete == false:
			print(Item_List[item_id][item_name], " in inventory updated to ", Inventory[item_id])
	# Item is not in inventory
	else: 
		print("Error: Item ID [",item_id,"] not in inventory, cannot remove.")
		
func _delete_item(item_id):
	if Inventory.has(item_id):
		Inventory.erase(item_id)
		print("Item ", Item_List[item_id][item_name]," was deleted from inventory.")
	else:
		print("Error: Item ID [",item_id,"] is not in inventory, cannot be deleted.")
		
func get_item_name(item_id):
	if Item_List.has(item_id):
		return Item_List[item_id][item_name]
	else:
		print("Error: Item does not exist.")
	return "None"

func get_item_attack(item_id):
	if Item_List.has(item_id):
		return Item_List[item_id][item_attack]
	else:
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
