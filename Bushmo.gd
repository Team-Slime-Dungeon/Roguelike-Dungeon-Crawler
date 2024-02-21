extends CharacterBody2D

var random = RandomNumberGenerator.new()
enum MovementState { UP, DOWN, LEFT, RIGHT }
var move_timer = 0
var current_state = get_direction()
var chase_speed = 10
var speed = 15
var player_chase = false
var currentHealth: int = 3
var max_speed = 20
var death_location = null

@onready var HurtTimer1 = $HurtTimer1
@onready var deathTimer = $deathTimer
#@onready var slimedeathsound = $slimedeathsound
#@onready var slimehitsound  = $slimehitsound

var motion = Vector2.ZERO
var player = null
var monster_type = "Bush Monster"
var monster_drops = [0,0,0,0]
var Body_Color
var Eye_Color
var Detail_Color

func _ready(): 
	if not $BushmoAnim.is_playing():
		$BushmoAnim.play("Idle")
	
	var Body_Color_Vals = [randf_range(.5,1),randf_range(0,.5),randf_range(0,.5)]
	Body_Color = Color(0,Body_Color_Vals[0],0)

	set_color(Body_Color)


func set_color(body_color=null,detail_color=null):
	if body_color != null:
		$Bushmo_Body.modulate = body_color

func _physics_process(delta):		
	if player_chase:
		velocity = (player.position + Vector2(16,16) - self.position) + velocity / chase_speed
		$BushmoAnim.play("walking")			
	
	move_and_slide() # Need for collision
	
func get_direction():
	var current_direction = 5
	match current_direction:
		1: return MovementState.LEFT
		2: return MovementState.DOWN
		3: return MovementState.RIGHT
		4: return MovementState.UP
		5: return null

func _on_hurt_box_area_entered(area):
	if area.name == "weapon" or area.name == "Shuriken":
		#print_debug(currentHealth)
		currentHealth -= 1
		$BushmoAnim.play("hurt")
		#slimehitsound.play()
		if currentHealth > 0:
			HurtTimer1.start()
			await HurtTimer1.timeout
			$BushmoAnim.play("Idle")
			set_color(Body_Color)
		elif currentHealth <= 0:
			deathTimer.start()
			$BushmoAnim.play("retreat")
			await deathTimer.timeout
			#slimedeathsound.play()

			death_location = get_position()

func enemy_clear():
	queue_free()

func _on_detectionarea_body_entered(body):
	if body.name == "Cassandra":
		player = body
		player_chase = true

func _on_detectionarea_body_exited(body):
	if body.name == "Cassandra":
		player = null
		player_chase = false
		$BushmoAnim.play("retreat")
		velocity.x = 0
		velocity.y = 0
	#	print("Player lost.")
