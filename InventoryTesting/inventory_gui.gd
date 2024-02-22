extends Control
#Loads the Item Slot Template
var template_inv_slot = preload("res://InventoryTesting/Inventory Template/inventorySlot.tscn")

#Save GridContainter Into a variable
@onready var gridcontainer = get_node("Tabs/Inventory/ItemBackground/Scroll/Grid")

#Inventory Visibility
var inventory_visible = true
var inv_slots = []
var last_inv_check

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
			# Loads The PNG of Weapon Into the Icon Texture
			var icon_texture = load("res://InventoryTesting/Item Test/" + item_name + ".png")
			inv_slots[index].get_node("Item_Icon").set_texture(icon_texture)
			#Moves to the next slot
			index += 1

func clear_items():	
	#Clears all the slots of the inventory gui screen
	for inv_slot in inv_slots:
		inv_slot.get_node("Item_Icon").set_texture(null)

#Makes sure it hides inventory when paused
func _on_pause_toggled(is_paused):
	if is_paused:
		hide()
		
func _input(event):
	#If player pressed "E" it opens and closes the inventory		
	if event.is_action_pressed("Inventory"):
		var inv_check = Items.Player_Inventory.Inventory
		
		# Updates the inventory if there are any changes (either amounts or in items held)
		if inv_check != last_inv_check:
			print("Inventory has changed! (was ",last_inv_check," new one is ", inv_check," )")
			# Make a copy of the current inventory to remember what was in there and remake the inventory
			last_inv_check = inv_check.duplicate()
			clear_items()
			make_inventory()

		inventory_visible = !inventory_visible  # Toggle the visibility flag
		set_visible(inventory_visible)


