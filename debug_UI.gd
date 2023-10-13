extends CanvasLayer
@export var zoom_speed: float = 0.1
@export var max_zoom: float = 3.0
@export var min_zoom: float = 0.5
@export var drag_speed: float = 200.0

@onready var cam = get_node("../Cassandra/Camera2D")
@onready var CAS = get_node("../Cassandra")
var zoom_min= Vector2(.1000001,.1000001) # min zoom
var zoom_max  = Vector2(1.0,1.0)# max zoom
var zoom_speed1 = Vector2(.3000001,.3000001)# speed of zooming
var velocity =  Vector2();

func _on_in_zoom_pressed():
	#if cam.zoom < zoom_m:
	cam.zoom += zoom_speed1
	print(cam.zoom)

func _on_out_zoom_pressed():
	if cam.zoom > zoom_min:
		cam.zoom -= zoom_speed1
	print(cam.zoom)

func _on_left_pressed():
	velocity.x -= 100.0
	cam.position = velocity

func _on_right_pressed():
	velocity.x += 100.0
	cam.position = velocity

func _on_back_pressed():
	cam.position = CAS.position

func _on_up_pressed():
	velocity.y -= 100.0
	cam.position = velocity

func _on_down_pressed():
	velocity.y += 100.0
	cam.position = velocity
