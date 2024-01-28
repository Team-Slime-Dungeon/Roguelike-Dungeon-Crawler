extends Panel

func _ready(): pass
func _process(delta): pass

# This scene will give the frame matching the percentage of the armor health left. 
func update(durability: float):
	if durability == 1: $ArmorIcon.frame = 0
	elif durability >= 0.8: $ArmorIcon.frame = 1
	elif durability >= 0.6: $ArmorIcon.frame = 2
	elif durability >= 0.4: $ArmorIcon.frame = 3
	elif durability >= 0.2: $ArmorIcon.frame = 4
	else: $ArmorIcon.frame = 5
