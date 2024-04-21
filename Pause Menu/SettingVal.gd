extends Node

const SAVE_PATH = "res://entity.ini"
var colorMode = 3
var toggle


# Called when the node enters the scene tree for the first time.
func _ready():
	loadValues()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadValues():
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	
	for i in config.get_sections():
		#$Settings/Resolution2.select(config.get_value(i, "Resolution"))
		toggle = config.get_value(i, "FullScreen")
		#$Settings/HSlider.value = config.get_value(i, "mainVolume")
		colorMode = config.get_value(i, "Colorblind")
		print(colorMode)
		#$Settings/Mode.arr()
