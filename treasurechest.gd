extends Node2D
@onready var anim_player = $AnimationPlayer
var can_open = true # Prevents re-opening

var random = RandomNumberGenerator.new()
@onready var anim_timer = $Timer5

func _ready():
	pass


var player_in_area = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact") and can_open:
		open_chest()


func _on_area_2d_body_entered(body):
	if body.name == "Cassandra": 
		player_in_area = true


func _on_area_2d_body_exited(body):
	if body.name == "Cassandra": 
		player_in_area = false

func open_chest():
	can_open = false # Prevent further interaction
	anim_player.play("opening")




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "opening":
		$AnimationPlayer.play("vanish")
	elif anim_name == "vanish":
		queue_free()



