extends Control

@onready var ResOptionButton = $"../Resolution2"
@onready var mainVolume = $"../HSlider"
@onready var fullscreenToggle = $"../CheckButton"
var indexRes
var fullScr = false
var a1
var a2
var a3
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
	#FullscreenToggle.pressed = OS.is_window_fullscreen()
	#VsyncToggle.set_pressed_no_signal(OS.is_vsync_enabled())
	#FXAAToggle.set_pressed_no_signal(get_viewport().get_use_fxaa())
	#MSAASlider.set_value(get_viewport().get_msaa())

func AddResolutions():
	for r in Resolutions:
		ResOptionButton.add_item(r)
		

func Centre_Window():
	var Centre_Screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_Size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen-Window_Size/2)




func _on_fullscreen_2_toggled(button_pressed):
	if button_pressed:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)


func _on_resolution_2_item_selected(index):
	var size = ResOptionButton.get_item_text(index)
	get_window().set_size(Resolutions[size])
	Centre_Window()

func _on_save_settings_pressed():
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value(name, "Resolution", indexRes)
	config.set_value(name, "FullScreen", fullscreenToggle.button_pressed)
	config.set_value(name, "mainVolume", mainVolume.value)
	config.save(SAVE_PATH)
