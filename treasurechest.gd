extends StaticBody2D

@onready var anim_player = $AnimationPlayer

var can_open = true # Prevents re-opening
var player_in_area = false

func _ready(): pass
func _process(delta): 
	if player_in_area and Input.is_action_just_pressed("interact") and can_open:
		open_chest()

func _on_interact_body_entered(body):
	if body.name == "Cassandra": player_in_area = true

func _on_interact_body_exited(body):
	if body.name == "Cassandra": player_in_area = false

func open_chest():
	can_open = false # Prevent further interaction
	anim_player.play("opening")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "opening": 
		# Insert pause here for text box
		anim_player.play("vanish")
	elif anim_name == "vanish": queue_free()
