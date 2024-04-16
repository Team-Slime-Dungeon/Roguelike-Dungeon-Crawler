extends CharacterBody2D

var random = RandomNumberGenerator.new()
enum MovementState { UP, DOWN, LEFT, RIGHT }
var move_timer = 0
var current_state = "idle"
var currentHealth: int = 25

var motion = Vector2.ZERO
var monster_type = "King Slime"
var monster_drops = []

var speed = 15
var max_speed = 20


func get_direction():
	var current_direction = random.randi_range(1, 5)  # Select direction
	match current_direction:
		1: return MovementState.LEFT
		2: return MovementState.DOWN
		3: return MovementState.RIGHT
		4: return MovementState.UP
		5: return null

func _on_hitbox_area_entered(area):
	if area.name == "weapon" or area.name == "Shuriken":
		currentHealth -= 1
		$AnimationPlayer.play("hit")
		#slimehitsound.play()
		if currentHealth > 0:
			$Hurt.start()
			await $Hurt.timeout
			$AnimationPlayer.play("movement")
		
		elif currentHealth == 10:
			var spawn_pos = get_position()
			for i in 5:
				var scene = preload("res://monsters/Slime.tscn")
				var slime = scene.instantiate()
				add_child(slime)
				slime.global_position = spawn_pos
		
		elif currentHealth <= 0:
			$Death.start()
			$AnimationPlayer.play("death")
			await $Death.timeout
			#slimedeathsound.play()

			#death_location = get_position()
	# start at 20
	# when health reduced to 15, split, start timer
	# rejoin health = slimes left * 5

func _ready():
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("movement")
		$"Slime Body/ColorChange".play("Color_Change")
		
func _physics_process(delta): 
	move_timer += delta
	
	if move_timer >= 1.0:  # Adjust this value to control the time for each type of movement
		move_timer = 0
		current_state = get_direction()
	
	match current_state:
		MovementState.UP: velocity.y -= speed * delta
		MovementState.LEFT: velocity.x -= speed * delta
		MovementState.DOWN: velocity.y += speed * delta
		MovementState.RIGHT: velocity.x += speed * delta
	
	if velocity.x >= max_speed: velocity.x = max_speed
	if velocity.y >= max_speed: velocity.y = max_speed

	move_and_slide() # Need for collision

func enemy_clear(): queue_free()
