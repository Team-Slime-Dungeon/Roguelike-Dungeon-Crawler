extends Control

@onready var ResOptionButton = $"../ResolutionButton"

#------- Below additional setting Not implemented
#onready var FullscreenToggle = $Options/FullscreenContainer/FullScreenToggle
#onready var VsyncToggle = $Options/VsyncContainer/VSYNCHECK
#onready var FXAAToggle = $Options/FXAAContainer/FXAACheck
#onready var MSAASlider = $Options/MSAA/MSAASlider
#----------------------------------
@onready var mainVolume = $"../HSlider"
@onready var fullscreenToggle = $"../CheckButton"
var indexRes
var fullScr = false
var a1
var a2
var a3
var colorblind
const SAVE_PATH = "res://entity.ini"

var Resolutions: Dictionary = {"3840x2160":Vector2i(3840,2160),
								"2560x1440":Vector2i(2560,1440),
								"1920x1080":Vector2i(1920,1080),
								"1366x768":Vector2i(1366,768),
								"1536x864":Vector2i(1536,864),
								"1280x720":Vector2i(1280,720),
								"1440x900":Vector2i(1440,900),
								"1600x900":Vector2i(1600,900),
								"1024x600":Vector2i(1024,600),
								"800x600": Vector2i(800,600)}

func _ready():
	AddResolutions() 
	loadSettings() #calls to Load settings


func AddResolutions():
	for r in Resolutions:
		ResOptionButton.add_item(r)
		

func _on_OptionButton_item_selected(index):
	var size = ResOptionButton.get_item_text(index)
	get_window().set_size(Resolutions[size])
	Centre_Window()

func Centre_Window():
	var Centre_Screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_Size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen-Window_Size/2)



func _on_check_button_toggled(button_pressed):
	if button_pressed:
		get_window().set_mode(Window.MODE_FULLSCREEN)
		if fullscreenToggle.button_pressed == false:
			fullscreenToggle.button_pressed = true
	else:
		get_window().set_mode(Window.MODE_WINDOWED)
		
	
	pass # Replace with function body.

func _on_save_settings_pressed():
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("Setting", "Resolution", $"../ResolutionButton".selected)
	config.set_value("Setting", "FullScreen", fullscreenToggle.button_pressed)
	config.set_value("Setting", "mainVolume", mainVolume.value)
	config.save(SAVE_PATH)
	pass # Replace with function body.
	
func loadSettings():
	var config := ConfigFile.new()
	
	config.load(SAVE_PATH)
	for i in config.get_sections():
		a1 = config.get_value(i, "Resolution")
		a2 = config.get_value(i, "FullScreen")
		a3 = config.get_value(i, "mainVolume")
		#SettValues.clrbnd = config.get_value(i, "colorblind")
		#print(SettValues.clrbnd)
	
	#ResOptionButton.select(a1)
	_on_check_button_toggled(a2)
	_on_OptionButton_item_selected(a1)
	mainVolume.value = a3
