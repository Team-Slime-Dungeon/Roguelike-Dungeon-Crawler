extends TextureRect
# List of valid weapon names
var valid_weapon_names = ["Bronze Helmet", "Silver Helmet", "Gold Helmet"]
@onready var icon = $"."
#var default_texture: Texture
var current_texture: Texture
var is_occupied = false 
@onready var default_texture = preload("res://InventoryTesting/InventoryBackgroundPics/Helmet Slot.png")
func _ready():pass
	
	
func update_slot_state():
	# Update `is_occupied` based on the current texture
	is_occupied = texture != null
	
	
	
	
func set_slot_texture(texture_path: String):
	if texture_path != "":
		current_texture = load(texture_path)
		#modulate = Color(1, 1, 1, 1)  # Full color for any non-default texture
	else:
		current_texture = default_texture
		#modulate = Color(0.784, 0.784, 0.784, 0.5)  # Apply ghostly, semi-transparent modulate for default texture
	texture = current_texture
#returns the equipped weapon's texture	
func _get_weapon_texture():
	return icon.get_texture()
	
func _get_drag_data(_pos):
	
	var equip_slot = get_parent().get_name()
	
	var data = {}
	data ["origin_texture"] = texture
	data ["origin_slot"] = self
	data["is_empty"] = !is_occupied
	data["EquipSlot"] = data
	
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
	return !is_occupied and data.has("origin_texture") and data.get("item_name") in valid_weapon_names

func _drop_data(at_position, data):
	var origin_slot = data["origin_slot"]
	var item_id = data["item_id"] # 
	var item_name = data["item_name"]
	data["item_id"] = item_id
	var item_count = data["item_count"] 
	var amount = item_count
	var new_weapon_id = data["item_name"]
	
	if item_name: # Check if `item_name` is not empty
		#Items.Player_Inventory.get_item_name(item_id)
		emit_signal("item_equipped", item_name)
		self.set_meta("equipped_item_name", item_name) # Set metadata
		var texture_path = "res://InventoryTesting/Item Test/%s.png" % item_name
		var loaded_texture = load(texture_path)
		if loaded_texture:
			self.texture = loaded_texture
			is_occupied = true # Update the slot's occupation
			
			
	print("Item equipped: ", item_name, " with ID ", item_id)
	
	
	
	
	
	

			
func clear_slot():
	texture = null
	is_occupied = false
	set_slot_texture("")  # This will load the default textur
