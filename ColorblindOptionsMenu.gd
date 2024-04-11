extends Label

var arr = ["Protanopia", "Deutranopia", "Tritanopia", "Off"]
var modeLabel
var count = SettingVal.colorMode

var bldMode


# Called when the node enters the scene tree for the first time.
func _ready():
	_loadColBlind(count)
	#bldMode = $"../../CanvasLayer/ColorRect"
	#bldMode = get_node("../../../ColorBlind/ColorRectBld")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_setLabel(count)
	pass

func _setLabel(i):
	set_text(arr[i])
	
func _Lbuttonspressed():
	if count != 0:
		count = count-1
		_setLabel(count)
	else:
		count = 0
	print(count)

func _Rbuttonspressed():
	if count < 2:
		count = count+1
		_setLabel(count)
	else:
		_setLabel(3)
		count = 3
	print(count)
	
func _loadColBlind(val):
	set_text(arr[val])
	
