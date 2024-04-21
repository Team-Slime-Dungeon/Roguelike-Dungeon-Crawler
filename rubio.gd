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

var follow_distance = 35

var target_enemy = null
const attack_detection = 150
const attack_radius = 50

var chasing_enemy = false

var projectile
var attack_cool_down = 2.0
var time_Since_Last_Attack = 0.0
var attack_range = 100
var projectile_spawns = []
var projectile_ID = 0

var camera_scale = 2
var enemy_count = 0
var enemy_flag = false
var trgt = null
enum{
	IDLE, 
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	Global.companion_following = false
	
func _process(delta):
	#if has_chatted == false:
		#if current_state == 0 or current_state == 1:
			#$AnimationPlayer.play("Idle_Right")
		#elif current_state == 2 and !is_chatting:
			#if (dir.x == -1):
				#$AnimationPlayer.play("Walk_Left")
			#if (dir.x == 1):
				#$AnimationPlayer.play("Walk_Right")
			#if (dir.y== -1):
				#$AnimationPlayer.play("Walk_Left")
			#if (dir.y == 1):
				#$AnimationPlayer.play("Walk_Right")
	
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				#dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				pass
			MOVE:
				#move(delta)
				pass
	
	if Input.is_action_just_pressed("interact") and player_in_chat_zone == true:
		#print("Chatting...")
		$Dialogue.start()
		is_roaming = false
		is_chatting = true
		$AnimationPlayer.play("Idle_Right")
	
	#rubio follows player if player has chatted with rubio
	enemy_count = find_nearby_enemies()
	#print("Current Enemy Count is: ", enemy_count)
	
	if enemy_count > 0:
		time_Since_Last_Attack += delta
		if time_Since_Last_Attack >= attack_cool_down:
			if within_attack_range() == true:
				trgt = find_target()
				attack(trgt)
				time_Since_Last_Attack = 0.0
						
				
	elif  Global.companion_following == true and enemy_count == 0:
		follow_player()
		
func find_nearby_enemies():
	var curr_enemy_count = 0
	var bodies = $attack_detection.get_overlapping_bodies()
	for body in bodies:
		if body != null and body != self and body.has_method("is_enemy") and body.is_enemy(): 
			curr_enemy_count += 1
	
	return curr_enemy_count
	
func within_attack_range():
	var bodies = $attack_detection.get_overlapping_bodies()
	for body in bodies:
		if body != null and body != self and body.has_method("is_enemy") and body.is_enemy():
			if global_position.distance_to(body.global_position) <= attack_range:
				return true	
			else:
				return false
				
func find_target():
	var bodies = $attack_detection.get_overlapping_bodies()
	var target = null
	for body in bodies:
		if body != null and body != self and body.has_method("is_enemy") and body.is_enemy(): 
			target = body
			break
	return target
		
func attack(body):
	var tossed_item = preload("res://equipment/Shuriken.tscn")
	var attack_direction

	attack_direction = (body.global_position - global_position).normalized()
	var new_projectile_spawn = tossed_item.instantiate()
	var new_projectile_location = position / camera_scale
	projectile_spawns.append(new_projectile_spawn)
	add_child(new_projectile_spawn)
	projectile_spawns[projectile_ID].global_position = new_projectile_location
	projectile_spawns[projectile_ID]._set_dir(attack_direction)
	projectile_ID += 1	
	#print("rubio is attacking")
				
func follow_player():
		var distance = Global.player_position.distance_to(global_position)
		dir = Global.player_direction
		if distance > follow_distance:
			velocity = global_position.direction_to(Global.player_position) * 100
			update_follow_animations(dir)
			move_and_slide()
			
func update_follow_animations(dir):
	if (dir.x == -1):
		$AnimationPlayer.play("Walk_Left")	
	if (dir.x == 1):
		$AnimationPlayer.play("Walk_Right")
	if (dir.y== -1):
		$AnimationPlayer.play("Walk_Left")
	if (dir.y == 1):
		$AnimationPlayer.play("Walk_Right")
		
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
	


func _on_attack_detection_body_entered(body):
	if body.name == "Slime" or body.name == "Bushmo":
		enemy_flag = true
	


func _on_attack_detection_body_exited(body):
	if body.name == "Slime" or body.name == "Bushmo":
		enemy_flag = false
	
	pass # Replace with function body.
