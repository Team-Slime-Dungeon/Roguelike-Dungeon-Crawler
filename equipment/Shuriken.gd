extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer

signal Shuriken_Thrown
var picked_up = false
var shuriken_dir = Vector2.ZERO
var shuriken_speed = 20
var shuriken_vel = Vector2.ZERO
#var ID = 21
#var amount = 1

func _ready():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Shuriken_Throw")
		
func _physics_process(delta):
	self.velocity += shuriken_dir * shuriken_speed
	#move_and_collide(shuriken_vel)
	move_and_slide()
	
	if get_slide_collision_count() != 0:
		#print("Shuriken Collision")
		clear_item()
		
#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
#		var collider = collision.get_collider()
#		print_debug(">",collider.name)
		
func _set_dir(given_direction):
	var temp = round(given_direction)
	if temp != Vector2(0,0):
	#	temp = Vector2(-1,1)
		shuriken_dir = temp
	else:
		clear_item()
	
func clear_item():
	queue_free()  # Remove the coin
	
#Detects If Cassandra Enters the Area2D (Coin)
#func _on_player_detection_body_entered(body):
	#if body.name == "Cassandra": 
		#print("Cassandra found a Blue Mushroom!")
#		emit_signal("Blue_Mushroom_Collected") #Collects coin and emits signal
#		picked_up = true

#func _on_player_detection_area_entered(area):
#	pass # Replace with function body.
