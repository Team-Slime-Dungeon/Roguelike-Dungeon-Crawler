extends TextureRect

# Track if the slot is occupied
var is_occupied = false 
var weapon1_texture = load("res://InventoryTesting/Item Test/weapon_1.png")	
var weapon2_texture = load("res://InventoryTesting/Item Test/weapon_2.png")	
var practice ={
	1:["weapon_1", weapon1_texture],
	2:["weapon_2", weapon2_texture]
	}

func _ready():
	# Initialize slot state if needed
	update_slot_state()

func update_slot_state():
	# Update `is_occupied` based on the current texture
	is_occupied = texture != null

#Allows the png to be dragged in the inventory
func _get_drag_data(_pos):
	var data = {}
	# Add reference to self
	data["origin_slot"] = self  
	data["origin_texture"] = texture
	data["is_empty"] = !is_occupied
	
	var inventory_slot = get_parent().get_name()
	print("Attempting to access slot: ", inventory_slot)
	print("slots available: ", Items.Player_Inventory.Inventory.keys())
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.set_size(Vector2(100, 100))
	
	var control = Control.new()
	control.add_child(drag_texture)
	set_drag_preview(control)
	
	return data

# Check if the slot is empty and if the drop data is valid
func _can_drop_data(at_position, data):
	return !is_occupied and data.has("origin_texture")

func _drop_data(at_position, data):
	if _can_drop_data(at_position, data):
		texture = data["origin_texture"]
		is_occupied = true
		
		# Clear the origin slot if it's different from the target slot
		if data["origin_slot"] != self:
			data["origin_slot"].clear_slot()
		var item_texture = texture
		if search_texture(item_texture) == true:
			var item_id = get_item_id_by_texture(item_texture)
			#print("Item name is" ,item_name)
			#var item_id = Items.Player_Inventory.get_Item_Id_By_Name(item_name)
			Items.Player_Inventory._delete_equip(item_id)
			#texture = null
			Items.Player_Inventory._add_item(item_id, 1)
			print("The current inventory is: ")
			Items.Player_Inventory._print_inventory()
			#print("Current Equip is: ", Items.Player_Inventory.get_current_weapon() )
			var current_weapon = Items.Player_Inventory.get_current_weapon()
			print("Current weapon is: ", current_weapon)
			#print("Equip Stats: ",Items.Player_Inventory.get_equip_weapon_stats())
func get_item_id_by_texture(item_texture):
	for i in practice:
		if practice[i][1]==item_texture:
			print("printed statement: ",practice[i][1])
			return i
func search_texture(item_texture):
	
	for i in practice:
		if practice[i][1] == item_texture:
			print("Search: ",practice[i][1])
			return true
			

func clear_slot():
	texture = null
	is_occupied = false
