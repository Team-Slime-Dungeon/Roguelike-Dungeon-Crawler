extends Control
@onready var ani = get_node("AnimationPlayer")
@onready var ani2 = get_node("AnimationPlayer2")
@onready var ani3 = get_node("AnimationPlayer3")

# Called when the node enters the scene tree for the first time.
func _ready():
	#ani.play("dust")
	ani2.play("fire")
	ani3.play("particle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Story/Intro/intro.tscn")
	#print("pressed")
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_button_pressed():
	#ani.play("Remove")
	$Sets.show()
	pass # Replace with function body.


func _on_button_Back_pressed():
	#ani.play("Bring back")
	$Sets.hide()
	pass # Replace with function body.
