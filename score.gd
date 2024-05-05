extends Node2D
var treasure = {}
var total = 0

func _ready():
	# Get all treasures and quantities
	for i in range(52, 73):
		if Items.Player_Inventory.get_item_amount(i) != 0:
			treasure[Items.Player_Inventory.get_item_name(i)] = Items.Player_Inventory.get_item_amount(i)
			total += Items.Player_Inventory._get_item_price(i, Items.Player_Inventory.get_item_amount(i))
	# Get coin
	if Items.Player_Inventory.get_item_amount(0) != 0:
			treasure[Items.Player_Inventory.get_item_name(0)] = Items.Player_Inventory.get_item_amount(0)
			total += Items.Player_Inventory._get_coins()
	
	var y = -195
	for key in treasure.keys():
		var itemLabel = Label.new()
		itemLabel.text = str(key) + " x " + str(treasure[key])
		itemLabel.size = Vector2(200, 20)
		itemLabel.position = Vector2(-100, y)
		add_child(itemLabel)
		y += 30
	
	$Camera2D/NinePatchRect/Total.set_text("Total: " + str(total))

func _process(delta): pass

func _on_continue_pressed(): 
	Items.Player_Inventory._load_inventory({0:0})
	get_tree().change_scene_to_file("res://MainMenuStart.tscn")
