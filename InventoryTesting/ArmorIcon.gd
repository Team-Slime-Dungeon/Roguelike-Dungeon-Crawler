extends TextureRect
var current_texture: Texture
@onready var ArmorGUI = preload("res://equipment/armor.tscn")
@onready var defaultTexture = preload("res://InventoryTesting/InventoryBackgroundPics/Sheild Slot.png")
var maxArmor = 0
var armor = null
func _ready():pass
	
	

func _process(delta):pass


func remove_armor():
	print("armor removed")
	texture = defaultTexture
	print("Texture after removal: ", texture)
	#set_slot_texture("")
	
func set_slot_texture(texture_path: String):
	if texture_path != "":
		current_texture = load(texture_path)
		#modulate = Color(1, 1, 1, 1)  # Full color for any non-default texture
	else:
		current_texture = defaultTexture
		#modulate = Color(0.784, 0.784, 0.784, 0.5)  # Apply ghostly, semi-transparent modulate for default texture
	texture = current_texture
