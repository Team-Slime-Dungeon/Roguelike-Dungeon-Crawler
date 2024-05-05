extends Control

#Pause Value
var check_setting
var center_container
@onready var mainVolume = $"../HSlider"
@onready var fullscreenToggle = $"../Settings/Fullscreen2"
var indexRes
var fullScr = false
var a1
var a2
var a3
const SAVE_PATH = "res://entity.ini"
var is_paused = false : 
	
	#Checks to see if it is paused
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused
		
		
func _ready():
	self.is_paused = false
	center_container = get_node("CenterContainer")
	check_setting = get_node("Settings")
# Signal to indicate when the pause menu is toggled
signal pause_toggled(is_paused)


#Escape pauses the game
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		if check_setting.visible:
			# If settings are visible, hide them and show the pause menu
			check_setting.hide()
			center_container.show()
		else:
			# Toggle the pause state
			self.is_paused = !is_paused
			emit_signal("pause_toggled", is_paused)

#Resume button
func _on_resume_pressed():
	self.is_paused = false

#Save and Quit button
func _on_save_quit_pressed():
	get_tree().quit()
	print("Saving....")

#Settings button
func _on_settings_pressed():
	center_container.hide()
	check_setting.show()
	#print("Settings should pop up here")

func _on_back_pressed():
	check_setting.hide()
	#_on_save_settings_pressed()  #currently working on
	center_container.show()
	
func _on_save_settings_pressed():
	var config := ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("Setting", "Resolution", $Settings/Resolution2.selected)
	config.set_value("Setting", "FullScreen", $Settings/Fullscreen2.button_pressed)
	config.set_value("Setting", "mainVolume", $Settings/HSlider.value)
	config.set_value("Setting", "Colorblind", $Settings/Mode.count)
	print($Settings/Mode.count)
	config.save(SAVE_PATH)
	pass # Replace with function body.	
