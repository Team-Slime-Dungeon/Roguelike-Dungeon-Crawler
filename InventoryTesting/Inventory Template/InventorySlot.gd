extends TextureRect

# Track if the slot is occupied
var is_occupied = false 


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
		
		#conditional checks to see if the texture being dropped into slot is a weapon 
		#problem: if you choose to move a weapon into any slot it'll delete the equipped weapon regardless of your intentions
		#example: weapon_1 is equipped, but you move weapon_2 in any of the slots in the main inventory will delete the weapon in the equipped slot
		if Items.Player_Inventory.search_texture(item_texture) == true:
			var item_id = Items.Player_Inventory.get_item_id_by_texture(item_texture)
			
			#deletes the weapon from the equipped dictionary
			Items.Player_Inventory._delete_equip(item_id)
			#adds the weapon back into the main inventory
			Items.Player_Inventory._add_item(item_id, 1)
			print("The current inventory is: ")
			Items.Player_Inventory._print_inventory()
			
			var current_weapon = Items.Player_Inventory.get_current_weapon()
			print("Current weapon is: ", current_weapon)
			


			

func clear_slot():
	texture = null
	is_occupied = false
