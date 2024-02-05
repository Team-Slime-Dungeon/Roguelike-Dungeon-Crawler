extends StaticBody2D

@onready var anim_player = $AnimationPlayer

var can_open = true # Prevents re-opening
var player_in_area = false
var chest_opened = false

func _ready(): pass
func _process(delta): 
	if player_in_area and Input.is_action_just_pressed("interact") and can_open: 
		open_chest()

func _on_interact_body_entered(body):
	if body.name == "Cassandra": player_in_area = true

func _on_interact_body_exited(body):
	if body.name == "Cassandra": player_in_area = false

func open_chest():
	$AnimationPlayer.play("opening")
	can_open = false # Prevent further interaction	
	chest_opened = true

func _on_animation_player_animation_finished(opening):
	anim_player.play("open")

func clear_chest():
	$AnimationPlayer.play("vanish")
	queue_free()
