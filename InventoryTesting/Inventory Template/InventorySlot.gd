extends TextureRect
signal item_set(item_name, inventory_slot, item_count)
#var count_node = visible
@onready var count_node = $count
# Track if the slot is occupied
var is_occupied = false 
#var item_name = ""
func _ready():
	# Initialize slot state if needed#as
	update_slot_state()

func update_slot_state():
	# Update `is_occupied` based on the current texture
	is_occupied = texture != null

#Allows the png to be dragged in the inventory
func _get_drag_data(_pos):
	
	#for i in Items.Player_Inventory.Inventory.keys():
		#var item_name = Items.Player_Inventory.get_item_name(i)
		#print("item dragged: ", item_name)
	var inventory_slot = get_parent().get_name() #inv_slots[index].get_name()
	var item_name = get_parent().get_meta("item_name") if get_parent().has_meta("item_name") else "Unknown Item"
	var item_count = get_parent().get_meta("item_count") if get_parent().has_meta("item_count") else 0
	#clear_slot(item_count)
	var item_id = get_parent().get_meta("item_id") if get_parent().has_meta("item_id") else "Unknown ID"
	#var inventory_slot = get_parent().get_name()
	print("Attempting to access slot: ", inventory_slot)
	print("Item being dragged: ", item_name, " from slot ", inventory_slot, " with count:", item_count, " ID ", item_id)

	
	var data = {}
	data["origin_texture"] = texture
	data["origin_texture"] = self
	data["is_empty"] = !is_occupied
	data["origin_slot"] = self
	data["item_name"] = item_name
	data["item_id"] = item_id
	data["item_count"] = item_count
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.set_size(Vector2(65, 65))
	#drag_texture.texture = item_name
	
	var control = Control.new()
	control.add_child(drag_texture)
	set_drag_preview(control)
	
	return data
	

# Check if the slot is empty and if the drop data is valid
func _can_drop_data(at_position, data):
	#pass
	var origin_slot = data["origin_slot"]
	return self == origin_slot or !is_occupied
	#return !is_occupied #and data.has("origin_texture")

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
			


			

	var origin_slot = data["origin_slot"]
	var target_slot = self # Since this function is on the slot, 'self' refers to the target slot
	# Check if dropping back to the origin slot or moving to a new slot
	if origin_slot != target_slot and !_can_drop_data(at_position, data):
		return
	


func clear_slot():
	
	
	texture = null
	
	is_occupied = false
	#var count_node = get_node_or_null("Item_Icon/count")
	if count_node.visible:
		count_node.visible = false
#func clear_count():
	#var count_node = self.get_node("Item_Icon/count")
	#count_node.visible = false  # Or make it invisible
