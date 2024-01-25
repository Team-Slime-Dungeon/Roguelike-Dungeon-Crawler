extends Node2D

@onready var anim = get_node("AnimationPlayer")

#intro sequence plays
#once animation finishes, switches to dungeon scene
func _ready():
	anim.play("intro")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://dungeon.tscn")
	pass # Replace with function body.



func _process(delta):
	pass

#skip button
func _on_skip_button_pressed():
	get_tree().change_scene_to_file("res://dungeon.tscn")
	pass # Replace with function body.
