extends Camera2D

var is_shaking = false
var shake_timer = 0.0
var shake_duration = 0.5  
var shake_intensity = 10.0  

func _process(delta):
	if is_shaking:
		shake_timer += delta
		if shake_timer > shake_duration:
			is_shaking = false
			shake_timer = 0
			position = Vector2()  # Resets Position
		else:
			position += Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))

func start_shake(duration: float, intensity: float):
	is_shaking = true
	shake_timer = 0
	shake_duration = duration
	shake_intensity = intensity
