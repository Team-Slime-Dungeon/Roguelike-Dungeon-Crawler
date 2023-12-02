extends Control

var inventory_visible = true
# Called when the node enters the scene tree for the first time.
func _ready():
	var pause_menu = get_node("../../Pause_Menu")
	pause_menu.connect("pause_toggled", Callable(self, "_on_pause_toggled"))

func _on_pause_toggled(is_paused):
	if is_paused:
		hide()	
		
func _input(event):
	#If player pressed "E" it opens and closes the inventory
	if event.is_action_pressed("Inventory"):
		inventory_visible = !inventory_visible  # Toggle the visibility flag
		set_visible(inventory_visible)
