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
	data["origin_texture"] = texture
	data["is_empty"] = !is_occupied
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.set_size(Vector2(65, 65))
	
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
		# Mark the slot as occupied now
		is_occupied = true

