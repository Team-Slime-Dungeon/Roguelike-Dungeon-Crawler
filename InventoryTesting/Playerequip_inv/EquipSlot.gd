extends TextureRect

@onready var icon = $"."

var is_occupied = false 

func _ready():
	#_set_weapon_texture("weapon_1")
	_set_weapon_texture()
		
			
	
func update_slot_state():
	# Update `is_occupied` based on the current texture
	is_occupied = texture != null
	
#sets the weapon texture from the Inventory.gd
func _set_weapon_texture():	
	var item_name = Items.Player_Inventory.get_current_weapon()
	#print("item_name is ", item_name)
	#print("this is the current name of the weapon ", name)
	var icon_texture = load("res://InventoryTesting/Item Test/" + item_name + ".png")
	icon.set_texture(icon_texture)
	print("Set weapon texture has been called")
	#print("this is the new item texture ", item_name)


#Ignore this, it was for testing purpoese	
#func _get_icon():
	#return icon	
	
	
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

func clear_slot():
	texture = null
	is_occupied = false
