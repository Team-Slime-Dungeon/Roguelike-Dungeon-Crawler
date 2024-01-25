extends CharacterBody2D
var random = RandomNumberGenerator.new()

func _ready():
	var deco_chance = random.randf_range(0,101)
	if deco_chance <= 50:
		$Decoration_Images.set_frame(0)
	else:
		$Decoration_Images.set_frame(1)

func clear_item():
	queue_free()  # Remove the coin
