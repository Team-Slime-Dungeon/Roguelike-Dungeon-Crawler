extends TextureRect

@onready var ArmorGUI = preload("res://equipment/armor.tscn")
var maxArmor = 0

func _ready(): pass
func _process(delta): pass

func setArmor(max): 
	var armor = ArmorGUI.instantiate()
	maxArmor = max
	armor.update(max)
	add_child(armor)

func updateArmor(current):
	var armor = get_child(0)
	var durability = current / maxArmor
	armor.update(durability)
	print("Current Durability: ", (durability))
