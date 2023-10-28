extends CharacterBody2D
var collision_count = 0
const SPEED = 250.0
signal healthChanged
@export var maxHealth = 3
@onready var currentHealth: int = maxHealth
@export var knockbackPower: int = 2000
func get_input():
	var input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input_dir * SPEED
	
func _physics_process(delta):
	handleCollision()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_input()
	#move_and_collide(velocity * delta)
	move_and_slide()
	
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)


func _on_hurtbox_area_entered(area):
	if area.name == "hitBox":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = maxHealth
		healthChanged.emit(currentHealth)
		knockback(area.get_parent().velocity)
func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
