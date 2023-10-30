extends Button

@onready var ani = get_node("../../AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	ani.play("dust")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_mouse_entered():
	#print("Hovered", Time.get_datetime_dict_from_system())
	ani.play("buttonpl")
	pass # Replace with function body.
