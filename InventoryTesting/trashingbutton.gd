extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#set_accept_drop(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _gui_input(event):
	pass
	#if event is InputEventMouseMotion: #and _get_drag_data():
		#print("Item over the button")
		##print("Dragged item is over the drop target")
		#var drag_data = get_viewport().get_drag_data()
		#
		#var item_id = drag_data["item_id"]
		#var item_name = drag_data["item_name"]
		#print("Item on TrashArea: ", item_name, " (ID: ", item_id)
			##Items.Player_Inventory._delete_item(item_id)
		##drag_data["origin_slot"].clear_slot()
		#get_viewport().set_drag_preview(null)

func _can_drop_data(pos, data):
	return data.has("item_id") # Check if the drag data has the required fields
	
func _drop_data(pos, data):
	var item_id = data["item_id"] # 
	var item_name = data["item_name"]
	var item_count = data["item_count"] 
	var amount = item_count
	print("Item dropped: ", item_name, " with count ", item_count)
	#Items.Player_Inventory._load_inventory(loaded_inventory)
	# Check if the item count is greater than 1
	if item_count > 2:
		Items.Player_Inventory._minus_item(item_id, amount)
		Items.Player_Inventory._print_inventory()
	else:
		if data["origin_texture"] != self:
			data["origin_slot"].clear_slot()
		Items.Player_Inventory._delete_item(item_id)
		
		Items.Player_Inventory._print_inventory()
	
	
	#delete_item_from_inventory(item_id)
	
		
	if data["origin_texture"] != self:
		
		data["origin_slot"].clear_slot()



func _on_mouse_entered():
	modulate = Color(0.8, 0.8, 0.8) # Gray shade


func _on_mouse_exited():
	modulate = Color(1, 1, 1) # Normal color
