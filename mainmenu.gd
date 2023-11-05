extends Control
@onready var ani = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	ani.play("dust")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://dungeon.tscn")
	print("pressed")
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.
