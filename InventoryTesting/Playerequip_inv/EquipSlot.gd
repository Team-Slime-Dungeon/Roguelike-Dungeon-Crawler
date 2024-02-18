extends TextureRect

var icon_texture = load("res://InventoryTesting/Item Test/weapon_2.png")
@onready var icon = $"."

func _ready():
	_set_weapon_texture()
	#var icon_texture = load("res://InventoryTesting/Item Test/" + item_name + ".png")
	#icon.set_texture(icon_texture)		
	
#sets the weapon texture from the Inventory.gd
func _set_weapon_texture():
	var item_name = Items.Player_Inventory.get_item_name(1)
	var icon_texture = load("res://InventoryTesting/Item Test/" + item_name + ".png")
	icon.set_texture(icon_texture)	
	
#returns the equipped weapon's texture	
func _get_weapon_texture():
	return icon.get_texture()
func _get_drag_data(_pos):
	var data = {}
	data ["origin_texture"] = texture
	
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
	return true
	return false
	
func _drop_data(at_position, data):
	
	pass
