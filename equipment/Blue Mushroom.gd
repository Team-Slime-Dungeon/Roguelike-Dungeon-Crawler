extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer

signal Blue_Mushroom_Collected
var picked_up = false
var ID = 71
var amount = 1

func _process(_delta):
#	_animation_player.play("Coin_Spin")
	pass

func clear_item():
	queue_free()  # Remove the coin
	
#Detects If Cassandra Enters the Area2D (Coin)
func _on_player_detection_body_entered(body):
	if body.name == "Cassandra": 
		#print("Cassandra found a Blue Mushroom!")
		emit_signal("Blue_Mushroom_Collected") #Collects coin and emits signal
		picked_up = true

func _on_player_detection_area_entered(area):
	pass # Replace with function body.
