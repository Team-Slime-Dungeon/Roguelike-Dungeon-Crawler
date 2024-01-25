extends CharacterBody2D
var random = RandomNumberGenerator.new()

func _ready():
	var deco_chance = random.randf_range(0,170)
	# Can adjust rates depending one which you want more of
	if deco_chance <= 20:
		$Decoration_Image.set_frame(0)
	elif deco_chance > 20 and deco_chance <= 40:
		$Decoration_Image.set_frame(1)
	elif deco_chance > 40 and deco_chance <= 60:
		$Decoration_Image.set_frame(2)
	elif deco_chance > 60 and deco_chance <= 80:
		$Decoration_Image.set_frame(3)
	elif deco_chance > 80 and deco_chance <= 100:
		$Decoration_Image.set_frame(4)
	elif deco_chance > 100 and deco_chance <= 120:
		$Decoration_Image.set_frame(5)
	elif deco_chance > 120 and deco_chance <= 140:
		$Decoration_Image.set_frame(6)
	elif deco_chance > 120 and deco_chance <= 160:
		$Decoration_Image.set_frame(7)
	else: # This one is only getting half the chances because it should be rarer
		$Decoration_Image.set_frame(8)

func clear_item():
	queue_free()  # Remove the coin
