extends Line2D

var trail_points = PackedVector2Array()
var max_points = 20
var trail_active = false
var reset_trail_on_next_attack = false
var previous_position = Vector2()
func _ready():
	self.width = -10  # Adjust the value to make the trail thicker
func _draw():
	if trail_points.size() > 1:
		var end_color = Color(0.0, 0.0, 0.0, 0.0)  # Black, fully transparent
		var start_color = Color(1.0, 1.0, 1.0, 1.0)  # White, fully opaque
		for i in range(1, trail_points.size()):
			var local_start = to_local(trail_points[i - 1])
			var local_end = to_local(trail_points[i])
			var t = float(i) / trail_points.size()  # Normalized position along the trail
			var color = start_color.lerp(end_color, t)
			draw_line(local_start, local_end, color, self.width)

func _process(delta):
	if trail_active:
		var current_position = global_position
		var velocity = (current_position - previous_position) / delta
		var speed = velocity.length()
		
		# Update the previous position for the next frame
		previous_position = current_position
		
		# Dynamically adjust the trail's width based on speed
		self.width = clamp(speed * 0.1, 5, 20)


		if trail_points.size() == 0 or trail_points[0] != current_position:
			trail_points.insert(0, current_position)
			if trail_points.size() > max_points:
				trail_points.resize(max_points)
				  # Trigger redraw
		_draw()
	else:
		previous_position = global_position

func start_trail():
	if not trail_active or reset_trail_on_next_attack:
		trail_active = true
		reset_trail_on_next_attack = false  # Prevent immediate reset if just started

func stop_trail():
	trail_active = false
	reset_trail_on_next_attack = true  # Mark for resetting on the next attack start
