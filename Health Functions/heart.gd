extends Panel

func _ready(): pass 
func _process(delta): pass

func update(whole: bool):
	if whole: $Sprite2D.frame = 0
	else: $Sprite2D.frame = 4
