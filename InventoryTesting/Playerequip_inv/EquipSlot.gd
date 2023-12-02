extends TextureRect

func _get_drag_data(_pos):
	var data = {}
	data ["origin_texture"] = texture
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.set_size(Vector2(65,65))
	
	var control = Control.new()
	control.add_child(drag_texture)
	#drag_texture.rect_position = -0.5 * drag_texture.get_minimum_size()
	set_drag_preview(control)
	
	return data
	
func _can_drop_data(at_position, data):
	return true
	return false
	
func _drop_data(at_position, data):
	
	pass
