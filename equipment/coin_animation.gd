extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer

func _process(_delta):
	#if Input.is_action_pressed("ui_right"):
	_animation_player.play("Coin_Spin")
	#else:
	#	_animation_player.stop()
