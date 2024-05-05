extends CharacterBody2D
@export var knockbackPower: int = 500
const speed = 30



var is_chatting = false
var has_chatted = false
var death_location = null

var player
var player_in_chat_zone = false
var dir = Vector2.RIGHT
var start_pos

var follow_distance = 25




var chasing_enemy = false

var projectile
var attack_cool_down = 1
var time_Since_Last_Attack = 0.0
var attack_range = 100
var projectile_spawns = []
var projectile_ID = 0

var camera_scale = 2
var enemy_count = 0
var enemy_flag = false
var trgt = null

var total_health = 15


func _ready():
	pass
	
	
func _process(delta):
	#print("Total health at the beginning, ", total_health)
	if Input.is_action_just_pressed("interact") and player_in_chat_zone == true:
		#print("Chatting...")
		$Dialogue.start()
		
		is_chatting = true
		$AnimationPlayer.play("Idle_Right")
	
	#rubio follows player if player has chatted with rubio
	enemy_count = find_nearby_enemies()
	#print("Current Enemy Count is: ", enemy_count)
	
	if enemy_count > 0 and Global.companion_following:
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
	var last_dir = Vector2(0,0)
	#print(Global.player_velocity)
	if Global.player_velocity == Vector2.ZERO:
		#print("entered idle")
		if last_dir.x == 1:
			$AnimationPlayer.play("Idle_Left")
		else:
			$AnimationPlayer.play("Idle_Right")
			#print("entered idle right")
	else:
		if (dir.x == -1):
			last_dir.x = -1
			$AnimationPlayer.play("Walk_Left")	
		if (dir.x == 1):
			last_dir.x = 1
			$AnimationPlayer.play("Walk_Right")
		if (dir.y== -1):
			$AnimationPlayer.play("Walk_Left")
		if (dir.y == 1):
			$AnimationPlayer.play("Walk_Right")
		
func enemy_clear(): queue_free()
		
func is_ally():
	return true	
		

func _on_chat_detection_area_body_entered(body):
	if body.name =="Cassandra":
		player = body
		player_in_chat_zone = true
		#print("Player is in chat area")


func _on_chat_detection_area_body_exited(body):
	if body.name =="Cassandra":
		player_in_chat_zone = false
		#print("Player has left chat area")
	





func _on_dialogue_dialogue_finished():
	is_chatting = false
	
	has_chatted = true
	Global.companion_following = true
	


func _on_attack_detection_body_entered(body):
	if body.name == "Slime" or body.name == "Bushmo":
		enemy_flag = true
	


func _on_attack_detection_body_exited(body):
	if body.name == "Slime" or body.name == "Bushmo":
		enemy_flag = false
	

func choose(array):
	array.shuffle()
	return array.front()

func _on_hurtbox_area_entered(area):
	var decision = choose([1,1,1,1,2,2,2,1]) # 1 means dodge, 2 means get hit
	if area.name == "hitBox" or area.name =="hitBox2" and Global.companion_following:
		if decision == 1:
			print("Rubio has dodged attack!")
		if decision == 2:
			total_health -= 1
			print(total_health)
		if total_health < 0:
			death_location = get_position()
			queue_free()
		
