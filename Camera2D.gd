extends Camera2D

# Camera control parameters
@export var zoom_speed: float = 0.1
@export var max_zoom: float = 3.0
@export var min_zoom: float = 0.5
@export var drag_speed: float = 200.0

# Internal variables
var zooming: bool = false
var drag_start: Vector2 = Vector2()
var camera_dragging: bool = false

func  _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		self.zoom -= Vector2(0.1, 0.1)
	if event.is_action_pressed("zoom_out"):
		self.zoom += Vector2(0.1, 0.1)
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				# Start dragging the camera
				camera_dragging = true
				drag_start = event.global_position
			else:
				# Stop dragging the camera
				camera_dragging = false

	if camera_dragging:
		if event is InputEventMouseMotion:
			# Calculate the camera movement based on mouse drag
			var drag_vector = (event.global_position - drag_start) / zoom
			drag_start = event.global_position
			offset += -drag_vector * drag_speed * get_process_delta_time()

	if event is InputEventMouseMotion:
		# Check for mouse wheel input
		if event.is_action("mouse_wheel_up"):
			# Zoom in
			var zoom_factor = 1.0 - zoom_speed
			zoom = clamp(zoom * zoom_factor, min_zoom, max_zoom)
		elif event.is_action("mouse_wheel_down"):
			# Zoom out
			var zoom_factor = 1.0 + zoom_speed
			zoom = clamp(zoom * zoom_factor, min_zoom, max_zoom)
