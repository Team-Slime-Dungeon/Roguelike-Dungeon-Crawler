extends CharacterBody2D

const speed = 30

var current_state = IDLE 
var is_roaming = true
var is_chatting = false
var has_chatted = false
var is_following = false

var player
var player_in_chat_zone = false
var dir = Vector2.RIGHT
var start_pos

var follow_distance = 30

enum{
	IDLE, 
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	
func _process(delta):
	if has_chatted == false:
		if current_state == 0 or current_state == 1:
			$AnimationPlayer.play("Idle_Right")
		elif current_state == 2 and !is_chatting:
			if (dir.x == -1):
				$AnimationPlayer.play("Walk_Left")
			if (dir.x == 1):
				$AnimationPlayer.play("Walk_Right")
			if (dir.y== -1):
				$AnimationPlayer.play("Walk_Left")
			if (dir.y == 1):
				$AnimationPlayer.play("Walk_Right")
	
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
	
	if Input.is_action_just_pressed("interact") and player_in_chat_zone == true:
		#print("Chatting...")
		$Dialogue.start()
		is_roaming = false
		is_chatting = true
		$AnimationPlayer.play("Idle_Right")
	
	#rubio follows player if player has chatted with rubio
	if has_chatted:
		#dir = (Global.player_position - global_position).normalized()
		is_roaming = false
		var distance = Global.player_position.distance_to(global_position)
		#print("distance is ", distance)
		dir = Global.player_direction
		
		if distance > follow_distance:
			velocity = global_position.direction_to(Global.player_position) * 100
			
			
			if (dir.x == -1):
				$AnimationPlayer.play("Walk_Left")
				
			if (dir.x == 1):
				$AnimationPlayer.play("Walk_Right")
			if (dir.y== -1):
				$AnimationPlayer.play("Walk_Left")
			if (dir.y == 1):
				$AnimationPlayer.play("Walk_Right")
			
			move_and_slide()
		
func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !is_chatting:
		position += dir * speed * delta 	
		

func _on_chat_detection_area_body_entered(body):
	if body.name =="Cassandra":
		player = body
		player_in_chat_zone = true
		#print("Player is in chat area")


func _on_chat_detection_area_body_exited(body):
	if body.name =="Cassandra":
		player_in_chat_zone = false
		#print("Player has left chat area")
	


func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])


func _on_dialogue_dialogue_finished():
	is_chatting = false
	is_roaming = true
	has_chatted = true
	Global.companion_following = true
	
