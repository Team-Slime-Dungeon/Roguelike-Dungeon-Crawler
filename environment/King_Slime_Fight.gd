extends Node2D
var Boss_Colors = [.537, .722, .282]

var healthSetupCompleted = false
var fight_state = 0
var king_slime = null
var death_location = null
# Called when the node enters the scene tree for the first time.
func _ready():
	# Color the tiles used for the Boss Fight
	$BossDeco.modulate = Color(
		Boss_Colors[0],
		Boss_Colors[1],
		Boss_Colors[2],
	)

	$BossFloor.modulate = Color(
		Boss_Colors[2],
		Boss_Colors[1],
		Boss_Colors[0],
	)
	#$"../Cassandra".update_camera_scale(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
