extends AudioStreamPlayer
var isAudioPlaying = true

func _ready():
	set_process_input(true)
	

func _process(delta):
	if Input.is_action_pressed("reproduce"):
		toggle_audio()  

func toggle_audio():
	if isAudioPlaying:
		stop()
	else:
		play()
	isAudioPlaying = not isAudioPlaying 
