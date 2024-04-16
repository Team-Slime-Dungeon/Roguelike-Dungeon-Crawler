extends TextureButton
var is_occupied = false
@onready var icon = $"../Tabs/Inventory/EquipBackground/MainHand/Icon"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
#func _get_weapon_texture():
	#return icon.get_texture()

# Called every frame. 'delta' is the elapsed time since the previous frame.aw
func _process(delta):
	pass
	
func _can_drop_data(at_position, data):
	return !is_occupied and data.has("origin_texture") and data.has("EquipSlot")
	var origin_slot = data["origin_slot"]
	
	return self == origin_slot or !is_occupied
func _drop_data(at_position, data):
	
	var item_texture = data ["origin_texture"]
	var item_id = Items.Player_Inventory.get_item_id_by_texture(item_texture)

	var origin_slot = data["origin_slot"]
	var target_slot = self # Since this function is on the slot, 'self' refers to the target slot
	# Check if dropping back to the origin slot or moving to a new slot
	#if icon.has_meta("equipped_item_id"):
		#var item_id = icon.get_meta("equipped_item_id")
		#Items.Player_Inventory._delete_equip(item_id)
	if data["origin_texture"] != self:
		data["origin_slot"].clear_slot()
		Items.Player_Inventory._delete_equip(item_id)
		
			
			#deletes the weapon from the equipped dictionary
			
	
	

func _on_mouse_entered():
	modulate = Color(0.8, 0.8, 0.8) # Gray shade


func _on_mouse_exited():
	modulate = Color(1, 1, 1) # Normal color
