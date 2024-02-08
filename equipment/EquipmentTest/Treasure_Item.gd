extends CharacterBody2D

#@onready var _animation_player = $AnimationPlayer
#Adds the sprite sheet into the variable
@onready var item_sprite = $ItemSheet  

#Creates an Index for the Frames
var item_frame_index = 0
var picked_up = false
var current_item = {}

func _ready():
	#set_item_frame(0) #Initializes an item
	choose_item_randomly() #random item initialized
	

func _process(_delta):
	pass

#ID number and Amount based on Frames
#JUST A TEST ID NUMBER, WILL CHANGE TO PROPER ID LATER
var item_properties = {
	0: {"ID": 0, "amount": 1},
	1: {"ID": 1, "amount": 1},
	2: {"ID": 3, "amount": 1},
	3: {"ID": 3, "amount": 1},
	4: {"ID": 4, "amount": 1},
	5: {"ID": 5, "amount": 1},
	6: {"ID": 6, "amount": 1},
	7: {"ID": 7, "amount": 1},
	8: {"ID": 8, "amount": 1},
	9: {"ID": 9, "amount": 1},
	10: {"ID": 10, "amount": 1},
	11: {"ID": 11, "amount": 1}
}

# Remove the item
func clear_item():
	queue_free() 

# Detects if Cassandra enters the Player Detection
func _on_player_detection_body_entered(body):
	if body.name == "Cassandra":
		# Collects item and emits signal with the item frame index
		emit_signal("Item Collected", current_item.ID, current_item.amount)
		picked_up = true
		

func set_item_frame(frame_index):
	# Update the sprite to show the specific frame from the item sheet.
	item_sprite.frame = frame_index
	#Sets the item property from the frame index and sets it to the current item
	current_item = item_properties[frame_index]

func _on_player_detection_area_entered(area):
	pass  
	
	
func choose_item_randomly():
	var frame_index = randi() % 12  # Randomly choose an index between 0 and 11
	set_item_frame(frame_index) #Sets Frame into item_Index
	print("Frame: ", frame_index)#Test Purposes
	print("Item_ID = ", current_item.ID) #Test Purposes
