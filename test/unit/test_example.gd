extends GutTest

func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

# Tests for _add_item(item_id, amount)
class Test_Adding: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()

	func before_each():
		Player_inventory = inventory.new()
		Player_inventory._ready()

	# Add a single item to the inventory
	func test_Add_to_Inventory():
		# Adds a single item to inventory
		Player_inventory._add_item(1,1)
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {1:1}, "Does not contain single item in inventory?")
	
	# Add multiple items to the inventory
	func test_Add_Multiple():
		Player_inventory._add_item(0,1)
		Player_inventory._add_item(1,1)		
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {0:1, 1:1}, "Does not match expected inventory.")		
	
	# Add too many items to the inventory
	func test_Inventory_Overfill():
		# Add two swords, should only be able to carry one.
		Player_inventory._add_item(1,1)
		Player_inventory._add_item(1,1) # Shouldn't add anything
		
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv,{1:1}, "Item went over maximum amount allowed?")

	# Try to overfill the inventory with multiple items
	func test_Overfill_Multiple_Inventory():
		# Add two fist items individually, should only be able to carry one.
		Player_inventory._add_item(0,1)
		Player_inventory._add_item(0,1) # Shouldn't add anything
		
		# Add five swords, should only be able to carry one.
		Player_inventory._add_item(1,5)
		
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {0:1, 1:1}, "Inventory not what was expected?")

class Test_Get_Item_Name: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()

	func before_each():
		Player_inventory = inventory.new()
		Player_inventory._ready()
		
	func test_No_Item():
		# Test if there is nothing in the inventory
		var expected_name = "None"
		var returned_name = Player_inventory.get_item_name(null)
		assert_eq(returned_name, expected_name, "Returned item name does not match expected item name.")
	
	func test_Get_Single_Item_Name():
		# Adds a single of item id 2 to inventory
		Player_inventory._add_item(2,1)
		# Gets the item's name and compares it to expected value
		var expected_name = "Steel Sword"
		var returned_name = Player_inventory.get_item_name(2)
		assert_eq(returned_name, expected_name, "Returned item name does not match expected item name.")
		
	func test_Not_Get_Single_Item_Name():
		# Check if the returned item does not match what's expected
		var expected_name = "Basic Sword"
		var returned_name = Player_inventory.get_item_name(2)
		assert_ne(returned_name, expected_name, "Returned item name does not match expected item name.")
		
	func test_Non_Existing_Single_Item_Name():
		# Check if a non-existing returned item does not match what's expected
		var expected_name = "Basic Sword"
		var returned_name = Player_inventory.get_item_name(10) # There is no item at this ID
		assert_ne(returned_name, expected_name, "Returned item name does not match expected item name.")
		
	func test_Non_Int_Item_Name():
		Player_inventory._add_item("a", 1)
		# Attempt to add invalid item to inventory, then check that one does not exist
		var expected_name = "Steel Sword"
		var returned_name = Player_inventory.get_item_name("a")
		assert_ne(returned_name, expected_name, "Returned item name does not match expected item name.")

class Test_Get_Item_Attack: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()

	func before_each():
		Player_inventory = inventory.new()
		Player_inventory._ready()

	# Test get_item_attack() method
	func test_Get_Single_Item_Attack():
		# Add a single of item_id 0 to the inventory
		Player_inventory._add_item(0,1)

		# Get the item's attack
		var expected_attack = 1 # Expected Item Attack (Item ID 0)
		var test_attack = Player_inventory.get_item_attack(0) # Get item attack for item id 0
		assert_eq(test_attack, expected_attack, "Item attack doesn't match expected value.")

class Test_Get_Item_Defense: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()

	func before_each():
		Player_inventory = inventory.new()
		Player_inventory._ready()
		
	# Test get_item_attack() method
	func test_Get_Single_Item_Defense():
		# Add a single of item_id 3 to the inventory
		Player_inventory._add_item(3,1)

		# Get the item's Defense
		var expected_defense = 5 # Expected Item Attack (Item ID 3)
		var test_defense = Player_inventory.get_item_defense(3) # Get defense for item id 3
		assert_eq(test_defense, expected_defense, "Item defense doesn't match expected value.")	
		
		
	func test_Get_Item_Defense_For_Multiple_Items():
		Player_inventory._add_item(1, 2)  # Item ID 1 with quantity 2
		# Add multiple items to the inventory
		Player_inventory._add_item(2, 3)  # Item ID 2 with quantity 3
		# Get the defense for both items
		var expected_defense_1 = 0  # Expected Item Defense (Item ID 1)
		var test_defense_1 = Player_inventory.get_item_defense(1)
		assert_eq(test_defense_1, expected_defense_1, "Item 1 defense doesn't match expected value.")
		var expected_defense_2 = 0  # Expected Item Defense (Item ID 2)
		var test_defense_2 = Player_inventory.get_item_defense(2)
		assert_eq(test_defense_2, expected_defense_2, "Item 2 defense doesn't match expected value.")   
	func test_Get_Item_Defense_For_Empty_Inventory():
		var test_defense = Player_inventory.get_item_defense(1)  # Item ID 1
		assert_eq(test_defense, 0, "Expected defense for an item in an empty inventory to be 0.")
		# Test getting defense for an item in an empty inventory
	func test_Get_Nonexistent_Item_Defense():
		var non_existent_item_id = 999
		# Try to get the defense for an item that doesn't exist in the inventory
		var test_defense = Player_inventory.get_item_defense(non_existent_item_id)
		assert_eq(test_defense, 0, "Expected defense for a non-existent item to be 0.")
		
	func test_Get_Item_Defense_For_Negative_Quantity():
		# Add an item with a negative quantity to the inventory
		Player_inventory._add_item(4, -2)  # Item ID 4 with quantity -2
		# Get the defense for the item
		var expected_defense = 0  # Expected Item Defense (Item ID 4)
		var test_defense = Player_inventory.get_item_defense(4)
		assert_eq(test_defense, expected_defense, "Item defense for negative quantity doesn't match expected value.")


class Test_Load_Inventory: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()
	
	# Make sure loading an inventory isn't empty
	func test_Load_Inventory():
		Player_inventory._load_inventory({1:1})
		var test_inv = Player_inventory._save_inventory()
		assert_ne(test_inv, {}, "Inventory shouldn't be empty")
		
class Test_Save_Inventory: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()

	func before_each():
		Player_inventory = inventory.new()
		Player_inventory._ready()
	
	func test_Saving_New_Inventory():
		# Adds one of item with id 2 to inventory
		Player_inventory._add_item(2,1)
		
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {2:1}, "Inventory not as expected?")
		print("Saving Test:")
		print(test_inv)
		
	func test_Saving_Another_Inventory():
		# Adds one of item with id 2 to inventory
		Player_inventory._add_item(2,1)
		
		var test_inv = Player_inventory._save_inventory()
		Player_inventory._add_item(3,1)
		Player_inventory._add_item(1,1)
		# Checks that test_inv is not NULL
		assert_ne(test_inv, {}, "Inventory  is empty!")
		print("Multiple Item Test:")
		print(test_inv)
	
	func test_Saving_Inventory_With_Invalid_Item():
	# Add an invalid item to the inventory
		Player_inventory._add_item(-1, 1) # Assuming -1 is an invalid ID
	
		var test_inv = Player_inventory._save_inventory()
	# Check if the inventory contains the invalid item. It should not.
		assert_eq(test_inv.has(-1), false, "Inventory contains an invalid item!")
		print("Invalid Item Test:")
		print(test_inv)
		
	func test_Rapid_Add_Remove():
		for i in range(1000):
			Player_inventory._add_item(2, 1)
			Player_inventory._delete_item(2)

		var test_inv = Player_inventory._save_inventory()

	# Inventory should be empty at the end
		assert_eq(test_inv, {}, "Inventory should be empty after rapid add/remove.")
		print("Rapid test:")
		print(test_inv)

class Test_Remove_Items: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()

	# Test removing items
	func test_Remove_Items():
		# Add two items (ids 0 and 1)
		Player_inventory._add_item(0,1)
		Player_inventory._add_item(1,1)
		
		#Remove one of item id 1
		Player_inventory._minus_item(1,1)
		
		#Should be two items in inventory, one item id 0 and 0 of item id 1
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {0:1, 1:0}, "Should contain one item and one empty item")

class Test_Delete_Items: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()

	func before_each():
		Player_inventory = inventory.new()
		Player_inventory._ready()
	
	#deletes one item from an inventory of two items	
	func test_Destroy_Items():
		# Add two items
		Player_inventory._add_item(0,1)
		Player_inventory._add_item(1,1)
		
		#Delete one
		Player_inventory._delete_item(1)
		
		#Should be one item
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {0:1}, "Should contain one item only")
	
	#deletes two items from an inventory of two items	
	func test_Destroy_Two_Items():
		
		# Add two items
		Player_inventory._add_item(0,1)
		Player_inventory._add_item(1,1)
		
		#Delete both items
		Player_inventory._delete_item(1)
		Player_inventory._delete_item(0)
		
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {}, "Should contain no items")
	
	#deletes no items, item does not exist in inventory	
	func test_Destroy_no_items():
		Player_inventory._add_item(0,1)
		
		Player_inventory._delete_item(1)
		
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {0:1}, "Item does not exist, cannot be deleted")
	
	#deletes no items, there are no items in the inventory	
	func test_Destroy_no_items_empty_inv():
		Player_inventory._delete_item(1)
		
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {}, "Inventory is empty, there are no items to delete")
		
class Test_Inventory_System: #############################################################################################
	extends GutTest

	# Create a new inventory for the tests
	var Obj = load('res://Inventory.gd')
	var Player_inventory = inventory.new()

	func before_each():
		Player_inventory = inventory.new()
		Player_inventory._ready()

	# Initialized inventory test, should be empty
	func test_Starting_Inventory():
		var test_inv = Player_inventory._save_inventory()
		assert_eq(test_inv, {}, "Inventory not empty")
		



