extends Control
#Loads the Item Slot Template
var template_inv_slot = preload("res://InventoryTesting/Inventory Template/inventorySlot.tscn")

#Save GridContainter Into a variable
@onready var gridcontainer = get_node("Tabs/Inventory/ItemBackground/Scroll/Grid")

#Inventory Visibility
var inventory_visible = true
var inv_slots = []
var last_inv_check

var companion = 1


func _ready():
	#Grab Signal from Pause Menu node
	var pause_menu = get_node("../../Pause_Menu")
	pause_menu.connect("pause_toggled", Callable(self, "_on_pause_toggled"))
	initialize_empty_slots()
	
	


func initialize_empty_slots():
	# Create 16 empty inventory slots
	for i in range(16):
		var inv_slot_new = template_inv_slot.instantiate()
		gridcontainer.add_child(inv_slot_new, true)
		inv_slots.append(inv_slot_new)
	

func make_inventory():
			
	# Use PlayerData info and turns them into New Slots which will use the Slot template instance
	var index = 0 # Start filling from the first slot
	for i in Items.Player_Inventory.Inventory.keys():
		if index >= inv_slots.size():
			break # Prevents adding more items than slots available
			
		if i != 0: # Skips loading coin into the first slot
			var item_name = Items.Player_Inventory.get_item_name(i)
			var item_count = Items.Player_Inventory.get_item_amount(i)
			var item_id = i
			var inventory_slot = inv_slots[index].get_name()
			# Loads The PNG of Weapon Into the Icon Texture
			var icon_texture = load("res://InventoryTesting/Item Test/" + item_name + ".png")
			inv_slots[index].get_node("Item_Icon").set_texture(icon_texture)

			inv_slots[index].get_node("Item_Icon/count").text = str(item_count)
			inv_slots[index].get_node("Item_Icon/count").visible = true
			inv_slots[index].set_meta("item_name", item_name)
			inv_slots[index].set_meta("item_id", item_id)
			inv_slots[index].set_meta("item_count", item_count)
			inv_slots[index].set_meta("original_slot", inventory_slot)
			print("Item Added: ", item_name, " in slot: ", inventory_slot, " ID: ", item_id)
			#slot.set_meta("original_slot", slot.get_name())
			
			
			var background_color = get_background_color(item_name)
			inv_slots[index].get_node("Background").modulate = background_color  

			#Moves to the next slot
			#print("item name is ", item_name)
			index += 1

func clear_items():	
	#Clears all the slots of the inventory gui screen
	for inv_slot in inv_slots:
		inv_slot.get_node("Item_Icon").set_texture(null)
		inv_slot.get_node("Item_Icon/count").visible = false
		# Reset the background color to transparent
		inv_slot.get_node("Background").modulate = Color(0, 0, 0, 0)  # Fully transparent

#Makes sure it hides inventory when paused
func _on_pause_toggled(is_paused):
	if is_paused:
		hide()
		
func _input(event):
	#If player pressed "E" it opens and closes the inventory		
	if event.is_action_pressed("Inventory"):
		var inv_check = Items.Player_Inventory.Inventory
		
		label_based_on_companion()
		#set_label_text("Inventory Open")
		
		# Updates the inventory if there are any changes (either amounts or in items held)
		if inv_check != last_inv_check:
			print("Inventory has changed! (was ",last_inv_check," new one is ", inv_check," )")
			# Make a copy of the current inventory to remember what was in there and remake the inventory
			last_inv_check = inv_check.duplicate()
			clear_items()
			make_inventory()

		inventory_visible = !inventory_visible  # Toggle the visibility flag
		set_visible(inventory_visible)

#Function to change the label
func set_label_text(new_text):
	var label_node = get_node("Tabs/Companion/Background/Label")
	if label_node:
		label_node.text = new_text
	else:
		print("Label node not found at path: " + label_node)
		
func set_label2_text(new_text):
	var label_node = get_node("Tabs/Companion/Background/Label2")
	if label_node:
		label_node.text = new_text
	else:
		print("Label node not found at path: " + label_node)
		
func set_label3_text(new_text):
	var label_node = get_node("Tabs/Companion/Background/Label3")
	if label_node:
		label_node.text = new_text
	else:
		print("Label node not found at path: " + label_node)

#Funtion to change all labels based on companions
func label_based_on_companion():
	if companion == 1:
		set_label_text("Companion1 Name HP :")
		set_label2_text("         Effect: \n Some description \n of the companion \n and their abilities")
		set_label3_text("There is something else that we can add Here im sure")
		
	elif companion == 2:
		set_label_text("Companion2 Name HP :")
		set_label2_text("         Effect: \n Some description \n of the companion \n and their abilities")
		set_label3_text("This has changed to make sure it works")
		
	elif companion == 3:
		set_label_text("Companion3 Name HP :")
		set_label2_text("         Effect: \n Some description \n of the companion \n and their abilities")
		set_label3_text("Still couldnt figure out what to put down here")
		
	else:
		set_label_text("Companion value error")
		set_label2_text("Companion value error")
		set_label3_text("Companion value error")
		
		

func get_background_color(item_name: String) -> Color:
	match item_name:
		"Bronze Sword", "Bronze Helmet":
			return Color(0.804, 0.498, 0.196)  # Semi-transparent red
		"Silver Sword", "Silver Helmet":
			return Color(0.753, 0.753, 0.753)  # Semi-transparent green
		"Gold Sword", "Gold Helmet":
			return Color(1.0, 0.843, 0.0)  # Semi-transparent blue
		_:
			return Color(0, 0, 0, 0)  # Default, transparent



func _on_texture_button_mouse_entered():
	pass # Replace with function body.


func _on_texture_button_mouse_exited():
	pass # Replace with function body.
