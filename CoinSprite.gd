extends TextureRect
@onready var CoinScene = preload("res://equipment/coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var coin_instance = CoinScene.instantiate()
	add_child(coin_instance)
	var animation_player = coin_instance.get_node("AnimationPlayer")
	animation_player.play("Coin_Spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
