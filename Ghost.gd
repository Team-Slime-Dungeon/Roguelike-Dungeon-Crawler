extends Sprite2D
var time_passed = 0.0
var color_change_speed = 5.0  # Increase for faster color changes
func _ready():
	ghosting()
func _process(delta):
	time_passed += delta * color_change_speed
	var hue = abs(sin(time_passed))
	var vivid_color = Color.from_hsv(hue, 1, 1, 1) 
	modulate = vivid_color
func set_property(tx_pos, tx_scale ):
	position = tx_pos
	scale = tx_scale
 
func ghosting():
	var tween_fade = get_tree().create_tween()
 
	tween_fade.tween_property(self, "self_modulate",Color(1, 1, 1, 1), 0.75 )
	await tween_fade.finished
 
	queue_free()
