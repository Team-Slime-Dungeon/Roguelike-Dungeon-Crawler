extends CanvasLayer




func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://dungeon.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://MainMenuStart.tscn")
	pass # Replace with function body.
