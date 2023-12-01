extends Node

var dead_sound = load("res://Music/dead_sound2.mp3")

func _ready():
	pass   
	

func play_music():
	$dead.stream = dead_sound
	$dead.play()
