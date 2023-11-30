extends Control
#Loads the Item Slot Template
var template_inv_slot = preload("res://InventoryTesting/Inventory Template/inventorySlot.tscn")

#Save GridContainter Into a variable
@onready var gridcontainer = get_node("Background/M/V/ScrollContainer/GridContainer")

#Inventory Visibility
var inventory_visible = true

func _ready():
	#Uses PlayerData info and turns them into New Slots which will use the Slot template instance
	for i in PlayerData.inv_data.keys():
		var inv_slot_new = template_inv_slot.instantiate()
		#If Inventory Slot "i" sees ID on "Item" in Inventory_Data file
		if PlayerData.inv_data[i]["Item"] != null:
			#Defines Item Name by Checking item_data in GameData and Grabs the Item ID from the PlayerData in inv_data and grabs the Item ID which is used to grab the Name of item
			var item_name = GameData.item_data[str(PlayerData.inv_data[i]["Item"])]["Name"]
			#Loads The PNG of Weapon Into the Icon Texture
			var icon_texture = load("res://InventoryTesting/Item Test/" + item_name + ".png")	
			inv_slot_new.get_node("Item_Icon").set_texture(icon_texture)
			#Adds the new instance into the grid containter
		gridcontainer.add_child(inv_slot_new, true)
		
		#Grab Signal from Pause Menu node
	var pause_menu = get_node("../../Pause_Menu")
	pause_menu.connect("pause_toggled", Callable(self, "_on_pause_toggled"))

#Makes sure it hides inventory when paused
func _on_pause_toggled(is_paused):
	if is_paused:
		hide()	
		
func _input(event):
	#If player pressed "E" it opens and closes the inventory
	if event.is_action_pressed("Inventory"):
		inventory_visible = !inventory_visible  # Toggle the visibility flag
		set_visible(inventory_visible)
