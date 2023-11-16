extends Control

#Pause Value
var is_paused = false : 
	
	#Checks to see if it is paused
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused
		
		
func _ready():
	self.is_paused = false

# Signal to indicate when the pause menu is toggled
signal pause_toggled(is_paused)


#Escape pauses the game
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
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
	print("Settings should pop up here")
