extends CanvasLayer

@onready var transition = $transition

func _on_restart_button_pressed():
	transition.play("fade_out")
	#get_tree().change_scene_to_file("res://dungeon.tscn")
	#pass # Replace with function body.


func _on_quit_button_pressed():
	#transition.play("fade_in")
	get_tree().change_scene_to_file("res://MainMenuStart.tscn")
	#pass # Replace with function body.


func _on_transition_animation_finished(fade_out):
	get_tree().change_scene_to_file("res://dungeon.tscn")
