extends CharacterBody2D

#@onready var _animation_player = $AnimationPlayer
#Adds the sprite sheet into the variable
@onready var item_sprite = $WeaponSheet

#Creates an Index for the Frames
var item_frame_index = 0

var player_in_area = false
var picked_up = false
var shop_item = false
var text_update = false

var current_item = {}
var ID = 1
var amount = 1

func _ready():
	#set_item_frame(1) #Initializes a potion
	choose_item_randomly()

func _set_shop(state = false):
	shop_item = state

#ID number and Amount based on Frames
var item_properties = {
	0: {"ID": 1, "amount": 1},
	1: {"ID": 2, "amount": 1},
	2: {"ID": 3, "amount": 1}
}

# Remove the item
func clear_item():
	queue_free() 

# Detects if Cassandra enters the Player Detection
func _on_player_detection_body_entered(body):	
	if body.name == "Cassandra": 
		player_in_area = true
		text_update = true
		
func _on_player_detection_body_exited(body): 	if body.name == "Cassandra": player_in_area = false

func _process(delta):
	if player_in_area:
		if shop_item == true:
			if text_update:
				print("Item: ",Items.Player_Inventory.get_item_name(current_item.ID), " cost is: ", Items.Player_Inventory._get_item_price(current_item.ID))
				text_update = false

			if Input.is_action_just_pressed("interact"):
				print("Attempting purchase")
				if Items.Player_Inventory._pay_for_item(current_item.ID, 1):
					get_parent().shop_success()
				else:
					get_parent().shop_fail()
				
		else:
			# Collects item and emits signal with the item frame index
			emit_signal("Weapon Collected", current_item.ID, current_item.amount)
			picked_up = true
			
func set_item_frame(frame_index):
	# Update the sprite to show the specific frame from the item sheet.
	item_sprite.frame = frame_index
	
	#Sets the item property from the frame index and sets it to the current item
	current_item = item_properties[frame_index]

func choose_item_randomly():
	var frame_index = randi() % 3  # Randomly choose an index between 0 and 3
	set_item_frame(frame_index)
	ID = current_item.ID
	amount = current_item.amount
	#print("Frame: ", frame_index)#Test Purposes
	print("Item_ID = ", current_item.ID) #Test Purposes
