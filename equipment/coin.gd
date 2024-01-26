extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer

signal coin_collected  # Signal when coin is collected
var picked_up = false
var ID = 0
var amount = 1

func _process(_delta):
	_animation_player.play("Coin_Spin")

func clear_item():
	queue_free()  # Remove the coin
	
#Detects If Cassandra Enters the Area2D (Coin)
func _on_player_detection_body_entered(body):
	if body.name == "Cassandra": 
		print("Cassandra found a Coin!")
		emit_signal("coin_collected", amount) #Collects coin and emits signal
		picked_up = true
