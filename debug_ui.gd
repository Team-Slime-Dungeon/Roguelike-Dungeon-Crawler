class_name debug_ui extends CanvasLayer

@export var zoom_speed: float = 0.1
@export var max_zoom: float = 3.0
@export var min_zoom: float = 0.5
@export var drag_speed: float = 200.0
@export var shake_duration: float = 0.5
@export var shake_intensity: float = 5.0

var zoom_min= Vector2(.1000001,.1000001) # min zoom
var zoom_max  = Vector2(1.0,1.0)# max zoom
var zoom_speed1 = Vector2(.3000001,.3000001)# speed of zooming
var velocity =  Vector2();

var is_shaking = false
var shake_timer = 0.0

func _process(delta):
	if is_shaking:
		shake_timer += delta #modifies the camera's position
		if shake_timer >= shake_duration:
			is_shaking = false
			shake_timer = 0.0
			#cam.position = CAS.position #Returns to player Cam
			#cam.position = cam.position #Returns to Debug Cam
		else:
				var random_offset = Vector2(randf() * 2 - 1, randf() * 2 - 1) * shake_intensity
				#cam.position = cam.position + random_offset #Returns to Debug Cam
				#cam.position = CAS.position + random_offset  #Returns to Player Cam

func _on_zoom_in_pressed():
	#if cam.zoom < zoom_m:
	#cam.zoom += zoom_speed1
	pass

func _on_zoom_out_pressed():
	#if cam.zoom > zoom_min: cam.zoom -= zoom_speed1
	pass

func _on_left_pressed():
	velocity.x -= 100.0
	#cam.position = velocity

func _on_right_pressed():
	velocity.x += 100.0
	#cam.position = velocity

func _on_up_pressed():
	velocity.y -= 100.0
	#cam.position = velocity

func _on_down_pressed():
	velocity.y += 100.0
	#cam.position = velocity

func _on_shake_pressed():
	is_shaking = true
