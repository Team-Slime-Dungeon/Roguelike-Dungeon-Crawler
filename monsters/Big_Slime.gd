extends CharacterBody2D

var random = RandomNumberGenerator.new()
#enum MovementState { UP, DOWN, LEFT, RIGHT }
#var move_timer = 0
var current_state = "idle"
var currentHealth: int = 3

var motion = Vector2.ZERO
var monster_type = "Boss Slime"
var monster_drops = []

func _ready():
	if not $BigAnim.is_playing():
		$BigAnim.play("movement")
		$"Big Slime Body/ColorChange".play("Color_Change")
		
func _physics_process(delta):
	pass

func enemy_clear():
	queue_free()
	#print("Slime cleared")
