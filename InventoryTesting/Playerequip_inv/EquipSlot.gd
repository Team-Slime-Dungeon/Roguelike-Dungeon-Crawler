extends TextureRect

@onready var icon = $"."

var is_occupied = false 

func update_slot_state():
	# Update `is_occupied` based on the current texture
	is_occupied = texture != null
	
	
	
#returns the equipped weapon's texture	
func _get_weapon_texture():
	return icon.get_texture()
	
func _get_drag_data(_pos):
	
	var equip_slot = get_parent().get_name()
	
	var data = {}
	data ["origin_texture"] = texture
	data ["origin_slot"] = self
	data["is_empty"] = !is_occupied
	
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.set_size(Vector2(65,65))
	
	var control = Control.new()
	control.add_child(drag_texture)
	
	#Makes the texture allign with the mouse
	drag_texture.position = -0.5 * drag_texture.get_minimum_size()
	
	set_drag_preview(control)
	
	return data
	
func _can_drop_data(at_position, data):
	return !is_occupied and data.has("origin_texture")

func _drop_data(at_position, data):
	if _can_drop_data(at_position, data):
		texture = data["origin_texture"]
		is_occupied = true
		
		# Clear the origin slot if it's different from the target slot
		if data["origin_slot"] != self:
			data["origin_slot"].clear_slot()
	
	#gets the the icon's textures
	#gets the weapon's id by it associated texture
	#equips the weapon (adds it the equip weapon stats list) and deletes the weapon from the main inventory
	#prints out the current weapon
	#prints out the new inventory
	var item_texture = icon.get_texture()
	var equip_weapon_id = Items.Player_Inventory.get_item_id_by_texture(item_texture)
	Items.Player_Inventory.equip_weapon(equip_weapon_id)	
	var current_weapon = Items.Player_Inventory.get_current_weapon()
	print("The current weapon is ", current_weapon)
	Items.Player_Inventory._print_inventory()
	
	
	

			
func clear_slot():
	texture = null
	is_occupied = false
